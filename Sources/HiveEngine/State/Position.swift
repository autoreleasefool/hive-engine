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
	public let x: Int
	public let y: Int
	public let z: Int

	public init(x: Int, y: Int, z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}

	/// Origin position
	public static let origin = Position(x: 0, y: 0, z: 0)

	/// All adjacent positions
	public func adjacent() -> [Position] {
		return [
			Position(x: x, y: y &+ 1, z: z &- 1),
			Position(x: x &+ 1, y: y, z: z &- 1),
			Position(x: x &+ 1, y: y &- 1, z: z),
			Position(x: x, y: y &- 1, z: z &+ 1),
			Position(x: x &- 1, y: y, z: z &+ 1),
			Position(x: x &- 1, y: y &+ 1, z: z)
		]
	}

	/// Find the common position between this and an adjacent position. If the positions are not adjacent, nil is returned
	///
	/// - Parameters:
	///   - other: an adjacent `Position`
	public func commonPositions(to other: Position) -> (Position, Position)? {
		let difference = other.subtracting(self)

		guard -1 <= difference.x && difference.x <= 1 &&
			-1 <= difference.y && difference.y <= 1 &&
			-1 <= difference.z && difference.z <= 1 &&
			difference.x != difference.y && difference.y != difference.z && difference.x != difference.z else {
			return nil
		}

		if difference.x == 0 {
			return (self.adding(x: difference.y, y: 0, z: difference.z), self.adding(x: difference.z, y: difference.y, z: 0))
		} else if difference.y == 0 {
			return (self.adding(x: 0, y: difference.x, z: difference.z), self.adding(x: difference.x, y: difference.z, z: 0))
		} else if difference.z == 0 {
			return (self.adding(x: 0, y: difference.y, z: difference.x), self.adding(x: difference.x, y: 0, z: difference.y))
		}

		return nil
	}

	/// Returns true if there is freedom of movement between two positions at given heights
	public func freedomOfMovement(
		to other: Position,
		startingHeight: Int = 1,
		endingHeight: Int = 1,
		in state: GameState
	) -> Bool {
		// Can't move to anywhere but the top of a stack
		if let otherStack = state.stacks[other], endingHeight != otherStack.endIndex &+ 1 {
			return false
		}

		guard let (firstPosition, secondPosition) = commonPositions(to: other) else { return false }

		// Get the relevant stacks, or if the stacks are empty then the movement is valid
		guard let firstStack = state.stacks[firstPosition],
			let secondStack = state.stacks[secondPosition] else { return true }

		/// See https://boardgamegeek.com/wiki/page/Hive_FAQ#toc9
		return (startingHeight &- 1 < firstStack.endIndex &&
			startingHeight &- 1 < secondStack.endIndex &&
			endingHeight &- 1 < firstStack.endIndex &&
			endingHeight &- 1 < secondStack.endIndex) == false
	}

	/// Subtract the given Position from this Position and return a new Position
	public func subtracting(_ other: Position) -> Position {
		return Position(x: self.x &- other.x, y: self.y &- other.y, z: self.z &- other.z)
	}

	/// Add the given Position to this Position and return a new Position
	public func adding(_ other: Position) -> Position {
		return Position(x: self.x &+ other.x, y: self.y &+ other.y, z: self.z &+ other.z)
	}

	/// Add the given values to this Position and return a new Position
	public func adding(x: Int, y: Int, z: Int) -> Position {
		return Position(x: self.x &+ x, y: self.y &+ y, z: self.z &+ z)
	}

	/// Get the Direction which must be travelled from this Position to reach the given Position.
	/// For non-adjacent positions, this method returns nil.
	public func direction(to other: Position) -> Direction? {
		let difference = other.subtracting(self)
		switch (difference.x, difference.y, difference.z) {
		case (1, 0, -1): return .northEast
		case (1, -1, 0): return .southEast
		case (0, -1, 1): return .south
		case (-1, 0, 1): return .southWest
		case (-1, 1, 0): return .northWest
		case (0, 1, -1): return .north
		case (0, 0, 0): return .onTop
		default: return nil
		}
	}
}

// MARK: - CustomStringConvertible

extension Position: CustomStringConvertible {
	public var description: String {
		return "(\(x), \(y), \(z))"
	}
}

// MARK: - Comparable

extension Position: Comparable {
	public static func < (lhs: Position, rhs: Position) -> Bool {
		if lhs.x == rhs.x {
			if lhs.y == rhs.y {
				return lhs.z < rhs.z
			}
			return lhs.y < rhs.y
		}
		return lhs.x < rhs.x
	}
}

// MARK: - Direction

public enum Direction: String, CustomStringConvertible {
	case onTop = "On Top"
	case northWest = "North West"
	case northEast = "North East"
	case north = "North"
	case southWest = "South West"
	case southEast = "South East"
	case south = "South"

	/// The direction presented in standard notation.
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	public var notation: String {
		switch self {
		case .onTop: return ""
		case .northEast, .southWest: return "/"
		case .southEast, .northWest: return "-"
		case .south, .north: return "\\"
		}
	}

	public var description: String {
		return self.rawValue
	}
}
