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

public struct Position: Hashable, Equatable, Codable {
	let x: Int
	let y: Int
	let z: Int

	public init(x: Int, y: Int, z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}

	public func adjacent() -> Set<Position> {
		return [
			Position(x: x, y: y + 1, z: z - 1),
			Position(x: x + 1, y: y, z: z - 1),
			Position(x: x + 1, y: y - 1, z: z),
			Position(x: x, y: y - 1, z: z + 1),
			Position(x: x - 1, y: y, z: z + 1),
			Position(x: x - 1, y: y + 1, z: z)
		]
	}

	/// Returns true if there is freedom of movement between two positions at given heights
	public func freedomOfMovement(
		to other: Position,
		startingHeight: Int = 1,
		endingHeight: Int = 1,
		in state: GameState
	) -> Bool {
		// Can't move to anywhere but the top of a stack
		if let otherStack = state.stacks[other], endingHeight != otherStack.endIndex + 1 {
			return false
		}

		// Find the positions/stacks separating the two positions
		let difference = other.subtracting(self)

		var firstPositionModifier: Position?
		var secondPositionModifier: Position?
		if difference.x == 0 {
			firstPositionModifier = Position(x: difference.y, y: 0, z: difference.z)
			secondPositionModifier = Position(x: difference.z, y: difference.y, z: 0)
		} else if difference.y == 0 {
			firstPositionModifier = Position(x: 0, y: difference.x, z: difference.z)
			secondPositionModifier = Position(x: difference.x, y: difference.z, z: 0)
		} else if difference.z == 0 {
			firstPositionModifier = Position(x: 0, y: difference.y, z: difference.x)
			secondPositionModifier = Position(x: difference.x, y: 0, z: difference.y)
		}

		// Get the relevant stacks, or if the stacks are empty then the movement is valid
		guard let firstModifier = firstPositionModifier,
			let secondModifier = secondPositionModifier,
			let firstStack = state.stacks[self.adding(firstModifier)],
			let secondStack = state.stacks[self.adding(secondModifier)] else { return true }

		if startingHeight > endingHeight {
			return firstStack.endIndex < startingHeight || secondStack.endIndex < startingHeight
		} else {
			return endingHeight > firstStack.endIndex || endingHeight > secondStack.endIndex
		}
	}

	public func subtracting(_ other: Position) -> Position {
		return Position(x: self.x - other.x, y: self.y - other.y, z: self.z - other.z)
	}

	public func adding(_ other: Position) -> Position {
		return Position(x: self.x + other.x, y: self.y + other.y, z: self.z + other.z)
	}
}

extension Position: CustomStringConvertible {
	public var description: String {
		return "(\(x), \(y), \(z))"
	}
}
