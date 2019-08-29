//
//  CrashSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kCrashSoldierHasNewEvent = "kCrashSoldierHasNewEvent"

public class CrashSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var exceptionReceiveClosure: ((Int32?, NSException?, String?)->())?
    public var hasNewEvent: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kCrashSoldierHasNewEvent)
        }
        get {
            return UserDefaults.standard.bool(forKey: kCrashSoldierHasNewEvent)
        }
    }
    let uncaughtExceptionHandler: CrashUncaughtExceptionHandler
    let signalExceptionHandler: CrashSignalExceptionHandler

    public init() {
        name = "Crash日志"
        team = "常用工具"
        icon = ImageManager.imageWithName("JXCaptain_icon_crash")
        uncaughtExceptionHandler = CrashUncaughtExceptionHandler()
        signalExceptionHandler = CrashSignalExceptionHandler()
        CrashUncaughtExceptionHandler.exceptionReceiveClosure = {[weak self] (signal, exception, info) in
            self?.exceptionReceiveClosure?(signal, exception, info)
            self?.hasNewEvent = true
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .JXCaptainSoldierNewEventDidChange, object: self)
            }
        }
        CrashSignalExceptionHandler.exceptionReceiveClosure = {[weak self] (signal, exception, info) in
            self?.exceptionReceiveClosure?(signal, exception, info)
            self?.hasNewEvent = true
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .JXCaptainSoldierNewEventDidChange, object: self)
            }
        }
    }

    public func prepare() {
        uncaughtExceptionHandler.prepare()
        signalExceptionHandler.prepare()
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(CrashDashboardViewController(soldier: self), animated: true)
    }
}
