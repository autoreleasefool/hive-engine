//
//  Collection+ExtensionTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
@testable import HiveEngine

final class CollectionExtensionTests: HiveEngineTestCase {

	func testCollectionIsNotEmpty() {
		var collection: [String] = []
		XCTAssertFalse(collection.isNotEmpty)
		collection.append("Hello, world!")
		XCTAssertTrue(collection.isNotEmpty)
	}

	static var allTests = [
		("testCollectionIsNotEmpty", testCollectionIsNotEmpty)
	]
}
