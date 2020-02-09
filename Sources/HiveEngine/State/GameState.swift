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
	public let player: Player
	/// The movement applied to the state
	public let movement: Movement
	/// Previous position of the unit moved in `movement`
	public let previousPosition: Position?
	/// The move number
	public let move: Int
	/// Standard notation describing the movement in the context of the state it was played
	/// See http://www.boardspace.net/english/about_hive_notation.html for a description of the notation
	public let notation: String

	public init(player: Player, movement: Movement, previousPosition: Position?, move: Int, notation: String) {
		self.player = player
		self.movement = movement
		self.previousPosition = previousPosition
		self.move = move
		self.notation = notation
	}
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

	public enum Options: String, Codable, CaseIterable {
		/// Include the Lady Bug unit
		case ladyBug = "LadyBug"
		/// Include the Mosquito unit
		case mosquito = "Mosquito"
		/// Include the Pill Bug unit
		case pillBug = "PillBug"
		/// Restrict the black player's opening move to only one position
		case restrictedOpening = "RestrictedOpening"
		/// Disallow playing the Queen on either player's first move
		case noFirstMoveQueen = "NoFirstMoveQueen"
		/// Allow players to use their Pill Bug's special ability, immediately after that Pill Bug was yoinked
		case allowSpecialAbilityAfterYoink = "AllowSpecialAbilityAfterYoink"
		/// Disable validation of movements before applying
		case disableMovementValidation = "DisableMovementValidation"
		/// Disable standard notation generation for improved performance
		case disableNotation = "DisableStandardNotation"
		/// Treat Movement.yoink and Movement.move as equivalents
		case treatYoinkAsMove = "TreatYoinkAsMove"

		var isModifiable: Bool {
			switch self {
			case .ladyBug, .mosquito, .pillBug: return false
			case .restrictedOpening, .noFirstMoveQueen, .allowSpecialAbilityAfterYoink, .disableMovementValidation, .disableNotation, .treatYoinkAsMove: return true
			}
		}
	}

	/// Optional parameters
	private(set) public var options: Set<Options>

	/// Units and their positions
	private(set) public var unitsInPlay: [Player: [Unit: Position]]

	/// All units in play and their positions
	private(set) public var allUnitsInPlay: [Unit: Position] = [:]

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
		return winner.isEmpty == false
	}

	/// The white player's queen
	private lazy var whiteQueen: Unit = {
		return unitsInPlay[Player.white]!.first { $0.key.class == .queen }?.key ?? unitsInHand[Player.white]!.first { $0.class == .queen }!
	}()

	/// The black player's queen
	private lazy var blackQueen: Unit = {
		return unitsInPlay[Player.black]!.first { $0.key.class == .queen }?.key ?? unitsInHand[Player.black]!.first { $0.class == .queen }!
	}()

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

	/// Check if a unit is at the top of its stack. False when the unit is in hand.
	private(set) public var unitIsTopOfStack: [Unit: Bool] = [:]

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
			Player.black: [:],
		]
		self.stacks = [:]
		self.move = 0

		var classIndices: [Player: [Unit.Class: Int]] = [
			Player.white: [:],
			Player.black: [:],
		]

		func nextIndex(for `class`: Unit.Class, belongingTo owner: Player) -> Int {
			let next = (classIndices[owner]![`class`] ?? 0) &+ 1
			classIndices[owner]![`class`] = next
			return next
		}

		let whiteUnits = Unit.Class.set(with: options).map { Unit(class: $0, owner: .white, index: nextIndex(for: $0, belongingTo: .white)) }
		let blackUnits = Unit.Class.set(with: options).map { Unit(class: $0, owner: .black, index: nextIndex(for: $0, belongingTo: .black)) }
		let allUnits = whiteUnits + blackUnits
		self.unitsInHand = [
			Player.white: Set(whiteUnits),
			Player.black: Set(blackUnits),
		]

		for unit in allUnits {
			self.unitIsTopOfStack[unit] = false
		}
	}

	public init(from state: GameState, withOptions: Set<Options>? = nil) {
		self.options = withOptions ?? state.options
		self.currentPlayer = state.currentPlayer
		self.unitsInHand = state.unitsInHand
		self.unitsInPlay = state.unitsInPlay
		self.stacks = state.stacks
		self.previousMoves = state.previousMoves
		self.move = state.move
		self.unitIsTopOfStack = state.unitIsTopOfStack
		self.allUnitsInPlay = state.allUnitsInPlay
	}

	// MARK: - Moves

	/// Track whether the White player's queen has been played yet
	private var whiteQueenPlayed: Bool = false
	/// Track whether the Black player's queen has been played yet
	private var blackQueenPlayed: Bool = false

	/// Returns true if the player has played their queen, otherwise returns false.
	public func queenPlayed(for player: Player) -> Bool {
		switch player {
		case .white:
			return whiteQueenPlayed
		case .black:
			return blackQueenPlayed
		}
	}

	/// Cache available moves
	private var _availableMoves: Set<Movement>?

	/// List the available movements from a GameState. Benefits from caching
	public var availableMoves: Set<Movement> {
		if let cachedMoves = _availableMoves {
			return cachedMoves
		}

		let cachedMoves = moves(for: currentPlayer)
		_availableMoves = cachedMoves
		return cachedMoves
	}

	/// Available moves for the given player
	private func moves(for player: Player) -> Set<Movement> {
		guard isEndGame == false else { return [] }

		var moves: Set<Movement> = []
		let playableSpacesForPlayer = playableSpaces(for: player)

		// Queen must be played in player's first 4 moves
		if (player == .white && move == 6 && queenPlayed(for: .white) == false) || (player == .black && move == 7 && queenPlayed(for: .black) == false) {
			let queen = player == .white ? whiteQueen : blackQueen
			for playableSpace in playableSpacesForPlayer {
				moves.insert(.place(unit: queen, at: playableSpace))
			}

			return moves
		}

		let playableUnitsForPlayer = playableUnits(for: player)

		// Get placeable pieces
		for unit in playableUnitsForPlayer {
			for space in playableSpacesForPlayer {
				moves.insert(.place(unit: unit, at: space))
			}
		}

		// Player can only place pieces until their queen has been played
		guard queenPlayed(for: player) else { return moves }

		// Iterate over all pieces on the board
		for (unit, _) in unitsInPlay[player]! {
			// Get moves available for the piece
			unit.availableMoves(in: self, moveSet: &moves)
		}

		guard moves.count > 0 else { return [.pass] }
		return moves
	}

	/// Applies the movement to this game state (if it is valid)
	public func apply(relativeMovement: RelativeMovement) {
		apply(relativeMovement.movement(in: self))
	}

	/// Applies the movement to this game state (if it is valid)
	public func apply(_ movement: Movement) {
		// Ensure only valid moves are played
		if options.contains(.disableMovementValidation) == false {
			guard validate(movement: movement) else { return }
		}

		var notation = ""
		if options.contains(.disableNotation) == false {
			notation = movement.notation(in: self)
		}

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
			applyMove(unit: unit, position: position)
		case .yoink(_, let unit, let position):
			// Move a piece from its previous stack to a new position adjacent to the pill bug
			updatePosition = unitsInPlay[unit.owner]![unit]!
			applyMove(unit: unit, position: position)
		case .place(let unit, let position):
			// Place an unplayed piece on the board
			updatePosition = nil
			applyPlace(unit: unit, position: position)
		case .pass:
			updatePosition = nil
		}

		previousMoves.append(GameStateUpdate(player: updatePlayer, movement: updateMovement, previousPosition: updatePosition, move: updateMove, notation: notation))
	}

	/// Apply a `move` or `yoink` Movement to the state.
	private func applyMove(unit: Unit, position: Position) {
		let startPosition = unitsInPlay[unit.owner]![unit]!
		_ = stacks[startPosition]?.popLast()
		if (stacks[startPosition]?.count ?? -1) == 0 {
			stacks[startPosition] = nil
		} else {
			unitIsTopOfStack[stacks[startPosition]!.last!] = true
		}
		if stacks[position] == nil {
			stacks[position] = []
		} else {
			unitIsTopOfStack[stacks[position]!.last!] = false
		}
		stacks[position]!.append(unit)
		unitsInPlay[unit.owner]![unit] = position
		allUnitsInPlay[unit] = position
	}

	/// Apply a `place` Movement to the state.
	private func applyPlace(unit: Unit, position: Position) {
		stacks[position] = [unit]
		unitsInPlay[unit.owner]![unit] = position
		unitsInHand[unit.owner]!.remove(unit)
		allUnitsInPlay[unit] = position
		unitIsTopOfStack[unit] = true

		if unit == whiteQueen {
			whiteQueenPlayed = true
		} else if unit == blackQueen {
			blackQueenPlayed = true
		}
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
			} else {
				unitIsTopOfStack[stacks[startPosition]!.last!] = true
			}
			if stacks[endPosition] == nil {
				stacks[endPosition] = []
			} else {
				unitIsTopOfStack[stacks[endPosition]!.last!] = false
			}
			stacks[endPosition]!.append(unit)
			unitsInPlay[unit.owner]![unit] = endPosition
			allUnitsInPlay[unit] = endPosition
		case .yoink(_, let unit, let position):
			let previousPosition = lastMove.previousPosition!
			stacks[position] = nil
			stacks[previousPosition] = [unit]
			unitsInPlay[unit.owner]![unit] = previousPosition
			allUnitsInPlay[unit] = previousPosition
		case .place(let unit, let position):
			stacks[position] = nil
			unitsInPlay[unit.owner]![unit] = nil
			unitsInHand[unit.owner]!.insert(unit)
			unitIsTopOfStack[unit] = false
			allUnitsInPlay[unit] = nil

			if unit == whiteQueen {
				whiteQueenPlayed = false
			} else if unit == blackQueen {
				blackQueenPlayed = false
			}
		case .pass:
			break
		}
	}

	/// Validate that a given move is valid in the current state.
	private func validate(movement: Movement) -> Bool {
		if availableMoves.contains(movement) {
			return true
		}

		return availableMoves.contains {
			if case let .yoink(_, unit, position) = $0,
				unit == movement.movedUnit && position == movement.targetPosition {
				return true
			}

			return false
		}
	}

	// MARK: - Units

	/// Returns the position of a unit on the board, if it's on the board.
	public func position(of unit: Unit) -> Position? {
		return unitsInPlay[unit.owner]?[unit]
	}

	/// List the units which are at the top of a stack adjacent to the position of a unit.
	public func units(adjacentTo unit: Unit) -> [Unit] {
		guard let position = unitsInPlay[unit.owner]?[unit] else { return [] }
		return units(adjacentTo: position)
	}

	/// List the units which are at the top of a stack adjacent to a position.
	public func units(adjacentTo position: Position) -> [Unit] {
		var adjacentUnits: [Unit] = []
		for adjacentPosition in position.adjacent() {
			if let stack = stacks[adjacentPosition], let unit = stack.last {
				adjacentUnits.append(unit)
			}
		}
		return adjacentUnits
	}

	/// Units which can currently be played from the Player's hand.
	///
	/// - Parameters:
	///   - player: the player to get the playable units for
	public func playableUnits(for player: Player) -> Set<Unit> {
		var playablePiecesForPlayer: Set<Unit> = []

		// Start with all pieces in the player's hand
		let allAvailablePiecesForPlayer = unitsInHand[player]!

		// Filter down to pieces with either index == 1, or where all units of the same class with lower indices have been played
		for unit in allAvailablePiecesForPlayer {
			guard unit.index == 1 || allAvailablePiecesForPlayer.contains(Unit(class: unit.class, owner: unit.owner, index: unit.index - 1)) == false else { continue }
			playablePiecesForPlayer.insert(unit)
		}

		// Remove queen in the case of `noFirstMoveQueen`
		if (move == 0 || move == 1) && options.contains(.noFirstMoveQueen) {
			playablePiecesForPlayer.remove(whiteQueen)
			playablePiecesForPlayer.remove(blackQueen)
		}

		return playablePiecesForPlayer
	}

	/// Cache all playable spaces
	private var _playableSpaces: Set<Position>?
	/// Cache playable spaces for the current player
	private var _playableSpacesCurrentPlayer: Set<Position>?

	// swiftlint:disable cyclomatic_complexity
	#warning("SwiftLint:cyclomatic_complexity disable for `playableSpaces`")

	/// Positions which are adjacent to another piece and are not filled.
	///
	/// - Parameters:
	///  - excludedUnit: optionally exclude a unit when determining if the space is playable
	public func playableSpaces(excluding excludedUnit: Unit? = nil, for player: Player? = nil) -> Set<Position> {
		if player == nil, excludedUnit == nil, let spaces = _playableSpaces {
			return spaces
		} else if player == currentPlayer, excludedUnit == nil, let spaces = _playableSpacesCurrentPlayer {
			return spaces
		}

		if move == 0 { return [.origin] }
		if move == 1 && options.contains(.restrictedOpening) { return [Position(x: 0, y: 1, z: -1)] }

		var includedUnits = allUnitsInPlay
		if let excluded = excludedUnit {
			includedUnits[excluded] = nil
		}

		let takenPositions = self.stacks.keys

		// Get all open spaces adjacent to another unit
		var allSpaces: Set<Position> = []
		for (unit, position) in includedUnits {
			guard unit.isTopOfStack(in: self) else { continue }
			for adjacent in position.adjacent() {
				guard takenPositions.contains(adjacent) == false else { continue }
				allSpaces.insert(adjacent)
			}
		}

		guard let player = player else {
			if excludedUnit == nil {
				_playableSpaces = allSpaces
			}
			return allSpaces
		}

		guard move > 1 else { return allSpaces }

		// Remove spaces adjacent to an enemy's unit
		for (unit, position) in includedUnits {
			guard unit.owner != player && unit.isTopOfStack(in: self) else { continue }
			for adjacent in position.adjacent() {
				allSpaces.remove(adjacent)
			}
		}

		if player == currentPlayer && excludedUnit == nil {
			_playableSpacesCurrentPlayer = allSpaces
		}

		return allSpaces
	}

	// swiftlint:enable cyclomatic_complexity

	// MARK: - Validation

	/// Determine if this game state meets the "One Hive" rule.
	///
	/// - Parameters:
	///   - excludedUnit: optionally exclude a unit when determining if the rule is met
	public func oneHive(excluding excludedUnit: Unit? = nil) -> Bool {
		var allPositions = Set(stacks.keys)

		if let excludedUnit = excludedUnit,
			let excludedPosition = unitsInPlay[excludedUnit.owner]?[excludedUnit],
			let excludedStack = stacks[excludedPosition],
			excludedStack.count == 1 {
			allPositions.remove(excludedPosition)
		}

		guard let startPosition = allPositions.first else { return true }

		var found = Set([startPosition])
		var stack = [startPosition]

		// DFS through pieces and their adjacent positions to determine graph connectivity
		while stack.isEmpty == false {
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
		_playableSpaces = nil
		_playableSpacesCurrentPlayer = nil
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
