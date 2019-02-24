//
//  Position.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

///       Hexagonal grid system
///                _____
///          +y   /     \   -z
///              /       \
///        ,----(  0,1,-1 )----.
///       /      \       /      \
///      /        \_____/        \
///      \ -1,1,0 /     \ 1,0,-1 /
///       \      /       \      /
///  -x    )----(  0,0,0  )----(    +x
///       /      \       /      \
///      /        \_____/        \
///      \ -1,0,1 /     \ 1,-1,0 /
///       \      /       \      /
///        `----(  0,-1,1 )----'
///              \       /
///          +z   \_____/   -y
///

public enum Position: Hashable, Equatable {
	case inHand
	case inPlay(x: Int, y: Int, z: Int)

	public func adjacent() -> Set<Position> {
		switch self {
		case .inHand: return []
		case .inPlay(let x, let y, let z):
			return [
				.inPlay(x: x, y: y + 1, z: z - 1),
				.inPlay(x: x + 1, y: y, z: z - 1),
				.inPlay(x: x + 1, y: y - 1, z: z),
				.inPlay(x: x, y: y - 1, z: z + 1),
				.inPlay(x: x - 1, y: y, z: z + 1),
				.inPlay(x: x - 1, y: y + 1, z: z)
			]
		}
	}

	/// Returns true if there is freedom of movement between two positions at given heights
	public func freedomOfMovement(
		to other: Position,
		startingHeight: Int = 1,
		endingHeight: Int = 1,
		in state: GameState
	) -> Bool {
		// Can't move to anywhere but the top of a stack
		if let otherStack = state.stacks[other], endingHeight != otherStack.endIndex {
			return false
		}

		// Find the positions/stacks separating the two positions
		let difference = other.subtracting(self)

		var firstPositionModifier: Position?
		var secondPositionModifier: Position?
		if case let .inPlay(x, y, z) = difference {
			if x == 0 {
				firstPositionModifier = .inPlay(x: y, y: 0, z: z)
				secondPositionModifier = .inPlay(x: z, y: y, z: 0)
			} else if y == 0 {
				firstPositionModifier = .inPlay(x: 0, y: x, z: z)
				secondPositionModifier = .inPlay(x: z, y: z, z: 0)
			} else if z == 0 {
				firstPositionModifier = .inPlay(x: 0, y: y, z: x)
				secondPositionModifier = .inPlay(x: x, y: 0, z: y)
			}
		}

		// Get the relevant stacks, or if the stacks are empty then the movement is valid
		guard let firstModifier = firstPositionModifier,
			let secondModifier = secondPositionModifier,
			let firstStack = state.stacks[self.adding(firstModifier)],
			let secondStack = state.stacks[self.adding(secondModifier)] else { return true }

		if startingHeight > endingHeight {
			return firstStack.endIndex <= startingHeight || secondStack.endIndex <= startingHeight
		} else {
			return endingHeight <= firstStack.endIndex || endingHeight <= secondStack.endIndex
		}
	}

	public func subtracting(_ other: Position) -> Position {
		switch (self, other) {
		case (.inHand, _):
			return .inHand
		case (_, .inHand):
			return self
		case(.inPlay(let x1, let y1, let z1), .inPlay(let x2, let y2, let z2)):
			return .inPlay(x: x1 - x2, y: y1 - y2, z: z1 - z2)
		}
	}

	public func adding(_ other: Position) -> Position {
		switch (self, other) {
		case (.inHand, _):
			return .inHand
		case (_, .inHand):
			return self
		case(.inPlay(let x1, let y1, let z1), .inPlay(let x2, let y2, let z2)):
			return .inPlay(x: x1 + x2, y: y1 + y2, z: z1 + z2)
		}
	}
}

// MARK: - Codable

extension Position: Codable {
	public init(from decoder: Decoder) throws {
		self = try Position.Coding.init(from: decoder).position()
	}

	public func encode(to encoder: Encoder) throws {
		try Position.Coding.init(position: self).encode(to: encoder)
	}
}

// swiftlint:disable nesting
// Allow deeper nesting for codable workaround

extension Position {
	enum CodingError: Error {
		case standard(String)
	}

	fileprivate struct Coding: Codable {
		private struct InPlay: Codable {
			let x: Int
			let y: Int
			let z: Int
		}

		private var inPlay: InPlay?
		private var inHand: Bool?

		fileprivate init(position: Position) {
			switch position {
			case .inHand:
				self.inHand = true
			case .inPlay(let x, let y, let z):
				self.inPlay = InPlay(x: x, y: y, z: z)
			}
		}

		fileprivate func position() throws -> Position {
			switch (inHand, inPlay) {
			case (nil, .some(let position)):
				return .inPlay(x: position.x, y: position.y, z: position.z)
			case (_, nil):
				return .inHand
			default:
				throw Position.CodingError.standard("Could not convert \(self) into a Position")
			}
		}
	}
}

//swiftlint:enable nesting
