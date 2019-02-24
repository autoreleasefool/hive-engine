//
//  GameState.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

/// Immutable state of a game of hive.
public class GameState: Codable {

	/// Units and their positions
	private(set) public var units: [Unit: Position]

	/// Units which are currently in play.
	public lazy var unitsInPlay: Set<Unit> = {
		return Set(units.filter { $0.value != .inHand }.keys)
	}()

	/// Positions which are adjacent to another piece and are not filled.
	public lazy var playableSpaces: Set<Position> = {
		return Set(units.filter { unitsInPlay.contains($0.key) }.values.flatMap { $0.adjacent() }).subtracting(stacks.keys)
	}()

	/// Stacks of units at a certain position
	private(set) public var stacks: [Position: [Unit]]

	/// The current player
	private(set) public var currentPlayer: Player

	/// The current move number
	private(set) public var move: Int

	public var isEndGame: Bool {
		return winner.isNotEmpty
	}

	/// Returns the Player who has won the game, both players if it is a tie,
	/// or no players if the game has not ended
	public lazy var winner: [Player] = {
		var winners: [Player] = []
		let queens = units.filter { $0.key.class == .queen }.map { $0.key }

		if queens[0].isSurrounded(in: self) {
			winners.append(queens[0].owner.next)
		}
		if queens[1].isSurrounded(in: self) {
			winners.append(queens[1].owner.next)
		}

		return winners
	}()

	// MARK: - Constructors

	public init() {
		self.currentPlayer = .white
		self.stacks = [:]
		self.move = 0

		let whiteUnits = Unit.Class.fullSet.map { Unit(class: $0, owner: .white) }
		let blackUnits = Unit.Class.fullSet.map { Unit(class: $0, owner: .black) }
		self.units = [:]
		(whiteUnits + blackUnits).forEach {
			self.units[$0] = .inHand
		}
	}

	/// Create a game state from a previous one.
	/// The current player and move area progressed when created and the units and positions are duplicated.
	public init(from other: GameState) {
		self.currentPlayer = other.currentPlayer.next
		self.move = other.move + 1
		self.units = other.units
		self.stacks = other.stacks
	}

	// MARK: - Updates

	/// List the available movements from a GameState.
	public lazy var availableMoves: [Movement] = {
		guard isEndGame == false else { return [] }

		if move == 0 {
			return availablePieces(for: currentPlayer).map { .place(unit: $0, at: .inPlay(x: 0, y: 0, z: 0)) }
		}

		if (currentPlayer == .white && move == 6) || (currentPlayer == .black && move == 7),
			let queen = availablePieces(for: currentPlayer).filter({ $0.class == .queen }).first {
			return playableSpaces.map { .place(unit: queen, at: $0) }
		}

		let placePieceMovements: [Movement] = availablePieces(for: currentPlayer).flatMap { unit in
			return playableSpaces.map { .place(unit: unit, at: $0) }
		}

		var movePieceMovements: [Movement] = []
		units.filter { $0.value != .inHand }
			.filter { $0.key.owner == currentPlayer }
			.filter { oneHive(excluding: $0.key) }
			.forEach { movePieceMovements.append(contentsOf: $0.key.availableMoves(in: self)) }

		return placePieceMovements + movePieceMovements
	}()

	/// Applies the movement to this game state (if it is valid) and returns
	/// the updated game state.
	public func apply(_ move: Movement) -> GameState {
		let update = GameState(from: self)

		// Ensure only valid moves are played
		guard availableMoves.contains(move) else { return update }

		switch move {
		case .move(let unit, let position):
			// Move a piece from its previous stack to a new position
			_ = update.stacks[update.units[unit]!]?.popLast()
			if update.stacks[position] == nil {
				update.stacks[position] = []
			}
			update.stacks[position]!.append(unit)
			update.units[unit] = position
		case .yoink(_, let unit, let position):
			// Move a piece from its previous stack to a new position adjacent to the pill bug
			update.stacks[update.units[unit]!] = nil
			update.stacks[position] = [unit]
			update.units[unit] = position
		case .place(let unit, let position):
			// Place an unplayed piece on the board
			update.stacks[position] = [unit]
			update.units[unit] = position
		}

		return update
	}

	// MARK: Units

	/// List the unplayed pieces for a player.
	public func availablePieces(for player: Player) -> Set<Unit> {
		return Set(units.filter { $0.key.owner == player }.keys).subtracting(unitsInPlay)
	}

	/// List the units which are at the top of a stack adjacent to the position of a unit.
	public func units(adjacentTo unit: Unit) -> Set<Unit> {
		guard let position = units[unit], position != .inHand else { return [] }
		return units(adjacentTo: position)
	}

	/// List the units which are at the top of a stack adjacent to a position.
	public func units(adjacentTo position: Position) -> Set<Unit> {
		return Set(position.adjacent().compactMap {
			guard let stack = stacks[$0] else { return nil }
			return stack.last
		})
	}

	// MARK: - Validation

	/// Determine if this game state meets the "One Hive" rule.
	///
	/// - Parameters:
	///   - unit: optionally exclude a unit when determining if the rule is met
	public func oneHive(excluding excludedUnit: Unit? = nil) -> Bool {
		let allPositions = Set(units.filter { $0.key != excludedUnit }.compactMap { $0.value })
		guard let startPosition = allPositions.first else { return true }

		var found = Set([startPosition])
		var stack = [startPosition]

		// DFS through pieces and their adjacent positions to determine graph connectivity
		while stack.isNotEmpty{
			let position = stack.popLast()!
			for adjacent in position.adjacent() {
				if allPositions.contains(adjacent) && found.contains(adjacent) == false {
					found.insert(adjacent)
					stack.append(adjacent)
				}
			}
		}

		return found == allPositions
	}
}
