//
//  Unit+BeetleTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-25.
//

import XCTest
@testable import HiveEngine

final class UnitBeetleTests: HiveEngineTestCase {

	var stateProvider: GameStateProvider!

	override func setUp() {
		super.setUp()
		stateProvider = GameStateProvider()
	}

	func testBeetle_CanMoveAsBeetleOrQueen() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 12, to: state)
		HiveEngine.Unit.Class.allCases.forEach {
			switch $0 {
			case .beetle, .queen:
				XCTAssertTrue(state.whiteBeetle.canMove(as: $0, in: state))
			case .ant, .hopper, .ladyBug, .mosquito, .pillBug, .spider:
				XCTAssertFalse(state.whiteBeetle.canMove(as: $0, in: state))
			}
		}
	}

	func testBeetleMoves_AreCorrect() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 12, to: state)
		let availableMoves = state.whiteBeetle.availableMoves(in: state)
		XCTAssertEqual(4, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteBeetle, to: Position(x: -1, y: 1, z: 0)),
			.move(unit: state.whiteBeetle, to: Position(x: -1, y: -1, z: 2)),
			.move(unit: state.whiteBeetle, to: .origin),
			.move(unit: state.whiteBeetle, to: Position(x: 0, y: -1, z: 1))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testBeetle_CanMoveUpToHive() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2))
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: .origin)
		XCTAssertTrue(state.availableMoves.contains(expectedMove))
	}

	func testBeetle_CanMoveDownFromHive() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteAnt, at: Position(x: 0, y: -1, z: 1)),
			Movement.place(unit: state.blackBeetle, at: Position(x: 0, y: 2, z: -2)),
			Movement.move(unit: state.whiteAnt, to: Position(x: 1, y: -1, z: 0)),
			Movement.move(unit: state.blackBeetle, to: Position(x: 0, y: 1, z: -1)),
			Movement.move(unit: state.whiteAnt, to: Position(x: 0, y: -1, z: 1))
		]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMove: Movement = .move(unit: state.blackBeetle, to: Position(x: 0, y: 2, z: -2))
		XCTAssertTrue(state.availableMoves.contains(expectedMove))
	}

	func testBeetle_WithoutFreedomOfMovement_CannotMove() {
		let state = stateProvider.initialGameState
		let setupMoves: [Movement] = [
			Movement.place(unit: state.whiteQueen, at: .origin),
			Movement.place(unit: state.blackQueen, at: Position(x: 0, y: 1, z: -1)),
			Movement.place(unit: state.whiteHopper, at: Position(x: 1, y: -1, z: 0)),
			Movement.place(unit: state.blackLadyBug, at: Position(x: 1, y: 1, z: -2)),
			Movement.place(unit: state.whiteSpider, at: Position(x: 2, y: -1, z: -1)),
			Movement.place(unit: state.blackSpider, at: Position(x: 1, y: 2, z: -3)),
			Movement.place(unit: state.whiteBeetle, at: Position(x: 3, y: -1, z: -2)),
			Movement.move(unit: state.blackSpider, to: Position(x: -1, y: 1, z: 0)),
			Movement.move(unit: state.whiteBeetle, to: Position(x: 2, y: 0, z: -2)),
			Movement.move(unit: state.blackSpider, to: Position(x: 1, y: 2, z: -3))
			]

		stateProvider.apply(moves: setupMoves, to: state)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: Position(x: 2, y: 1, z: -3))
		XCTAssertTrue(state.whiteBeetle.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.whiteBeetle, to: Position(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.whiteBeetle.availableMoves(in: state).contains(unexpectedMove))
	}

	func testWithBeetleOnTopOfStack_AvailableUnitsCanBePlaced() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 29, to: state)
		let expectedPlacements: Set<Movement> = [
			.place(unit: state.blackPillBug, at: Position(x: 2, y: 0, z: -2)),
			.place(unit: state.blackPillBug, at: Position(x: 2, y: -1, z: -1)),
			.place(unit: state.blackAnt, at: Position(x: 2, y: -1, z: -1)),
			.place(unit: state.blackAnt, at: Position(x: 2, y: 0, z: -2))
		]

		let availablePlacements = Set(state.availableMoves.filter { if case .place = $0 { return true } else { return false } })

		XCTAssertTrue(expectedPlacements.isSubset(of: availablePlacements))
	}

	func testWithBeetleOnTopOfStack_PiecesBeneathCannotMove() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 30, to: state)
		XCTAssertEqual(0, state.whiteQueen.availableMoves(in: state).count)
	}

	func testBeetle_CanMoveToTallerStack() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 13, to: state)
		let expectedMove: Movement = .move(unit: state.blackMosquito, to: .origin)
		XCTAssertTrue(state.blackMosquito.availableMoves(in: state).contains(expectedMove))
	}

	func testBeetle_CanMoveDownFromStack() {
		let state = stateProvider.initialGameState
		stateProvider.apply(moves: 14, to: state)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: Position(x: -1, y: 0, z: 1))
		XCTAssertTrue(state.whiteBeetle.availableMoves(in: state).contains(expectedMove))
	}

	static var allTests = [
		("testBeetle_CanMoveAsBeetleOrQueen", testBeetle_CanMoveAsBeetleOrQueen),
		("testBeetleMoves_AreCorrect", testBeetleMoves_AreCorrect),
		("testBeetle_WithoutFreedomOfMovement_CannotMove", testBeetle_WithoutFreedomOfMovement_CannotMove),

		("testBeetle_CanMoveUpToHive", testBeetle_CanMoveUpToHive),
		("testBeetle_CanMoveDownFromHive", testBeetle_CanMoveDownFromHive),

		("testWithBeetleOnTopOfStack_AvailableUnitsCanBePlaced", testWithBeetleOnTopOfStack_AvailableUnitsCanBePlaced),
		("testWithBeetleOnTopOfStack_PiecesBeneathCannotMove", testWithBeetleOnTopOfStack_PiecesBeneathCannotMove),
		("testBeetle_CanMoveToTallerStack", testBeetle_CanMoveToTallerStack),
		("testBeetle_CanMoveDownFromStack", testBeetle_CanMoveDownFromStack)
	]
}
