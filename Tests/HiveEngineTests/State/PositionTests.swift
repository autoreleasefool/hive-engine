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

final class PositionTests: HiveEngineTestCase {

	static var allTests = [
		("testCodingInPlayPosition", testCodingInPlayPosition),
		("testCodingInHandPosition", testCodingInHandPosition)
	]

	func testCodingInPlayPosition() throws {
		let position: Position = .inPlay(x: 1, y: -1, z: 0)
		XCTAssertEncodable(position)
		XCTAssertDecodable(position)
	}

	func testCodingInHandPosition() throws {
		let position: Position = .inHand
		XCTAssertEncodable(position)
		XCTAssertDecodable(position)
	}
}
