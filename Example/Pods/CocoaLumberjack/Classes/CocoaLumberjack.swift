// Software License Agreement (BSD License)
//
// Copyright (c) 2014-2015, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

import Foundation
import CocoaLumberjack

extension SVLogFlag {
    public static func fromLogLevel(logLevel: SVLogLevel) -> SVLogFlag {
        return SVLogFlag(logLevel.rawValue)
    }
	
	public init(_ logLevel: SVLogLevel) {
		self = SVLogFlag(logLevel.rawValue)
	}
    
    ///returns the log level, or the lowest equivalant.
    public func toLogLevel() -> SVLogLevel {
        if let ourValid = SVLogLevel(rawValue: self.rawValue) {
            return ourValid
        } else {
            let logFlag = self
            if logFlag & .Verbose == .Verbose {
                return .Verbose
            } else if logFlag & .Debug == .Debug {
                return .Debug
            } else if logFlag & .Info == .Info {
                return .Info
            } else if logFlag & .Warning == .Warning {
                return .Warning
            } else if logFlag & .Error == .Error {
                return .Error
            } else {
                return .Off
            }
        }
    }
}

public var defaultDebugLevel = SVLogLevel.Verbose

public func resetDefaultDebugLevel() {
    defaultDebugLevel = SVLogLevel.Verbose
}

public func SwiftLogMacro(isAsynchronous: Bool, level: SVLogLevel, flag flg: SVLogFlag, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UInt = __LINE__, tag: AnyObject? = nil, @autoclosure(escaping) #string: () -> String) {
    if level.rawValue & flg.rawValue != 0 {
        // Tell the SVLogMessage constructor to copy the C strings that get passed to it. 
        // Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
        let logMessage = SVLogMessage(message: string(), level: level, flag: flg, context: context, file: "\(file)", function: "\(function)", line: line, tag: tag, options: .CopyFile | .CopyFunction, timestamp: nil)
        SVLog.log(isAsynchronous, message: logMessage)
    }
}

public func SVLogDebug(@autoclosure(escaping) logText: () -> String, level: SVLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Debug, context: context, file: file, function: function, line: line, tag: tag, string: logText)
}

public func SVLogInfo(@autoclosure(escaping) logText: () -> String, level: SVLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Info, context: context, file: file, function: function, line: line, tag: tag, string: logText)
}

public func SVLogWarn(@autoclosure(escaping) logText: () -> String, level: SVLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Warning, context: context, file: file, function: function, line: line, tag: tag, string: logText)
}

public func SVLogVerbose(@autoclosure(escaping) logText: () -> String, level: SVLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, asynchronous async: Bool = true) {
    SwiftLogMacro(async, level, flag: .Verbose, context: context, file: file, function: function, line: line, tag: tag, string: logText)
}

public func SVLogError(@autoclosure(escaping) logText: () -> String, level: SVLogLevel = defaultDebugLevel, context: Int = 0, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__, tag: AnyObject? = nil, asynchronous async: Bool = false) {
    SwiftLogMacro(async, level, flag: .Error, context: context, file: file, function: function, line: line, tag: tag, string: logText)
}

/// Analogous to the C preprocessor macro `THIS_FILE`.
public func CurrentFileName(fileName: StaticString = __FILE__) -> String {
    // Using string interpolation to prevent integer overflow warning when using StaticString.stringValue
    return "\(fileName)".lastPathComponent.stringByDeletingPathExtension
}
