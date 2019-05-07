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
	let previousPosition: Position?
	/// The move number
	let move: Int
	/// Standard notation describing the movement in the context of the state it was played
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	let notation: String
}

/// State of a game of hive.
public class GameState: Codable {
	private enum CodingKeys: String, CodingKey {
		case options
		case unitsInPlay
		case unitsInHand
		case stacks
		case currentPlayer
		case move
	}

	public enum Options: String, Codable {
		/// Include the Lady Bug unit
		case ladyBug = "Lady Bug"
		/// Include the Mosquito unit
		case mosquito = "Mosquito"
		/// Include the Pill Bug unit
		case pillBug = "Pill Bug"
		/// Restrict the black player's opening move to only one position
		case restrictedOpening = "Restricted Opening"
		/// Disallow playing the Queen on either player's first move
		case noFirstMoveQueen = "No First Move Queen"
		/// Allow players to use their Pill Bug's special ability, immediately after that Pill Bug was yoinked
		case allowSpecialAbilityAfterYoink = "Allow Special Ability after Yoink"
		/// Disable validation of movements before applying
		case disableMovementValidation = "Disable Movement Validation"
	}

	/// Optional parameters
	private(set) public var options: Set<Options>

	/// Units and their positions
	private(set) public var unitsInPlay: [Player: [Unit: Position]]

	/// Units still in each player's hand
	private(set) public var unitsInHand: [Player: Set<Unit>]

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

	/// The white player's queen
	private lazy var whiteQueen: Unit = {
		return unitsInPlay[Player.white]!.first { $0.key.class == .queen }?.key ?? unitsInHand[Player.white]!.first { $0.class == .queen }!
	}()

	/// The black player's queen
	private lazy var blackQueen: Unit = {
		return unitsInPlay[Player.black]!.first { $0.key.class == .queen }?.key ?? unitsInHand[Player.black]!.first { $0.class == .queen }!
	}()

	/// All units currently in play in the state.
	public var allUnitsInPlay: [Unit: Position] {
		return unitsInPlay[Player.white]!.merging(unitsInPlay[Player.black]!, uniquingKeysWith: { p1, _ in p1 })
	}

	/// The unit most recently moved, locked for the current turn
	public var lastUnitMoved: Unit? {
		guard let lastMove = previousMoves.last else { return nil }
		return lastMove.movement.movedUnit
	}

	/// The player to most recently make a move.
	public var lastPlayer: Player? {
		guard let lastMove = previousMoves.last else { return nil }
		return lastMove.player
	}

	/// Returns the Player who has won the game, both players if it is a tie,
	/// or no players if the game has not ended
	public var winner: [Player] {
		var winners: [Player] = []
		if whiteQueen.isSurrounded(in: self) {
			winners.append(Player.white)
		}
		if blackQueen.isSurrounded(in: self) {
			winners.append(Player.black)
		}

		return winners
	}

	// MARK: - Constructors

	public init(options: Set<Options> = []) {
		self.options = options
		self.currentPlayer = .white
		self.unitsInPlay = [
			Player.white: [:],
			Player.black: [:]
		]
		self.stacks = [:]
		self.move = 0

		var classIndices: [Player: [Unit.Class: Int]] = [
			Player.white: [:],
			Player.black: [:]
		]

		func nextIndex(for `class`: Unit.Class, belongingTo owner: Player) -> Int {
			let next = (classIndices[owner]![`class`] ?? 0) + 1
			classIndices[owner]![`class`] = next
			return next
		}

		let whiteUnits = Unit.Class.set(with: options).map { Unit(class: $0, owner: .white, index: nextIndex(for: $0, belongingTo: .white)) }
		let blackUnits = Unit.Class.set(with: options).map { Unit(class: $0, owner: .black, index: nextIndex(for: $0, belongingTo: .black)) }
		self.unitsInHand = [
			Player.white: Set(whiteUnits),
			Player.black: Set(blackUnits)
		]
	}

	public init(from state: GameState) {
		self.options = state.options
		self.currentPlayer = state.currentPlayer
		self.unitsInHand = state.unitsInHand
		self.unitsInPlay = state.unitsInPlay
		self.stacks = state.stacks
		self.previousMoves = state.previousMoves
		self.move = state.move
	}

	// MARK: - Moves

	/// Returns true if the player has played their queen, otherwise returns false.
	public func queenPlayed(for player: Player) -> Bool {
		switch player {
		case .white:
			return self.unitsInPlay[Player.white]![whiteQueen] != nil
		case .black:
			return self.unitsInPlay[Player.black]![blackQueen] != nil
		}
	}

	/// Cache available moves
	private var _availableMoves: [Movement]?

	/// List the available movements from a GameState. Benefits from caching
	public var availableMoves: [Movement] {
		if let cachedMoves = _availableMoves {
			return cachedMoves
		}

		let cachedMoves = moves(for: currentPlayer)
		_availableMoves = cachedMoves
		return cachedMoves
	}

	/// Available moves for the given player
	private func moves(for player: Player) -> [Movement] {
		guard isEndGame == false else { return [] }

		let playableUnitsForPlayer = playableUnits(for: player)
		let playableSpacesForPlayer = playableSpaces(for: player)

		// Queen must be played in player's first 4 moves
		if (player == .white && move == 6) || (player == .black && move == 7),
			let queen = playableUnitsForPlayer.filter({ $0.class == .queen }).first {
			return playableSpacesForPlayer.map { .place(unit: queen, at: $0) }
		}

		// Get placeable pieces
		let placePieceMovements: [Movement] = playableUnitsForPlayer.flatMap { unit in
			return playableSpacesForPlayer.map { .place(unit: unit, at: $0) }
		}

		// Player can only place pieces until their queen has been played
		guard queenPlayed(for: player) else { return placePieceMovements }

		// Iterate over all pieces on the board
		let movePieceMovements = unitsInPlay[player]!
			// Get moves available for the piece
			.flatMap { $0.key.availableMoves(in: self) }

		let allMoves = placePieceMovements + movePieceMovements
		guard allMoves.count > 0 else {
			return [.pass]
		}

		return allMoves
	}

	/// Standard notation for a position relative to another Unit.
	///
	/// - Parameters:
	///   - position: the Position for which relative notation should be determined
	private func adjacentUnitNotation(relativePosition position: Position) -> String {
		// If the movement is on top of another unit, return the unit moved onto
		if let stack = stacks[position], stack.count > 1 {
			return stack[stack.count - 2].notation
		}

		guard let adjacentUnit = units(adjacentTo: position).first,
			let adjacentUnitPosition = unitsInPlay[adjacentUnit.owner]?[adjacentUnit] else { return "" }

		// For this notation, since positions are defined with horizontal hexagons (see the top of the file),
		// but standard notation uses vertical hexagons, all relative positions are defined by rotating the map
		// 60 degrees clockwise, such that (1, 0, -1) is to the north east of (0, 0, 0)
		let difference = position.subtracting(adjacentUnitPosition)
		switch (difference.x, difference.y, difference.z) {
		case (1, 0, -1): return "\(adjacentUnit.notation)/"
		case (1, -1, 0): return "\(adjacentUnit.notation)-"
		case (0, -1, 1): return "\(adjacentUnit.notation)\\"
		case (-1, 0, 1): return "/\(adjacentUnit.notation)"
		case (-1, 1, 0): return "-\(adjacentUnit.notation)"
		case (0, 1, -1): return "\\\(adjacentUnit.notation)"
		default: return ""
		}
	}

	/// Applies the movement to this game state (if it is valid)
	public func apply(_ movement: Movement) {
		// Ensure only valid moves are played
		if options.contains(.disableMovementValidation) == false {
			guard validate(movement: movement) else { return }
		}

		var notation = (movement == .pass) ? "pass" : "\(movement.movedUnit!.notation)"
		let updatePlayer = currentPlayer
		let updateMovement = movement
		let updateMove = move
		let updatePosition: Position?

		resetCaches()
		currentPlayer = currentPlayer.next
		move += 1

		switch movement {
		case .move(let unit, let position):
			// Move a piece from its previous stack to a new position
			let startPosition = unitsInPlay[unit.owner]![unit]!
			updatePosition = startPosition
			_ = stacks[startPosition]?.popLast()
			if (stacks[startPosition]?.count ?? -1) == 0 {
				stacks[startPosition] = nil
			}
			if stacks[position] == nil {
				stacks[position] = []
			}
			stacks[position]!.append(unit)
			unitsInPlay[unit.owner]![unit] = position
		case .yoink(_, let unit, let position):
			// Move a piece from its previous stack to a new position adjacent to the pill bug
			updatePosition = unitsInPlay[unit.owner]![unit]!
			stacks[unitsInPlay[unit.owner]![unit]!] = nil
			stacks[position] = [unit]
			unitsInPlay[unit.owner]![unit] = position
		case .place(let unit, let position):
			// Place an unplayed piece on the board
			updatePosition = nil
			stacks[position] = [unit]
			unitsInPlay[unit.owner]![unit] = position
			unitsInHand[unit.owner]!.remove(unit)
		case .pass:
			updatePosition = nil
		}

		if updateMove > 0 && movement != .pass {
			notation = "\(notation) \(adjacentUnitNotation(relativePosition: movement.targetPosition!))"
		}

		previousMoves.append(GameStateUpdate(player: updatePlayer, movement: updateMovement, previousPosition: updatePosition, move: updateMove, notation: notation))
	}

	/// Undo the most recent move
	public func undoMove() {
		guard let lastMove = previousMoves.popLast() else { return }
		resetCaches()
		currentPlayer = lastMove.player
		move = lastMove.move

		switch lastMove.movement {
		case .move(let unit, let position):
			let startPosition = position
			let endPosition = lastMove.previousPosition!
			_ = stacks[startPosition]?.popLast()
			if (stacks[startPosition]?.count ?? -1) == 0 {
				stacks[startPosition] = nil
			}
			if stacks[endPosition] == nil {
				stacks[endPosition] = []
			}
			stacks[endPosition]!.append(unit)
			unitsInPlay[unit.owner]![unit] = endPosition
		case .yoink(_, let unit, let position):
			let previousPosition = lastMove.previousPosition!
			stacks[position] = nil
			stacks[previousPosition] = [unit]
			unitsInPlay[unit.owner]![unit] = previousPosition
		case .place(let unit, let position):
			stacks[position] = nil
			unitsInPlay[unit.owner]![unit] = nil
			unitsInHand[unit.owner]!.insert(unit)
		case .pass:
			break
		}
	}

	/// Validate that a given move is valid in the current state.
	private func validate(movement: Movement) -> Bool {
		return availableMoves.contains(movement)
	}

	// MARK: Units

	/// List the units which are at the top of a stack adjacent to the position of a unit.
	public func units(adjacentTo unit: Unit) -> [Unit] {
		guard let position = unitsInPlay[unit.owner]?[unit] else { return [] }
		return units(adjacentTo: position)
	}

	/// List the units which are at the top of a stack adjacent to a position.
	public func units(adjacentTo position: Position) -> [Unit] {
		return position.adjacent().compactMap {
			guard let stack = stacks[$0] else { return nil }
			return stack.last
		}
	}

	/// Units which can currently be played from the Player's hand.
	///
	/// - Parameters:
	///   - player: the player to get the playable units for
	public func playableUnits(for player: Player) -> Set<Unit> {
		let allAvailablePiecesForPlayer = unitsInHand[player]!.sorted()

		// Filter down to pieces with either index == 1, or where all units of the same class with lower indices have been played
		var playablePiecesForPlayer = Set(allAvailablePiecesForPlayer.enumerated().filter { index, unit in
			guard unit.index > 1 && index > 0 else { return true }
			let previousUnit = allAvailablePiecesForPlayer[index - 1]
			return previousUnit.class != unit.class
			}.map { $0.element })

		if (move == 0 || move == 1) && options.contains(.noFirstMoveQueen) {
			playablePiecesForPlayer.remove(whiteQueen)
			playablePiecesForPlayer.remove(blackQueen)
		}

		return playablePiecesForPlayer
	}

	/// Positions which are adjacent to another piece and are not filled.
	///
	/// - Parameters:
	///  - excludedUnit: optionally exclude a unit when determining if the space is playable
	public func playableSpaces(excluding excludedUnit: Unit? = nil, for player: Player? = nil) -> Set<Position> {
		if move == 0 { return [.origin] }
		if move == 1 && options.contains(.restrictedOpening) { return [Position(x: 0, y: 1, z: -1)] }

		var includedUnits = allUnitsInPlay
		if let excluded = excludedUnit {
			includedUnits[excluded] = nil
		}

		let takenPositions = self.stacks.keys

		let allSpaces = Set(includedUnits
			.filter { $0.key.isTopOfStack(in: self) }
			.values.flatMap { $0.adjacent() }).subtracting(takenPositions)
		guard let player = player, move > 1 else { return allSpaces }
		let unavailableSpaces = Set(includedUnits
			.filter { $0.key.owner != player && $0.key.isTopOfStack(in: self) }
			.values.flatMap { $0.adjacent() }).subtracting(takenPositions)
		return allSpaces.subtracting(unavailableSpaces)
	}

	// MARK: - Validation

	/// Determine if this game state meets the "One Hive" rule.
	///
	/// - Parameters:
	///   - excludedUnit: optionally exclude a unit when determining if the rule is met
	public func oneHive(excluding excludedUnit: Unit? = nil) -> Bool {
		let allPositions = Set(allUnitsInPlay.filter { $0.key != excludedUnit }.compactMap { $0.value })
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

	// MARK: - Private

	private func resetCaches() {
		_availableMoves = nil
	}
}

extension GameState: Equatable {
	public static func == (lhs: GameState, rhs: GameState) -> Bool {
		return lhs.unitsInPlay == rhs.unitsInPlay &&
			lhs.unitsInHand == rhs.unitsInHand &&
			lhs.stacks == rhs.stacks &&
			lhs.move == rhs.move &&
			lhs.currentPlayer == rhs.currentPlayer &&
			lhs.options == rhs.options
	}
}

extension GameState: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(unitsInPlay)
		hasher.combine(unitsInHand)
		hasher.combine(stacks)
		hasher.combine(move)
		hasher.combine(currentPlayer)
		hasher.combine(options)
	}
}
