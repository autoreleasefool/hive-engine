//
//  FatalError.swift
//  HiveEngine
//
//  Created by Joseph Roque on 2020-04-22.
//  Source: https://marcosantadev.com/test-swift-fatalerror/
//

import Foundation

#if DEBUG
let fatalErrorOverrideEnabled = true
#else
let fatalErrorOverrideEnabled = false
#endif

internal func fatalError(
	_ message: @autoclosure () -> String = "",
	file: StaticString = #file,
	line: UInt = #line
) -> Never {
	FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

internal struct FatalErrorUtil {
	private static let defaultFatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }

	static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure

	static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
		guard fatalErrorOverrideEnabled else { return }
		fatalErrorClosure = closure
	}

	static func restoreFatalError() {
		fatalErrorClosure = defaultFatalErrorClosure
	}
}
