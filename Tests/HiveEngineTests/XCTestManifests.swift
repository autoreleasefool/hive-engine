//
//  XCTestManifests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(CollectionExtensionTests.allTests),
		testCase(PositionTests.allTests),
		testCase(MovementTests.allTests)
	]
}
#endif
