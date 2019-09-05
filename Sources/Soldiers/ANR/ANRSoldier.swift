//
//  ANRSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import BSBacktraceLogger

private let kANRSoldierIsActive = "kANRSoldierIsActive"
private let kANRSoldierHasNewEvent = "kANRSoldierHasNewEvent"

public class ANRSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var hasNewEvent: Bool {
        set(new) {
            if canCheckNewEvent {
                UserDefaults.standard.set(new, forKey: kANRSoldierHasNewEvent)
            }
        }
        get {
            if canCheckNewEvent {
                return UserDefaults.standard.bool(forKey: kANRSoldierHasNewEvent)
            }else {
                return false
            }
        }
    }
    public var canCheckNewEvent: Bool = true
    public var threshold: Double = 1
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kANRSoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kANRSoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?
    let monitor: ANRMonitor

    public init() {
        name = "卡顿"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_anr")
        monitor = ANRMonitor()
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(ANRDashboardViewController(soldier: self), animated: true)
    }

    func start() {
        monitor.threshold = threshold
        monitor.start()
        monitor.valueDidUpdateClosure = {[weak self] (value) in
            self?.dump()
        }
        isActive = true
    }

    func end() {
        monitor.end()
        isActive = false
    }

    func dump() {
        guard let threadInfo = BSBacktraceLogger.bs_backtraceOfMainThread() else {
            return
        }
        hasNewEvent = true
        ANRFileManager.saveInfo(threadInfo)
        NotificationCenter.default.post(name: .JXCaptainSoldierNewEventDidChange, object: self)
    }
}
