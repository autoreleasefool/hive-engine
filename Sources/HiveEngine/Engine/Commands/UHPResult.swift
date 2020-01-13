//
//  UHPResult.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-01-08.
//  Copyright © 2020 Joseph Roque. All rights reserved.
//

public enum UHPResult: Equatable {
	case output(String)
	case state(GameState?)
	case invalidCommand(String)
}
