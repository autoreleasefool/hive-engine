//
//  UHPCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-01-12.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class UHPCommandTests: HiveEngineTestCase {
	func testInfoCommand() {
		let result = InfoCommand().invoke("", state: nil)
		XCTAssertEqual(.output("id Hive Engine v2.0.0\nMosquito;Ladybug;Pillbug"), result)
	}

	func testNewGameCommand_Base() {
		let result = NewGameCommand().invoke("Base", state: nil)
		XCTAssertEqual(.state(GameState()), result)
	}

	func testNewGameCommand_BaseMLP() {
		let result = NewGameCommand().invoke("Base+MLP", state: nil)
		XCTAssertEqual(.state(GameState(options: [.mosquito, .ladyBug, .pillBug])), result)
	}

	func testNewGameCommand_GameString() {
		let state = GameState()
		state.apply(.place(unit: state.whiteSpider, at: .origin))
		state.apply(.place(unit: state.blackHopper, at: Position(x: -1, y: 1, z: 0)))
		state.apply(.place(unit: state.whiteAnt, at: Position(x: 1, y: 0, z: -1)))
		state.apply(.place(unit: state.blackSpider, at: Position(x: -2, y: 1, z: 1)))

		let result = NewGameCommand().invoke("Base;InProgress;White[3];wS1;bG1 -wS1;wA1 wS1/;bS1 /bG1", state: nil)
		XCTAssertEqual(.state(state), result)
	}

	static var allTests = [
		("testInfoCommand", testInfoCommand),
	]
}
