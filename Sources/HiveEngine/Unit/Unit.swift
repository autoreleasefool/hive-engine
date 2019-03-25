//
//  Unit.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

public class Unit: Codable {

	public enum Class: Int, CaseIterable, Codable {
		case ant = 0
		case beetle = 1
		case hopper = 2
		case ladyBug = 3
		case mosquito = 4
		case pillBug = 5
		case queen = 6
		case spider = 7

		/// A single player's full set of units
		static var fullSet: [Class] {
			return [
				.ant, .ant, .ant,
				.beetle, .beetle,
				.hopper, .hopper, .hopper,
				.ladyBug,
				.mosquito,
				.pillBug,
				.queen,
				.spider, .spider
			]
		}
	}

	// MARK: Properties

	/// Unique ID for the unit which persists across game states
	public let index: Int
	/// Class of the unit to determine its movements
	public let `class`: Class
	/// Owner of the unit
	public let owner: Player

	init(`class`: Class, owner: Player, index: Int) {
		self.class = `class`
		self.owner = owner
		self.index = index
	}

	// MARK: Movement

	/// List the moves available for the unit.
	public func availableMoves(in state: GameState) -> Set<Movement> {
		return moves(as: self.class, in: state)
	}

	/// Returns a movement to the given position, unless the position is `.inHand`
	func movement(to position: Position) -> Movement {
		return .move(unit: self, to: position)
	}

	/// Get the available moves when treating this unit as a certain class
	func moves(as `class`: Class, in state: GameState) -> Set<Movement> {
		switch `class` {
		case .ant: return movesAsAnt(in: state)
		case .beetle: return movesAsBeetle(in: state)
		case .hopper: return movesAsHopper(in: state)
		case .ladyBug: return movesAsLadyBug(in: state)
		case .mosquito: return movesAsMosquito(in: state)
		case .pillBug: return movesAsPillBug(in: state)
		case .queen: return movesAsQueen(in: state)
		case .spider: return movesAsSpider(in: state)
		}
	}

	/// Returns false if this piece cannot move due to fundamental rules of the game.
	public func canMove(in state: GameState) -> Bool {
		let lastMovedUnit: Unit?
		if let lastMove = state.previousMoves.last {
			switch lastMove.movement {
			case .move, .yoink: lastMovedUnit = lastMove.movement.movedUnit
			case .place: lastMovedUnit = nil
			}
		} else {
			lastMovedUnit = nil
		}

		return state.oneHive(excluding: self) && self.isTopOfStack(in: state) && self != lastMovedUnit
	}

	/// Returns true if this unit can move as the given class.
	public func canMove(as givenClass: Class, in state: GameState) -> Bool {
		if self.class == givenClass {
			return true
		} else if self.class == .mosquito {
			// Mosquitos can only move as beetles when on top of the hive
			if stackPosition(in: state) ?? 1 > 1 {
				return givenClass == .beetle
			}

			// Mosquitos can otherwise move as any piece they're adjacent to
			return state.units(adjacentTo: self)
				.filter {
					return $0.class == givenClass ||
						(($0.class == .pillBug || $0.class == .beetle) && givenClass == .queen)
				}.count > 0
		} else if (self.class == .pillBug || self.class == .beetle) && givenClass == .queen {
			// Beetles and pill bugs have movements similar to queens
			return true
		}

		return false
	}

	// MARK: Special ability

	/// Returns true if this unit can use the Pill Bug's special ability.
	public func canUseSpecialAbility(in state: GameState) -> Bool {
		switch self.class {
		case .pillBug:
			return true
		case .mosquito:
			return canMove(as: .pillBug, in: state)
		case .ant, .beetle, .hopper, .ladyBug, .queen, .spider:
			return false
		}
	}

	// MARK: Position

	/// Determine the position of a unit in a positional stack.
	public func stackPosition(in state: GameState) -> Int? {
		guard let position = state.unitsInPlay[owner]?[self],
			let stack = state.stacks[position] else {
			return nil
		}

		guard let height = stack.firstIndex(of: self) else { return nil }
		return height + 1
	}

	/// Determine if this unit is at the top of its stack.
	public func isTopOfStack(in state: GameState) -> Bool {
		guard let position = state.unitsInPlay[owner]?[self],
			let stack = state.stacks[position] else {
			return false
		}

		return stack.last == self
	}

	/// Returns true if this unit is surrounded on all 6 sides.
	public func isSurrounded(in state: GameState) -> Bool {
		return state.units(adjacentTo: self).count == 6
	}
}

// MARK: - CustomStringConvertible

extension Unit: CustomStringConvertible {
	public var description: String {
		return "\(self.owner.description) \(self.class.description)"
	}
}

extension Unit.Class: CustomStringConvertible {
	public var description: String {
		switch self {
		case .ant: return "Ant"
		case .beetle: return "Beetle"
		case .hopper: return "Hopper"
		case .ladyBug: return "Lady Bug"
		case .mosquito: return "Mosquito"
		case .pillBug: return "Pill Bug"
		case .queen: return "Queen"
		case .spider: return "Spider"
		}
	}
}

// MARK: - Hashable

extension Unit: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(owner)
		hasher.combine(`class`)
		hasher.combine(index)
	}
}

// MARK: - Equatable

extension Unit: Equatable {
	public static func == (lhs: Unit, rhs: Unit) -> Bool {
		return lhs.owner == rhs.owner &&
			lhs.class == rhs.class &&
			lhs.index == rhs.index
	}
}

// MARK: - Comparable

extension Unit: Comparable {
	public static func < (lhs: Unit, rhs: Unit) -> Bool {
		if lhs.owner == rhs.owner {
			if lhs.class == rhs.class {
				return lhs.index < rhs.index
			} else {
				return lhs.class < rhs.class
			}
		} else {
			return lhs.owner < rhs.owner
		}
	}
}

extension Unit.Class: Comparable {
	public static func < (lhs: Unit.Class, rhs: Unit.Class) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}
