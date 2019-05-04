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

	public var movedUnit: Unit? {
		switch self {
		case .move(let unit, _): return unit
		case .yoink(_, let unit, _): return unit
		case .place(let unit, _): return unit
		case .pass: return nil
		}
	}

	public var targetPosition: Position? {
		switch self {
		case .move(_, let position): return position
		case .yoink(_, _, let position): return position
		case .place(_, let position): return position
		case .pass: return nil
		}
	}
}

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

extension Movement {
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
