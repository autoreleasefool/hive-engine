//
//  EngineTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-14.
//

import HiveEngineTestUtilities
import Regex
import XCTest
@testable import HiveEngine

final class EngineTests: HiveEngineTestCase {

	func testEngineHasNoInitialState() {
		let engine = Engine()
		XCTAssertNil(engine.state)
	}

	func testEngineIgnoresInvalidCommand() {
		let engine = Engine()
		XCTAssertEqual(nil, engine.send(input: ""))
		XCTAssertEqual(nil, engine.send(input: "INVALID"))
	}

	func testEngineParsesCommand() {
		let engine = Engine()

		guard case let .output(message) = engine.send(input: "info") else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(message.starts(with: "id"))
	}

	func testEngineParsesCommandAndInput() {
		let engine = Engine()
		XCTAssertEqual(.state(GameState()), engine.send(input: "newgame Base;NotStarted;White[1]"))
	}
}
