//
//  CrashSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private var preUncaughtExceptionHandler: NSUncaughtExceptionHandler?

public class CrashUncaughtExceptionHandler {
    public static var exceptionReceiveClosure: ((Int32?, NSException?, String?)->())?

    public func prepare() {
        preUncaughtExceptionHandler = NSGetUncaughtExceptionHandler()
        NSSetUncaughtExceptionHandler(SoldierUncaughtExceptionHandler)
    }
}


func SoldierUncaughtExceptionHandler(exception: NSException) -> Void {
    let stackArray = exception.callStackSymbols
    let reason = exception.reason
    let name = exception.name.rawValue
    let stackInfo = stackArray.reduce("") { (result, item) -> String in
        return result + "\n\(item)"
    }
    let exceptionInfo = name + "\n" + (reason ?? "no reason") + "\n" + stackInfo
    CrashUncaughtExceptionHandler.exceptionReceiveClosure?(nil, exception, exceptionInfo)
    CrashFileManager.saveInfo(exceptionInfo, fileNamePrefix: "Crash(uncaught)")
    preUncaughtExceptionHandler?(exception)
    kill(getpid(), SIGKILL)
}
