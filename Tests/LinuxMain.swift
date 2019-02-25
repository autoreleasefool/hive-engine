//
//  LinuxMain.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
import HiveEngineTests

let tests: [XCTestCaseEntry] =
	CollectionExtensionTests.allTests() +
	GameStateTests.allTests() +
	MovementTests.allTests() +
	PlayerTests.allTests() +
	PositionTests.allTests() +
	UnitTests.allTests() +
	UnitAntTests.allTests() +
	UnitBeetleTests.allTests() +
	UnitHopperTests.allTests() +
	UnitLadyBugTests.allTests() +
	UnitMosquitoTests.allTests() +
	UnitPillBugTests.allTests() +
	UnitQueenTests.allTests() +
	UnitSpiderTests.allTests() +
]

XCTMain(tests)
