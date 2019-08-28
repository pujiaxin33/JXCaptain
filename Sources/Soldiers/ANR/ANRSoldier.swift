//
//  ANRSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kANRSoldierIsActive = "kANRSoldierIsActive"

public class ANRSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
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
        //todo: 主线程信息
        DispatchQueue.main.async {
            let mainThreadInfos = Thread.callStackSymbols.reduce("") { (result, item) -> String in
                return "\(result)\(item)\n"
            }
            ANRFileManager.saveInfo(mainThreadInfos)
        }
    }
}
