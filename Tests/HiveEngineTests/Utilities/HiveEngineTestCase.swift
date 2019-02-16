//
//  HiveEngineTestCase.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-14.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
import Foundation

class HiveEngineTestCase: XCTestCase {

	// MARK: - Properties

	private static let RECORD_MODE = "RecordMode"

	/// Indicates if tests are being recorded
	var recordMode: Bool {
		if let envRecordMode = ProcessInfo.processInfo.environment["RECORD_MODE"], let recordMode = Bool(envRecordMode) {
			return recordMode
		}

		return false
	}

	private var suiteName: String {
		let suiteStartIndex = name.index(after: name.index(after: name.startIndex))
		let suiteEndIndex = name.firstIndex(of: " ") ?? name.endIndex
		return String(name[suiteStartIndex..<suiteEndIndex])
	}

	private var testName: String {
		let testStartIndex = name.index(after: name.firstIndex(of: " ") ?? name.index(before: name.endIndex))
		let testEndIndex = name.index(before: name.endIndex)
		return String(name[testStartIndex..<testEndIndex])
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
		return baseURL.appendingPathComponent("Fixtures", isDirectory: true)
	}

	/// Destination for an Encodable fixture.
	private func destination<T>(for obj: T) -> URL {
		return fixtureDestination.appendingPathComponent(suiteName, isDirectory: true)
			.appendingPathComponent("\(testName)_\(String(describing: type(of: obj))).json")
	}

	/// Assert a decodable can be decoded from a fixture.
	///
	/// Parameters:
	///   - decodable: the decodable object
	func XCTAssertDecodable<T: Decodable & Equatable>(_ decodable: T) {
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
	func XCTAssertEncodable<T: Encodable>(_ encodable: T) {
		let destination = self.destination(for: encodable)

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
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

	private func recordEncodable(_ encodableString: String, at destination: URL) {
		do {
			try FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
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
