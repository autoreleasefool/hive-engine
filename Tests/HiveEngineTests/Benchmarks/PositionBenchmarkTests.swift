//
//  PositionBenchmarkTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-12-02.
//

import XCTest
@testable import HiveEngine

final class PositionBenchmarkTests: HiveEngineTestCase {

	func testIterateAdjacentPositionsBenchmark() {
		measure {
			for _ in (0...200000) {
				let position = Position(
					x: Int.random(in: -20...20),
					y: Int.random(in: -20...20),
					z: Int.random(in: -20...20)
				)

				let _ = position.adjacent()
			}
		}
	}

	func testOffsetPositionBenchmark() {
		measure {
			for _ in (0...200000) {
				let position = Position(
					x: Int.random(in: -20...20),
					y: Int.random(in: -20...20),
					z: Int.random(in: -20...20)
				)

				let _ = position.offset(by: Direction.allCases.randomElement()!)
			}
		}
	}

	func testCommonPositionBenchmark() {
		measure {
			for _ in (0...50000) {
				let position = Position(
					x: Int.random(in: -20...20),
					y: Int.random(in: -20...20),
					z: Int.random(in: -20...20)
				)

				let adjacentPosition = position.adjacent().randomElement()!
				let nonAdjacentPosition = position.adding(x: 0, y: 3, z: -3)

				XCTAssertNotNil(position.commonPositions(to: adjacentPosition))
				XCTAssertNil(position.commonPositions(to: nonAdjacentPosition))
			}
		}
	}

	func testDirectionToBenchmark() {
		measure {
			for _ in (0...100000) {
				let position = Position(
					x: Int.random(in: -20...20),
					y: Int.random(in: -20...20),
					z: Int.random(in: -20...20)
				)

				let direction = Direction.allCases.randomElement()!
				let otherPosition = position.offset(by: direction)
				XCTAssertEqual(direction, position.direction(to: otherPosition))
			}
		}
	}

}
