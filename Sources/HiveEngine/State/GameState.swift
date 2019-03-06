//
//  GameState.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

public struct GameStateUpdate: Codable, Equatable {
	/// Player who made the move
	let player: Player
	/// The movement applied to the state
	let movement: Movement
	/// Previous position of the unit moved in `movement`
	let previousPosition: Position
	/// The move number
	let move: Int
}

/// State of a game of hive.
public class GameState: Codable {

	/// Units and their positions
	private(set) public var units: [Unit: Position]

	/// Units which are currently in play.
	public var unitsInPlay: Set<Unit> {
		return Set(units.filter { $0.value != .inHand }.keys)
	}

	/// Stacks of units at a certain position
	private(set) public var stacks: [Position: [Unit]]

	/// The current player
	private(set) public var currentPlayer: Player

	/// The current move number
	private(set) public var move: Int

	/// The most recently moved unit
	private(set) public var previousMoves: [GameStateUpdate] = []

	/// True if the game has ended
	public var isEndGame: Bool {
		return winner.isNotEmpty
	}

	/// Returns the Player who has won the game, both players if it is a tie,
	/// or no players if the game has not ended
	public var winner: [Player] {
		var winners: [Player] = []
		let queens = units.filter { $0.key.class == .queen }.map { $0.key }

		if queens[0].isSurrounded(in: self) {
			winners.append(queens[0].owner.next)
		}
		if queens[1].isSurrounded(in: self) {
			winners.append(queens[1].owner.next)
		}

		return winners
	}

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

	public init(from state: GameState) {
		self.currentPlayer = state.currentPlayer
		self.units = state.units
		self.stacks = state.stacks
		self.previousMoves = state.previousMoves
		self.move = state.move
	}

	// MARK: - Updates

	/// List the available movements from a GameState.
	public var availableMoves: [Movement] {
		return moves(for: currentPlayer)
	}

	/// List the available movements from a GameState for the opponent.
	public var opponentMoves: [Movement] {
		return moves(for: currentPlayer.next)
	}

	public func moves(for player: Player) -> [Movement] {
		guard isEndGame == false else { return [] }

		let availablePiecesForPlayer = availablePieces(for: player)

		// Only available moves at the start of the game are to place a piece at (0, 0, 0)
		// or to place a piece next to the original piece
		if move == 0 {
			return availablePiecesForPlayer.map { .place(unit: $0, at: .inPlay(x: 0, y: 0, z: 0)) }
		}

		let playableSpacesForPlayer = playableSpaces(for: player)

		// Queen must be played in player's first 4 moves
		if (player == .white && move == 6) || (player == .black && move == 7),
			let queen = availablePiecesForPlayer.filter({ $0.class == .queen }).first {
			return playableSpacesForPlayer.map { .place(unit: queen, at: $0) }
		}

		// Get placeable and moveable pieces
		let placePieceMovements: [Movement] = availablePiecesForPlayer.flatMap { unit in
			return playableSpacesForPlayer.map { .place(unit: unit, at: $0) }
		}

		// Iterate over all pieces on the board
		let movePieceMovements = units.filter {  $0.value != .inHand }
			// Only the current player can move
			.filter { $0.key.owner == player }
			// Moving the piece must not break the hive
			.filter { $0.key.class == .pillBug || oneHive(excluding: $0.key) }
			// Get moves available for the piece
			.flatMap { $0.key.availableMoves(in: self) }

		return placePieceMovements + movePieceMovements
	}

	/// Applies the movement to this game state (if it is valid)
	public func apply(_ movement: Movement) {
		// Ensure only valid moves are played
		guard validate(movement: movement) else { return }

		let updatePlayer = currentPlayer
		let updateMovement = movement
		let updateMove = move
		let updatePosition: Position

		currentPlayer = currentPlayer.next
		move += 1

		switch movement {
		case .move(let unit, let position):
			// Move a piece from its previous stack to a new position
			let startPosition = units[unit]!
			updatePosition = startPosition
			_ = stacks[startPosition]?.popLast()
			if (stacks[startPosition]?.count ?? -1) == 0 {
				stacks[startPosition] = nil
			}
			if stacks[position] == nil {
				stacks[position] = []
			}
			stacks[position]!.append(unit)
			units[unit] = position
		case .yoink(_, let unit, let position):
			// Move a piece from its previous stack to a new position adjacent to the pill bug
			updatePosition = units[unit]!
			stacks[units[unit]!] = nil
			stacks[position] = [unit]
			units[unit] = position
		case .place(let unit, let position):
			// Place an unplayed piece on the board
			updatePosition = .inHand
			stacks[position] = [unit]
			units[unit] = position
		}

		// When a player is shut out, skip their turn
		if isEndGame == false && anyMovesAvailable(for: currentPlayer) == false {
			currentPlayer = currentPlayer.next
		}

		previousMoves.append(GameStateUpdate(player: updatePlayer, movement: updateMovement, previousPosition: updatePosition, move: updateMove))
	}

	/// Undo the most recent move
	public func undoMove() {
		guard let lastMove = previousMoves.popLast() else { return }
		currentPlayer = lastMove.player
		move = lastMove.move

		switch lastMove.movement {
		case .move(let unit, let position):
			let startPosition = position
			_ = stacks[startPosition]?.popLast()
			if (stacks[startPosition]?.count ?? -1) == 0 {
				stacks[startPosition] = nil
			}
			if stacks[lastMove.previousPosition] == nil {
				stacks[lastMove.previousPosition] = []
			}
			stacks[lastMove.previousPosition]!.append(unit)
			units[unit] = lastMove.previousPosition
		case .yoink(_, let unit, let position):
			stacks[position] = nil
			stacks[lastMove.previousPosition] = [unit]
			units[unit] = lastMove.previousPosition
		case .place(let unit, let position):
			stacks[position] = nil
			units[unit] = .inHand
		}
	}

	/// Validate that a given move is valid in the current state.
	private func validate(movement: Movement) -> Bool {
		switch movement {
		case .move(let unit, _):
			return unit.availableMoves(in: self).contains(movement)
		case .yoink(let pillBug, _, _):
			return pillBug.availableMoves(in: self).contains(movement)
		case .place(let unit, let position):
			return units[unit] == .inHand && playableSpaces(for: currentPlayer).contains(position)
		}
	}

	/// Returns true if there are any moves available for the given player.
	public func anyMovesAvailable(for player: Player) -> Bool {
		if isEndGame { return false }

		// Check if any pieces can be placed
		if availablePieces(for: player).count > 0 && playableSpaces(for: player).count > 0 {
			return true
		}

		// Check if any pieces on the board has available moves
		for unit in units.filter({ $0.value != .inHand && $0.key.owner == player }).map({ $0.key }) {
			if unit.availableMoves(in: self).count > 0 {
				return true
			}
		}

		return false
	}

	// MARK: Units

	/// List the unplayed pieces for a player.
	public func availablePieces(for player: Player) -> Set<Unit> {
		return Set(units.filter { $0.key.owner == player && units[$0.key] == .inHand }.keys)
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

	/// Positions which are adjacent to another piece and are not filled.
	///
	/// - Parameters:
	///  - excludedUnit: optionally exclude a unit when determining if the space is playable
	public func playableSpaces(excluding excludedUnit: Unit? = nil, for player: Player? = nil) -> Set<Position> {
		if move == 0 { return [.inPlay(x: 0, y: 0, z: 0)] }

		var includedUnits = unitsInPlay
		if let excluded = excludedUnit {
			includedUnits.remove(excluded)
		}

		let allSpaces = Set(units
			.filter { includedUnits.contains($0.key) }
			.filter { $0.key.isTopOfStack(in: self) }
			.values.flatMap { $0.adjacent() }).subtracting(stacks.keys)
		guard let player = player, move > 1 else { return allSpaces }
		let unavailableSpaces = Set(units
			.filter { $0.key.owner != player }
			.filter { $0.key.isTopOfStack(in: self) }
			.values.flatMap { $0.adjacent() }).subtracting(stacks.keys)
		return allSpaces.subtracting(unavailableSpaces)
	}

	// MARK: - Validation

	/// Determine if this game state meets the "One Hive" rule.
	///
	/// - Parameters:
	///   - excludedUnit: optionally exclude a unit when determining if the rule is met
	public func oneHive(excluding excludedUnit: Unit? = nil) -> Bool {
		let allPositions = Set(units.filter { $0.key != excludedUnit && $0.value != .inHand }.compactMap { $0.value })
		guard let startPosition = allPositions.first else { return true }

		var found = Set([startPosition])
		var stack = [startPosition]

		// DFS through pieces and their adjacent positions to determine graph connectivity
		while stack.isNotEmpty {
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

extension GameState: Equatable {
	public static func == (lhs: GameState, rhs: GameState) -> Bool {
		return lhs.units == rhs.units &&
			lhs.stacks == rhs.stacks &&
			lhs.move == rhs.move &&
			lhs.currentPlayer == rhs.currentPlayer
	}
}

extension GameState: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(units)
		hasher.combine(stacks)
		hasher.combine(move)
		hasher.combine(currentPlayer)
	}
}
