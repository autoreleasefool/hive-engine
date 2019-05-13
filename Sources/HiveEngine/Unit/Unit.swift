//
//  Unit.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

public struct Unit: Codable {

	public enum Class: String, CaseIterable, Codable {
		case ant = "Ant"
		case beetle = "Beetle"
		case hopper = "Hopper"
		case ladyBug = "Lady Bug"
		case mosquito = "Mosquito"
		case pillBug = "Pill Bug"
		case queen = "Queen"
		case spider = "Spider"

		/// A single player's full set of units
		public static var basicSet: [Class] {
			return [
				.ant, .ant, .ant,
				.beetle, .beetle,
				.hopper, .hopper, .hopper,
				.queen,
				.spider, .spider
			]
		}

		/// Get a set of Units for a game based on the Options provided.
		public static func set(with options: Set<GameState.Options>) -> [Class] {
			var basicSet = Class.basicSet
			if options.contains(.ladyBug) { basicSet.append(.ladyBug) }
			if options.contains(.mosquito) { basicSet.append(.mosquito) }
			if options.contains(.pillBug) { basicSet.append(.pillBug) }
			return basicSet
		}

		public var orderedValue: Int {
			switch self {
			case .ant: return 0
			case .beetle: return 1
			case .hopper: return 2
			case .ladyBug: return 3
			case .mosquito: return 4
			case .pillBug: return 5
			case .queen: return 6
			case .spider: return 7
			}
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

	/// Standard unit notation
	public var notation: String {
		let colorNotation: String = owner == .white ? "w" : "b"
		let indexNotation: String = "\(index)"
		let classNotation: String
		switch self.class {
		case .ant: classNotation = "A"
		case .beetle: classNotation = "B"
		case .hopper: classNotation = "G"
		case .ladyBug: classNotation = "L"
		case .mosquito: classNotation = "M"
		case .pillBug: classNotation = "P"
		case .queen: classNotation = "Q"
		case .spider: classNotation = "S"
		}

		return "\(colorNotation)\(classNotation)\(indexNotation)"
	}

	// MARK: Movement

	/// List the moves available for the unit.
	public func availableMoves(in state: GameState) -> Set<Movement> {
		return moves(as: self.class, in: state)
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
		return state.oneHive(excluding: self) && self.isTopOfStack(in: state) && self != state.lastUnitMoved
	}

	/// Returns true if this unit can move as the given class.
	public func canCopyMoves(of givenClass: Class, in state: GameState) -> Bool {
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
		guard self != state.lastUnitMoved || state.options.contains(.allowSpecialAbilityAfterYoink) else { return false }

		switch self.class {
		case .pillBug:
			return true
		case .mosquito:
			return canCopyMoves(of: .pillBug, in: state)
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
		return height &+ 1
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
		return "\(self.owner.description) \(self.class.description) (\(self.index))"
	}
}

extension Unit.Class: CustomStringConvertible {
	public var description: String {
		return self.rawValue
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
			}
			return lhs.class < rhs.class
		}
		return lhs.owner < rhs.owner
	}
}

extension Unit.Class: Comparable {
	public static func < (lhs: Unit.Class, rhs: Unit.Class) -> Bool {
		return lhs.orderedValue < rhs.orderedValue
	}
}
