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
	public let identifier: UUID
	/// Class of the unit to determine its movements
	public let `class`: Class
	/// Owner of the unit
	public let owner: Player

	init(`class`: Class, owner: Player, identifier: UUID = UUID()) {
		self.class = `class`
		self.owner = owner
		self.identifier = identifier
	}

	// MARK: Movement

	/// List the moves available for the unit.
	public func availableMoves(in state: GameState) -> Set<Movement> {
		return moves(as: self.class, in: state)
	}

	/// Returns a movement to the given position, unless the position is `.inHand`
	func movement(to position: Position) -> Movement? {
		switch position {
		case .inHand: return nil
		case .inPlay: return .move(unit: self, to: position)
		}
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

	/// Returns true if this unit can move as the given class.
	public func canMove(as givenClass: Class, in state: GameState) -> Bool {
		if self.class == givenClass {
			return true
		} else if self.class == .mosquito {
			// Mosquitos can only move as beetles when on top of the hive
			if stackPosition(in: state) ?? 0 > 0 {
				return givenClass == .beetle
			}

			// Mosquitos can otherwise move as any piece they're adjacent to
			return state.units(adjacentTo: self).filter { $0.class == givenClass }.count > 0
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
		guard let position = state.units[self],
			let stack = state.stacks[position] else {
				return nil
		}

		guard let height = stack.firstIndex(of: self) else { return nil }
		return height + 1
	}

	/// Returns true if this unit is surrounded on all 6 sides.
	public func isSurrounded(in state: GameState) -> Bool {
		return state.units(adjacentTo: self).count == 6
	}
}

// MARK: - Hashable

extension Unit: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(identifier)
	}
}

// MARK: - Equatable

extension Unit: Equatable {
	public static func == (lhs: Unit, rhs: Unit) -> Bool {
		return lhs.identifier == rhs.identifier
	}
}
