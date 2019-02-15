//
//  MovementTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
@testable import HiveEngine

final class MovementTests: XCTestCase {

	static var allTests = [
		("testCodingMoveMovement", testCodingMoveMovement),
		("testCodingYoinkMovement", testCodingYoinkMovement),
		("testCodingPlaceMovement", testCodingPlaceMovement)
	]

	func testCodingMoveMovement() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		let unit = Unit(class: .ant, owner: .white, identifier: UUID(uuidString: "AACA052C-280E-4925-8488-518770A2A912")!)
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .move(unit: unit, to: position)
		let data = try encoder.encode(movement)

		let expectation = """
		{
			"move" : {
				"to" : {
					"inPlay" : {
						"x" : 1,
						"y" : -1,
						"z" : 0
					}
				},
				"unit" : {
					"class" : "Ant",
					"owner" : "white",
					"identifier" : "AACA052C-280E-4925-8488-518770A2A912"
				}
			}
		}
		""".replacingOccurrences(of: "\t", with: "  ", options: .regularExpression)
		XCTAssertEqual(expectation, String.init(data: data, encoding: .utf8)!)

		let decoder = JSONDecoder()
		let decodedMovement: Movement = try decoder.decode(Movement.self, from: data)
		XCTAssertEqual(movement, decodedMovement)
	}

	func testCodingYoinkMovement() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		let pillBug = Unit(class: .pillBug, owner: .black, identifier: UUID(uuidString: "97957797-CC2B-4673-A079-2C75C378361F")!)
		let unit = Unit(class: .ant, owner: .white, identifier: UUID(uuidString: "AACA052C-280E-4925-8488-518770A2A912")!)
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .yoink(pillBug: pillBug, unit: unit, to: position)
		let data = try encoder.encode(movement)

		let expectation = """
		{
			"yoink" : {
				"pillBug" : {
					"class" : "Pill Bug",
					"owner" : "black",
					"identifier" : "97957797-CC2B-4673-A079-2C75C378361F"
				},
				"to" : {
					"inPlay" : {
						"x" : 1,
						"y" : -1,
						"z" : 0
					}
				},
				"unit" : {
					"class" : "Ant",
					"owner" : "white",
					"identifier" : "AACA052C-280E-4925-8488-518770A2A912"
				}
			}
		}
		""".replacingOccurrences(of: "\t", with: "  ", options: .regularExpression)
		XCTAssertEqual(expectation, String.init(data: data, encoding: .utf8)!)

		let decoder = JSONDecoder()
		let decodedMovement: Movement = try decoder.decode(Movement.self, from: data)
		XCTAssertEqual(movement, decodedMovement)
	}

	func testCodingPlaceMovement() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		let unit = Unit(class: .ant, owner: .white, identifier: UUID(uuidString: "AACA052C-280E-4925-8488-518770A2A912")!)
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let movement: Movement = .place(unit: unit, at: position)
		let data = try encoder.encode(movement)

		let expectation = """
		{
			"place" : {
				"to" : {
					"inPlay" : {
						"x" : 1,
						"y" : -1,
						"z" : 0
					}
				},
				"unit" : {
					"class" : "Ant",
					"owner" : "white",
					"identifier" : "AACA052C-280E-4925-8488-518770A2A912"
				}
			}
		}
		""".replacingOccurrences(of: "\t", with: "  ", options: .regularExpression)
		XCTAssertEqual(expectation, String.init(data: data, encoding: .utf8)!)

		let decoder = JSONDecoder()
		let decodedMovement: Movement = try decoder.decode(Movement.self, from: data)
		XCTAssertEqual(movement, decodedMovement)
	}
}
