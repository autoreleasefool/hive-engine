//
//  LinuxMain.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2019-02-11.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import XCTest
import HiveEngineTests

var tests = [XCTestCaseEntry]()
tests += CollectionExtensionTests.allTests()
tests += PositionTests.allTests()
tests += MovementTests.allTests()
XCTMain(tests)
