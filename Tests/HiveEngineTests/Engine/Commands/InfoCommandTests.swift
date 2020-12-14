//
//  InfoCommandTests.swift
//  HiveEngineTests
//
//  Created by Joseph Roque on 2020-08-15.
//

import Regex
import XCTest
@testable import HiveEngine

final class InfoCommandTests: HiveEngineTestCase {

	func testInfoCommand_ReturnsEngineName() {
		let engine = Engine()
		guard case let .output(message) = engine.send(input: "info") else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(message.contains("Hive Engine"))
	}

	func testInfoCommand_ReturnsCurrentEngineVersion() {
		let engine = Engine()
		guard case let .output(message) = engine.send(input: "info") else {
			XCTFail("Command result was not valid")
			return
		}

		let tagExpectation = expectation(description: "Expected GitHub API call to return tag")

		URLSession.shared.dataTask(
			with: URL(string: "https://api.github.com/repos/josephroquedev/hive-engine/tags?per_page=1")!
		) { data, _, _ in
			let decoder = JSONDecoder()
			guard let data = data,
				let result = try? decoder.decode([GitHubApiTagResponse].self, from: data) else {
					XCTFail("Could not parse response")
					return
			}

			XCTAssertTrue(message.contains("v\(result.first?.name ?? "invalid")"))
			tagExpectation.fulfill()
		}.resume()

		wait(for: [tagExpectation], timeout: 10)
	}

	func testInfoCommand_ReturnsAllExpansions() {
		let engine = Engine()
		guard case let .output(message) = engine.send(input: "info") else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(message.contains("Mosquito"))
		XCTAssertTrue(message.contains("Ladybug"))
		XCTAssertTrue(message.contains("Pillbug"))
	}

	func testInfoCommand_MatchesExpectedFormat() {
		// swiftlint:disable:next force_try
		let format = try! Regex(string: #"^id .+ v\d\.\d\.\d(\n(\w+;)+\w+)?$"#, options: [])

		let engine = Engine()
		guard case let .output(message) = engine.send(input: "info") else {
			XCTFail("Command result was not valid")
			return
		}

		XCTAssertTrue(format.matches(message))
	}
}

private struct GitHubApiTagResponse: Codable {
	let name: String
}
