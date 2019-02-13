//
//  PositionTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import XCTest
@testable import HiveEngine

final class PositionTests: XCTestCase {

	static var allTests = [
		("testCodingInPlayPosition", testCodingInPlayPosition),
		("testCodingInHandPosition", testCodingInHandPosition)
	]

	func testCodingInPlayPosition() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		let data = try encoder.encode(position)

		let expectation = """
		{
		  "inPlay" : {
			"x" : 1,
			"y" : -1,
			"z" : 0
		  }
		}
		"""
		XCTAssertEqual(expectation, String.init(data: data, encoding: .utf8)!)

		let decoder = JSONDecoder()
		let decodedPosition: Position = try decoder.decode(Position.self, from: data)
		XCTAssertEqual(position, decodedPosition)
	}

	func testCodingInHandPosition() throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		let position: Position = .inHand
		let data = try encoder.encode(position)

		let expectation = """
		{
		  "inHand" : true
		}
		"""
		XCTAssertEqual(expectation, String.init(data: data, encoding: .utf8)!)

		let decoder = JSONDecoder()
		let decodedPosition: Position = try decoder.decode(Position.self, from: data)
		XCTAssertEqual(position, decodedPosition)
	}
}
