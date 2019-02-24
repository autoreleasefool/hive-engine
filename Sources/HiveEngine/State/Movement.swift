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

	public var movedUnit: Unit {
		switch self {
		case .move(let unit, _): return unit
		case .yoink(_, let unit, _): return unit
		case .place(let unit, _): return unit
		}
	}

	public var targetPosition: Position {
		switch self {
		case .move(_, let position): return position
		case .yoink(_, _, let position): return position
		case .place(_, let position): return position
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

		fileprivate init(movement: Movement) {
			switch movement {
			case .move(let unit, let position):
				self.move = Move(unit: unit, to: position)
			case .yoink(let pillBug, let unit, let position):
				self.yoink = Yoink(pillBug: pillBug, unit: unit, to: position)
			case .place(let unit, let position):
				self.place = Move(unit: unit, to: position)
			}
		}

		fileprivate func movement() throws -> Movement {
			switch (move, yoink, place) {
			case (.some(let move), nil, nil):
				return .move(unit: move.unit, to: move.to)
			case (nil, .some(let yoink), nil):
				return .yoink(pillBug: yoink.pillBug, unit: yoink.unit, to: yoink.to)
			case (nil, nil, .some(let place)):
				return .place(unit: place.unit, at: place.to)
			default:
				throw Movement.CodingError.standard("Could not convert \(self) into a Movement")
			}
		}
	}
}

//swiftlint:enable nesting
