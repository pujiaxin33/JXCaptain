//
//  CrashSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/22.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class CrashSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    let uncaughtExceptionHandler = CrashUncaughtExceptionHandler()
    let signalExceptionHandler = CrashSignalExceptionHandler()

    public init() {
        name = "Crash日志"
        team = "常用工具"
        icon = ImageManager.imageWithName("JXCaptain_icon_crash")
    }

    public func prepare() {
        uncaughtExceptionHandler.prepare()
        signalExceptionHandler.prepare()
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(CrashDashboardViewController(style: .plain), animated: true)
    }
}
