//
//  Movement.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

public enum Movement: Hashable, Equatable {
	case move(unit: Unit, to: Position)
	case yoink(pillBug: Unit, unit: Unit, to: Position)
	case place(unit: Unit, at: Position)
	case pass

	/// Primary unit that was moved in the Movement
	public var movedUnit: Unit? {
		switch self {
		case .move(let unit, _), .yoink(_, let unit, _), .place(let unit, _): return unit
		case .pass: return nil
		}
	}

	/// Position that `movedUnit` was moved to in the Movement
	public var targetPosition: Position? {
		switch self {
		case .move(_, let position), .yoink(_, _, let position), .place(_, let position): return position
		case .pass: return nil
		}
	}

	/// Standard notation for the movement.
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	public func notation(in state: GameState) -> String {
		return self.relative(in: state)?.notation ?? "pass"
	}

	/// Translate the Movement into a RelativeMovement, providing an adjacent unit and the position
	/// relative to that unit that it will move to.
	public func relative(in state: GameState) -> RelativeMovement? {
		switch self {
		case .move(let unit, let position), .yoink(_, let unit, let position), .place(let unit, let position):
			let adjacentUnit: Unit?
			let direction: Direction?

			if let stack = state.stacks[position], stack.count > 0 {
				// If the movement is on top of another unit, then the unit moved onto is the adjacent unit.
				adjacentUnit = stack.last
				direction = .onTop
			} else if let firstAdjacent = state.units(adjacentTo: position).filter({ $0 != unit }).first,
				let firstAdjacentPosition = state.unitsInPlay[firstAdjacent.owner]?[firstAdjacent] {
				// If there is an adjacent unit, get the unit and its position
				adjacentUnit = firstAdjacent
				direction = firstAdjacentPosition.direction(to: position)
			} else {
				// If there are no adjacent units, this must be the first movement
				adjacentUnit = nil
				direction = nil
			}

			if let adjacent = adjacentUnit, let direction = direction {
				return RelativeMovement(unit: unit, adjacentTo: (adjacent, direction))
			} else {
				return RelativeMovement(unit: unit, adjacentTo: nil)
			}
		case .pass:
			return nil
		}
	}
}

// MARK: - CustomStringConvertible

extension Movement: CustomStringConvertible {
	public var description: String {
		switch self {
		case .move(let unit, let to): return "Move \(unit) to \(to)"
		case .place(let unit, let at): return "Place \(unit) at \(at)"
		case .yoink(_, let unit, let to): return "Yoink \(unit) to \(to)"
		case .pass: return "Pass"
		}
	}
}

// MARK: - Codable

extension Movement: Codable {
	public init(from decoder: Decoder) throws {
		self = try Movement.Coding.init(from: decoder).movement()
	}

	public func encode(to encoder: Encoder) throws {
		try Movement.Coding.init(movement: self).encode(to: encoder)
	}
}

// swiftlint:disable nesting
// Allow deeper nesting for codable workaround

public extension Movement {
	enum CodingError: Error {
		case standard(String)
	}

	fileprivate struct Coding: Codable {
		private struct Move: Codable {
			let unit: Unit
			let to: Position
		}

		private struct Yoink: Codable {
			let pillBug: Unit
			let unit: Unit
			let to: Position
		}

		private var move: Move?
		private var yoink: Yoink?
		private var place: Move?
		private var pass: Bool?

		fileprivate init(movement: Movement) {
			switch movement {
			case .move(let unit, let position):
				self.move = Move(unit: unit, to: position)
			case .yoink(let pillBug, let unit, let position):
				self.yoink = Yoink(pillBug: pillBug, unit: unit, to: position)
			case .place(let unit, let position):
				self.place = Move(unit: unit, to: position)
			case .pass:
				self.pass = true
			}
		}

		fileprivate func movement() throws -> Movement {
			switch (move, yoink, place, pass) {
			case (.some(let move), nil, nil, nil):
				return .move(unit: move.unit, to: move.to)
			case (nil, .some(let yoink), nil, nil):
				return .yoink(pillBug: yoink.pillBug, unit: yoink.unit, to: yoink.to)
			case (nil, nil, .some(let place), nil):
				return .place(unit: place.unit, at: place.to)
			case (nil, nil, nil, .some(true)):
				return .pass
			default:
				throw Movement.CodingError.standard("Could not convert \(self) into a Movement")
			}
		}
	}
}

//swiftlint:enable nesting
