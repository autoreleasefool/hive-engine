//
//  GameState.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-07.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

/// State of a game of hive.
public class GameState: Codable {
	private enum CodingKeys: String, CodingKey {
		case options
		case unitsInPlay
		case unitsInHand
		case unitIsTopOfStack
		case stacks
		case currentPlayer
		case move
		case updates
		case endState
	}

	internal enum InternalOption {
		case unrestrictOpening
		case disableMovementValidation
	}

	/// Set an option for the game, before the game has begun.
	public func set(option: GameState.Option, to value: Bool) -> Bool {
		guard move == 0, option.isModifiable else { return false }
		if value {
			self.options.insert(option)
		} else {
			self.options.remove(option)
		}
		return true
	}

	/// Optional parameters
	private(set) public var options: Set<Option>

	/// Optional parameters for internal use only
	internal var internalOptions: Set<InternalOption> = []

	/// Units and their positions
	private(set) public var unitsInPlay: [Player: [Unit: Position]]

	/// Units still in each player's hand
	private(set) public var unitsInHand: [Player: Set<Unit>]

	/// Check if a unit is at the top of its stack. False when the unit is in hand.
	private(set) public var unitIsTopOfStack: [Unit: Bool] = [:]

	/// Stacks of units at a certain position
	private(set) public var stacks: [Position: [Unit]]

	/// The current player
	private(set) public var currentPlayer: Player

	/// The current move number
	private(set) public var move: Int

	/// List of updates made to the state
	private(set) public var updates: [Update] = []

	// Possible states for the end of the game. If nil, the game has not ended
	private(set) public var endState: EndState?

	/// True if the game has ended
	@available(*, deprecated, message: "Replaced by hasGameEnded")
	public var isEndGame: Bool {
		endState != nil
	}

	/// True if the game has ended
	public var hasGameEnded: Bool {
		endState != nil
	}

	/// The white player's queen
	private lazy var whiteQueen: Unit = {
		unitsInPlay[.white]!.first { $0.key.class == .queen }?.key ??
			unitsInHand[.white]!.first { $0.class == .queen }!
	}()

	/// The black player's queen
	private lazy var blackQueen: Unit = {
		unitsInPlay[.black]!.first { $0.key.class == .queen }?.key ??
			unitsInHand[.black]!.first { $0.class == .queen }!
	}()

	/// The unit most recently moved, locked for the current turn
	public var lastUnitMoved: Unit? {
		updates.last?.movement.movedUnit
	}

	/// The player to most recently make a move.
	public var lastPlayer: Player? {
		updates.last?.player
	}

	/// Returns the Player who has won the game, both players if it is a tie,
	/// or no players if the game has not ended
	@available(*, deprecated, message: "Please check endState for winners")
	public var winner: [Player] {
		var winners: [Player] = []
		if whiteQueen.isSurrounded(in: self) {
			winners.append(.black)
		}
		if blackQueen.isSurrounded(in: self) {
			winners.append(.white)
		}

		return winners
	}

	// MARK: - Constructors

	public init(options: Set<Option> = []) {
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
			let next = (classIndices[owner]![`class`] ?? 0) + 1
			classIndices[owner]![`class`] = next
			return next
		}

		let whiteUnits = Unit.Class.set(with: options)
			.map { Unit(class: $0, owner: .white, index: nextIndex(for: $0, belongingTo: .white)) }
		let blackUnits = Unit.Class.set(with: options)
			.map { Unit(class: $0, owner: .black, index: nextIndex(for: $0, belongingTo: .black)) }
		let allUnits = whiteUnits + blackUnits
		self.unitsInHand = [
			Player.white: Set(whiteUnits),
			Player.black: Set(blackUnits),
		]

		for unit in allUnits {
			self.unitIsTopOfStack[unit] = false
		}
	}

	public init(from state: GameState, withOptions: Set<Option>? = nil) {
		self.options = withOptions ?? state.options
		self.internalOptions = state.internalOptions
		self.unitsInPlay = state.unitsInPlay
		self.unitsInHand = state.unitsInHand
		self.unitIsTopOfStack = state.unitIsTopOfStack
		self.stacks = state.stacks
		self.currentPlayer = state.currentPlayer
		self.move = state.move
		self.updates = state.updates
		self.endState = state.endState
		self._availableMoves = state._availableMoves
		self._placeablePositions = state._placeablePositions
		self._playablePositions = state._playablePositions
		self.removedUnit = state.removedUnit
	}

	// MARK: - Moves

	/// Returns true if the player has played their queen, otherwise returns false.
	public func queenPlayed(for player: Player) -> Bool {
		let queen = player == .white ? whiteQueen : blackQueen
		return unitsInPlay[player]?[queen] != nil
	}

	/// Cache available moves
	private var _availableMoves: Set<Movement>?

	/// List the available movements from a GameState. Benefits from caching
	public var availableMoves: Set<Movement> {
		guard removedUnit == nil else { fatalError("Cannot determine available moves with a removed unit") }

		if let cachedMoves = _availableMoves {
			return cachedMoves
		}

		let cachedMoves = moves(for: currentPlayer)
		_availableMoves = cachedMoves
		return cachedMoves
	}

	/// Available moves for the given player
	private func moves(for player: Player) -> Set<Movement> {
		guard !hasGameEnded else { return [] }

		var moves: Set<Movement> = []
		let placeablePositionsForPlayer = placeablePositions(for: player)

		// Queen must be played in player's first 4 moves
		if (player == .white && move == 6 && !queenPlayed(for: .white)) ||
			(player == .black && move == 7 && !queenPlayed(for: .black)) {
			let queen = player == .white ? whiteQueen : blackQueen
			for placeablePosition in placeablePositionsForPlayer {
				moves.insert(.place(unit: queen, at: placeablePosition))
			}

			return moves
		}

		let playableUnitsForPlayer = playableUnits(for: player)

		// Get placeable pieces
		for unit in playableUnitsForPlayer {
			for space in placeablePositionsForPlayer {
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
	@discardableResult
	public func apply(relativeMovement: RelativeMovement) -> Bool {
		guard removedUnit == nil else { fatalError("Cannot alter state while a unit is removed") }
		return apply(relativeMovement.movement(in: self))
	}

	/// Applies the movement to this game state (if it is valid)
	@discardableResult
	public func apply(_ movement: Movement) -> Bool {
		guard removedUnit == nil else { fatalError("Cannot alter state while a unit is removed") }

		// Ensure only valid moves are played
		if !internalOptions.contains(.disableMovementValidation) {
			guard validate(movement: movement) else {
				return false
			}
		}

		let notation = movement.notation(in: self)
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

		updates.append(Update(
			player: updatePlayer,
			movement: updateMovement,
			previousPosition: updatePosition,
			move: updateMove,
			notation: notation
		))
		updateEndState()
		return true
	}

	/// Apply a `move` or `yoink` Movement to the state.
	private func applyMove(unit: Unit, position: Position) {
		let startPosition = unitsInPlay[unit.owner]![unit]!
		_ = stacks[startPosition]?.popLast()
		if stacks[startPosition]?.isEmpty ?? false {
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
	}

	/// Apply a `place` Movement to the state.
	private func applyPlace(unit: Unit, position: Position) {
		stacks[position] = [unit]
		unitsInPlay[unit.owner]![unit] = position
		unitsInHand[unit.owner]!.remove(unit)
		unitIsTopOfStack[unit] = true
	}

	/// Undo the most recent move
	public func undoMove() {
		guard removedUnit == nil else { fatalError("Cannot alter state while a unit is removed") }

		guard let lastMove = updates.popLast() else { return }
		resetCaches()
		currentPlayer = lastMove.player
		move = lastMove.move

		switch lastMove.movement {
		case .move(let unit, let position):
			let startPosition = position
			let endPosition = lastMove.previousPosition!
			_ = stacks[startPosition]?.popLast()
			if stacks[startPosition]?.isEmpty ?? false {
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
		case .yoink(_, let unit, let position):
			let previousPosition = lastMove.previousPosition!
			stacks[position] = nil
			stacks[previousPosition] = [unit]
			unitsInPlay[unit.owner]![unit] = previousPosition
		case .place(let unit, let position):
			stacks[position] = nil
			unitsInPlay[unit.owner]![unit] = nil
			unitsInHand[unit.owner]!.insert(unit)
			unitIsTopOfStack[unit] = false
		case .pass:
			break
		}
		updateEndState()
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

	private var removedUnit: (Unit, Position)?

	internal func temporarilyRemove(unit: Unit) {
		guard removedUnit == nil else { fatalError("Cannot manage more than one removed unit at a time") }
		guard unit.isTopOfStack(in: self) else { fatalError("Cannot remove a unit which is not the top of its stack") }
		guard let position = self.position(of: unit) else { return }
		self.unitsInPlay[unit.owner]?[unit] = nil
		_ = self.stacks[position]?.popLast()
		if self.stacks[position]?.isEmpty ?? false {
			self.stacks[position] = nil
		}
		removedUnit = (unit, position)
	}

	internal func replaceRemovedUnit() {
		guard let (unit, position) = removedUnit else { return }
		self.unitsInPlay[unit.owner]?[unit] = position
		if self.stacks[position] == nil {
			self.stacks[position] = [unit]
		} else {
			self.stacks[position]?.append(unit)
		}
		removedUnit = nil
	}

	/// Returns the position of a unit on the board, if it's on the board.
	public func position(of unit: Unit) -> Position? {
		unitsInPlay[unit.owner]?[unit]
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

		// Filter down to pieces with either index == 1, or where all units of the same class with lower
		// indices have been played
		for unit in allAvailablePiecesForPlayer {
			guard unit.index == 1 ||
				!allAvailablePiecesForPlayer.contains(Unit(
					class: unit.class,
					owner: unit.owner,
					index: unit.index - 1
				)) else { continue }
			playablePiecesForPlayer.insert(unit)
		}

		// Remove queen in the case of `noFirstMoveQueen`
		if (move == 0 || move == 1) && options.contains(.noFirstMoveQueen) {
			playablePiecesForPlayer.remove(whiteQueen)
			playablePiecesForPlayer.remove(blackQueen)
		}

		return playablePiecesForPlayer
	}

	internal var allPlayablePositions: Set<Position> {
		Set(stacks.keys.flatMap { $0.adjacent().filter { stacks[$0] == nil } })
	}

	/// Cache playablePositions
	private var _playablePositions: Set<Position>?

	/// List of positions to which pieces can be moved
	var playablePositions: Set<Position> {
		if let cache = _playablePositions {
			return cache
		}

		_playablePositions = allPlayablePositions
		return _playablePositions!
	}

	/// Cache placeablePosiitons for each player
	private var _placeablePositions: [Player: Set<Position>] = [:]

	/// List of positions at which a player can place a piece.
	public func placeablePositions(for player: Player) -> Set<Position> {
		if let cache = _placeablePositions[player] {
			return cache
		}

		if move == 0 {
			return [.origin]
		} else if move == 1 {
			return internalOptions.contains(.unrestrictOpening)
				? Set(Position.origin.adjacent())
				: [Position(x: 0, y: 1, z: -1)]
		}

		var placeable = playablePositions
		self.unitsInPlay[player.next]?
			.filter { $0.key.isTopOfStack(in: self) }
			.forEach {
				$0.value.adjacent().forEach { placeable.remove($0) }
			}
		_placeablePositions[player] = placeable
		return placeable
	}

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
		while !stack.isEmpty {
			let position = stack.popLast()!
			for adjacent in position.adjacent() {
				if allPositions.contains(adjacent) && !found.contains(adjacent) {
					found.insert(adjacent)
					stack.append(adjacent)
				}
			}
		}

		return found == allPositions
	}

	private func updateEndState() {
		let whiteSurrounded = whiteQueen.isSurrounded(in: self)
		let blackSurrounded = blackQueen.isSurrounded(in: self)

		if whiteSurrounded && !blackSurrounded {
			endState = .playerWins(.black)
		} else if blackSurrounded && !whiteSurrounded {
			endState = .playerWins(.white)
		} else if blackSurrounded && whiteSurrounded {
			endState = .draw
		} else {
			endState = nil
		}
	}

	// MARK: - Private

	private func resetCaches() {
		_availableMoves = nil
		_playablePositions = nil
		_placeablePositions.removeAll()
	}
}

// MARK: - Option

extension GameState {
	public enum Option: String, Codable, CaseIterable {
		/// Include the Lady Bug unit
		case ladyBug = "LadyBug"
		/// Include the Mosquito unit
		case mosquito = "Mosquito"
		/// Include the Pill Bug unit
		case pillBug = "PillBug"
		/// Disallow playing the Queen on either player's first move
		case noFirstMoveQueen = "NoFirstMoveQueen"
		/// Allow players to use their Pill Bug's special ability, immediately after that Pill Bug was yoinked
		case allowSpecialAbilityAfterYoink = "AllowSpecialAbilityAfterYoink"

		var isModifiable: Bool {
			switch self {
			case .ladyBug, .mosquito, .pillBug: return false
			case .noFirstMoveQueen, .allowSpecialAbilityAfterYoink: return true
			}
		}

		public var isExpansion: Bool {
			switch self {
			case .ladyBug, .mosquito, .pillBug: return true
			case .noFirstMoveQueen, .allowSpecialAbilityAfterYoink: return false
			}
		}
	}
}

// MARK: - Update

extension GameState {
	public struct Update: Codable, Equatable, Hashable {
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
	}
}

// MARK: - EndState

extension GameState {
	public enum EndState: Equatable, Hashable {
		case playerWins(Player)
		case draw
	}
}

extension GameState.EndState: Codable {
	private enum CodingKeys: String, CodingKey {
		case player
		case status
	}

	private enum Status: String, Codable {
		case playerWins
		case draw
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		switch self {
		case .draw:
			try container.encode(Status.draw, forKey: .status)
		case .playerWins(let player):
			try container.encode(Status.playerWins, forKey: .status)
			try container.encode(player, forKey: .player)
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let status = try container.decode(Status.self, forKey: .status)
		switch status {
		case .draw:
			self = .draw
		case .playerWins:
			let player = try container.decode(Player.self, forKey: .player)
			self = .playerWins(player)
		}
	}
}

// MARK: - Equatable

extension GameState: Equatable {
	public static func == (lhs: GameState, rhs: GameState) -> Bool {
		lhs.options == rhs.options &&
			lhs.unitsInPlay == rhs.unitsInPlay &&
			lhs.unitsInHand == rhs.unitsInHand &&
			lhs.unitIsTopOfStack == rhs.unitIsTopOfStack &&
			lhs.stacks == rhs.stacks &&
			lhs.currentPlayer == rhs.currentPlayer &&
			lhs.move == rhs.move &&
			lhs.updates == rhs.updates &&
			lhs.endState == rhs.endState
	}
}

// MARK: - Hashable

extension GameState: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(options)
		hasher.combine(unitsInPlay)
		hasher.combine(unitsInHand)
		hasher.combine(unitIsTopOfStack)
		hasher.combine(stacks)
		hasher.combine(currentPlayer)
		hasher.combine(move)
		hasher.combine(updates)
		hasher.combine(endState)
	}
}

// MARK: - CustomStringConvertible

extension GameState: CustomStringConvertible {
	public var description: String {
		self.gameString
	}
}
