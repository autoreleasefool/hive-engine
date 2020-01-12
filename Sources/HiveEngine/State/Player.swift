//
//  Player.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

/// Players of the game
public enum Player: Int, Codable {
	/// The first player, white
	case white = 0
	/// The second player, black
	case black = 1

	/// Returns the next player
	public var next: Player {
		switch self {
		case .black: return .white
		case .white: return .black
		}
	}

	init?(notation: String) {
		switch notation {
		case "w": self = .white
		case "b": self = .black
		default: return nil
		}
	}
}

// MARK: - CustomStringConvertible

extension Player: CustomStringConvertible {
	public var description: String {
		switch self {
		case .black: return "Black"
		case .white: return "White"
		}
	}

	init?(from: String) {
		switch from {
		case "Black": self = .black
		case "White": self = .white
		default: return nil
		}
	}
}

// MARK: - Comparable

extension Player: Comparable {
	public static func < (lhs: Player, rhs: Player) -> Bool {
		return lhs.rawValue < rhs.rawValue
	}
}
