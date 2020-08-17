//
//  XCTestManifests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest

#if !os(macOS) && !os(iOS)
public func allTests() -> [XCTestCaseEntry] {
	[
		testCase(CollectionExtensionTests.allTests),
		testCase(GameStateTests.allTests),
		testCase(GameStatePerformanceTests.allTests),
		testCase(MovementTests.allTests),
		testCase(PlayerTests.allTests),
		testCase(PositionTests.allTests),
		testCase(RelativeMovementTests.allTests),
		testCase(UnitTests.allTests),
		testCase(UnitAntTests.allTests),
		testCase(UnitBeetleTests.allTests),
		testCase(UnitHopperTests.allTests),
		testCase(UnitLadyBugTests.allTests),
		testCase(UnitMosquitoTests.allTests),
		testCase(UnitPillBugTests.allTests),
		testCase(UnitQueenTests.allTests),
		testCase(UnitSpiderTests.allTests),
		testCase(PerftTests.allTests),
		testCase(UHPCommandParserTests.allTests),
		testCase(PlayCommandTests.allTests),
		testCase(NewGameCommandTests.allTests),
		testCase(InfoCommandTests.allTests),
		testCase(BestMoveCommandTests.allTests),
		testCase(OptionsCommandTests.allTests),
		testCase(EngineTests.allTests),
		testCase(GameStateUHPTests.allTests),
	]
}
#endif
