//
//  RelativeMovement.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-05-24.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Regex

public struct RelativeMovement {
	/// The unit that was moved in the Movement
	public let movedUnit: Unit
	/// A `Unit` that `movedUnit` is adjacent to, and the direction `movedUnit` is in, relative to that unit.
	/// `nil` in the case there is no adjacent unit.
	public let adjacent: (unit: Unit, direction: Direction)?

	public init(unit: Unit, adjacentTo adjacent: (unit: Unit, direction: Direction)?) {
		self.movedUnit = unit
		self.adjacent = adjacent
	}

	private static let unitRegex = Regex("[wb]([AG][1-3]|[BS][1-2]|[LMPQ]1?)")
	private static let directionRegex = Regex(#"[-\\/]"#)
	private static let regex: Regex = {
		// swiftlint:disable:next force_try
		try! Regex(
			string: "(\(unitRegex))" +
				"( (\(directionRegex)?\(unitRegex)\(directionRegex)?))?",
			options: []
		)
	}()

	public init?(notation: String) {
		let adjacentCaptureIndex = 3

		guard let match = Self.regex.firstMatch(in: notation),
			let movedUnit = Unit(notation: match.captures[0]!) else { return nil }
		self.movedUnit = movedUnit

		guard match.captures.filter({ $0 != nil }).count == 5 else {
			self.adjacent = nil
			return
		}

		guard let adjacentMatch = Self.unitRegex.firstMatch(in: match.captures[adjacentCaptureIndex]!),
			let adjacentUnit = Unit(notation: adjacentMatch.matchedString) else { return nil }

		if let directionMatch = Self.directionRegex.firstMatch(in: match.captures[adjacentCaptureIndex]!),
			let direction = Direction(
				notation: directionMatch.matchedString,
				onLeft: match.captures[adjacentCaptureIndex]!.firstIndex(of: directionMatch.matchedString.first!) ==
					match.captures[adjacentCaptureIndex]!.startIndex
			) {
			self.adjacent = (unit: adjacentUnit, direction: direction)
		} else {
			self.adjacent = (unit: adjacentUnit, direction: .onTop)
		}
	}

	/// Standard notation for the movement.
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	public var notation: String {
		var notation = movedUnit.notation
		if let adjacent = adjacent {
			switch adjacent.direction {
			case .onTop:
				notation += " \(adjacent.unit.notation)"
			case .north, .northWest, .southWest:
				notation += " \(adjacent.direction.notation)\(adjacent.unit.notation)"
			case .northEast, .southEast, .south:
				notation += " \(adjacent.unit.notation)\(adjacent.direction.notation)"
			}
		}
		return notation
	}

	/// Translate the RelativeMovement in to a Movement, in the given GameState.
	public func movement(in state: GameState) -> Movement {
		if let adjacent = adjacent,
			let adjacentPosition = state.position(of: adjacent.unit)?.offset(by: adjacent.direction) {
			if state.unitsInHand[movedUnit.owner]?.contains(movedUnit) == true {
				return .place(unit: movedUnit, at: adjacentPosition)
			} else {
				return .move(unit: movedUnit, to: adjacentPosition)
			}
		} else {
			return .place(unit: movedUnit, at: .origin)
		}
	}
}

// MARK: - Equatable

extension RelativeMovement: Equatable {
	public static func == (lhs: RelativeMovement, rhs: RelativeMovement) -> Bool {
		guard lhs.movedUnit == rhs.movedUnit else { return false }
		switch (lhs.adjacent, rhs.adjacent) {
		case (.some((let u1, let p1)), .some((let u2, let p2))): return u1 == u2 && p1 == p2
		case (.none, .none): return true
		case (.none, _), (_, .none): return false
		}
	}
}

// MARK: - Hashable

extension RelativeMovement: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(movedUnit)
		if case let .some((unit, position)) = adjacent {
			hasher.combine(unit)
			hasher.combine(position)
		}
	}
}

// MARK: - CustomStringConvertible

extension RelativeMovement: CustomStringConvertible {
	public var description: String {
		if let adjacent = adjacent {
			return "Move \(movedUnit) \(adjacent.direction) of \(adjacent.unit)"
		} else {
			return "Place \(movedUnit) at origin"
		}
	}
}
