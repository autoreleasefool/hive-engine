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
		let state = stateProvider.gameState(after: 12)
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
		let state = stateProvider.gameState(after: 12)
		let availableMoves = state.whiteBeetle.availableMoves(in: state)
		XCTAssertEqual(4, availableMoves.count)

		let expectedMoves: Set<Movement> = [
			.move(unit: state.whiteBeetle, to: .inPlay(x: -1, y: 1, z: 0)),
			.move(unit: state.whiteBeetle, to: .inPlay(x: -1, y: -1, z: 2)),
			.move(unit: state.whiteBeetle, to: .inPlay(x: 0, y: 0, z: 0)),
			.move(unit: state.whiteBeetle, to: .inPlay(x: 0, y: -1, z: 1))
		]
		XCTAssertEqual(expectedMoves, availableMoves)
	}

	func testBeetle_CanMoveUpToHive() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackBeetle, at: Position.inPlay(x: 0, y: 1, z: -1))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: .inPlay(x: 0, y: 1, z: -1))
		XCTAssertTrue(state.availableMoves.contains(expectedMove))
	}

	func testBeetle_CanMoveDownFromHive() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackBeetle, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteAnt, at: Position.inPlay(x: 0, y: -1, z: 1)),
			Movement.move(unit: stateProvider.blackBeetle, to: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.move(unit: stateProvider.whiteAnt, to: Position.inPlay(x: 1, y: -1, z: 0))
		]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.blackBeetle, to: .inPlay(x: 0, y: 1, z: -1))
		XCTAssertTrue(state.availableMoves.contains(expectedMove))
	}

	func testBeetle_WithoutFreedomOfMovement_CannotMove() {
		let setupMoves: [Movement] = [
			Movement.place(unit: stateProvider.whiteQueen, at: Position.inPlay(x: 0, y: 0, z: 0)),
			Movement.place(unit: stateProvider.blackQueen, at: Position.inPlay(x: 0, y: 1, z: -1)),
			Movement.place(unit: stateProvider.whiteHopper, at: Position.inPlay(x: 1, y: -1, z: 0)),
			Movement.place(unit: stateProvider.blackLadyBug, at: Position.inPlay(x: 1, y: 1, z: -2)),
			Movement.place(unit: stateProvider.whiteSpider, at: Position.inPlay(x: 2, y: -1, z: -1)),
			Movement.place(unit: stateProvider.blackSpider, at: Position.inPlay(x: 1, y: 2, z: -3)),
			Movement.place(unit: stateProvider.whiteBeetle, at: Position.inPlay(x: 3, y: -1, z: -2)),
			Movement.move(unit: stateProvider.blackSpider, to: Position.inPlay(x: -1, y: 1, z: 0)),
			Movement.move(unit: stateProvider.whiteBeetle, to: Position.inPlay(x: 2, y: 0, z: -2)),
			Movement.move(unit: stateProvider.blackSpider, to: Position.inPlay(x: 1, y: 2, z: -3))
			]

		let state = stateProvider.gameState(from: setupMoves)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: .inPlay(x: 2, y: 1, z: -3))
		XCTAssertTrue(state.whiteBeetle.availableMoves(in: state).contains(expectedMove))
		let unexpectedMove: Movement = .move(unit: state.whiteBeetle, to: .inPlay(x: 1, y: 0, z: -1))
		XCTAssertFalse(state.whiteBeetle.availableMoves(in: state).contains(unexpectedMove))
	}

	func testWithBeetleOnTopOfStack_AvailableUnitsCanBePlaced() {
		let state = stateProvider.gameState(after: 29)
		let expectedPlacements: Set<Movement> = [
			.place(unit: state.blackPillBug, at: .inPlay(x: 2, y: 0, z: -2)),
			.place(unit: state.blackPillBug, at: .inPlay(x: 2, y: -1, z: -1)),
			.place(unit: state.blackAnt, at: .inPlay(x: 2, y: -1, z: -1)),
			.place(unit: state.blackAnt, at: .inPlay(x: 2, y: 0, z: -2))
		]

		let availablePlacements = Set(state.availableMoves.filter { if case .place = $0 { return true } else { return false } })

		XCTAssertTrue(expectedPlacements.isSubset(of: availablePlacements))
	}

	func testWithBeetleOnTopOfStack_PiecesBeneathCannotMove() {
		let state = stateProvider.gameState(after: 30)
		XCTAssertEqual(0, state.whiteQueen.availableMoves(in: state).count)
	}

	func testBeetle_CanMoveToTallerStack() {
		let state = stateProvider.gameState(after: 13)
		let expectedMove: Movement = .move(unit: state.blackMosquito, to: .inPlay(x: 0, y: 0, z: 0))
		XCTAssertTrue(state.blackMosquito.availableMoves(in: state).contains(expectedMove))
	}

	func testBeetle_CanMoveDownFromStack() {
		let state = stateProvider.gameState(after: 14)
		let expectedMove: Movement = .move(unit: state.whiteBeetle, to: .inPlay(x: -1, y: 0, z: 1))
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
