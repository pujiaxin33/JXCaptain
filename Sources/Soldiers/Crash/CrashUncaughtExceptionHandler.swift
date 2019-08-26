//
//  CrashSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private var preUncaughtExceptionHandler: NSUncaughtExceptionHandler?

class CrashUncaughtExceptionHandler {
    func prepare() {
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
    CrashFileManager.saveCrashInfo(exceptionInfo, crashTypeName: "Crash(uncaught)")
    preUncaughtExceptionHandler?(exception)
    kill(getpid(), SIGKILL)
}
