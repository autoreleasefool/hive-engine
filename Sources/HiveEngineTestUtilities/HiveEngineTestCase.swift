//
//  HiveEngineTestCase.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
import Foundation
@testable import HiveEngine

open class HiveEngineTestCase: XCTestCase {

	// MARK: - Properties

	private static let RECORD_MODE = "RecordMode"

	/// Indicates if tests are being recorded
	public var recordMode: Bool {
		if let envRecordMode = ProcessInfo.processInfo.environment["RECORD_MODE"], let recordMode = Bool(envRecordMode) {
			return recordMode
		}

		return false
	}

	// MARK: - State Provider

	private(set) public var stateProvider: GameStateProvider!

	override public func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	// MARK: - URLs

	/// Location of test directory
	private var baseURL: URL {
		var url = URL(fileURLWithPath: #file)
		while url.lastPathComponent != "Tests" {
			url.deleteLastPathComponent()
		}
		return url
	}

	/// Location of fixtures
	private var fixtureDestination: URL {
		baseURL.appendingPathComponent("Fixtures", isDirectory: true)
	}

	/// Destination for an Encodable fixture.
	private func destination<T>(for obj: T) -> URL {
		let fixtureName = name.replacingOccurrences(of: "[", with: "")
			.replacingOccurrences(of: "]", with: "")
			.replacingOccurrences(of: "-", with: "")
			.replacingOccurrences(of: " ", with: ".")
		return fixtureDestination.appendingPathComponent("\(fixtureName)_\(String(describing: type(of: obj))).json")
	}

	/// Assert a decodable can be decoded from a fixture.
	///
	/// Parameters:
	///   - decodable: the decodable object
	public func XCTAssertDecodable<T: Decodable & Equatable>(_ decodable: T) {
		let destination = self.destination(for: decodable)
		do {
			let encodedString = try String(contentsOf: destination, encoding: .utf8)
			guard let data = encodedString.data(using: .utf8) else {
				XCTFail("Failed to read fixture.")
				return
			}

			let decoder = JSONDecoder()
			let decoded: T = try decoder.decode(T.self, from: data)
			XCTAssertEqual(decodable, decoded)
		} catch {
			XCTFail("Failed to read fixture.")
		}
	}

	/// Assert an Encodable object's state.
	///
	/// Parameters:
	///   - encodable: the object which will be asserted against a file locally.
	public func XCTAssertEncodable<T: Encodable>(_ encodable: T) {
		let destination = self.destination(for: encodable)

		let encoder = JSONEncoder()
		#if !os(macOS)
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		#endif
		if #available(OSX 10.13, *) {
			encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		}

		guard let data = try? encoder.encode(encodable),
			let encodableString = String(data: data, encoding: .utf8) else {
			XCTFail("Failed to encode.")
			return
		}

		if recordMode {
			recordEncodable(encodableString, at: destination)
			XCTFail("Recorded encodable to `\(destination.absoluteString)`")
		} else {
			assertEncodable(encodableString, at: destination)
		}
	}

	public func XCTAssertFatalError(expectedMessage: String, testcase: @escaping () -> Void) {
		let expectation = self.expectation(description: "expectingFatalError")
		var assertionMessage: String?

		FatalErrorUtil.replaceFatalError { message, _, _ in
			assertionMessage = message
			expectation.fulfill()
			self.unreachable()
		}

		DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

		waitForExpectations(timeout: 2) { _ in
			XCTAssertEqual(assertionMessage, expectedMessage)
			FatalErrorUtil.restoreFatalError()
		}
	}

	private func unreachable() -> Never {
		repeat {
			RunLoop.current.run()
		} while (true)
	}

	private func recordEncodable(_ encodableString: String, at destination: URL) {
		do {
			try FileManager.default.createDirectory(
				at: destination.deletingLastPathComponent(),
				withIntermediateDirectories: true
			)
			try encodableString.write(to: destination, atomically: false, encoding: .utf8)
		} catch {
			XCTFail("Failed to record test: \(error)")
			return
		}
	}

	private func assertEncodable(_ encodableString: String, at destination: URL) {
		do {
			let expectedString = try String(contentsOf: destination, encoding: .utf8)
			XCTAssertEqual(expectedString, encodableString)
		} catch {
			XCTFail("Failed to read fixture.")
		}
	}
}
