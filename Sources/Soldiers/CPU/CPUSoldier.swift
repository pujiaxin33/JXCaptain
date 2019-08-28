//
//  CPUSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kCPUSoldierIsActive = "kCPUSoldierIsActive"

class CPUSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kCPUSoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kCPUSoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?

    public init() {
        name = "CPU"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_cpu")
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(CPUDashboardViewController(cpuSoldier: self), animated: true)
    }

    func start() {
        CPUMonitor.shared.start()
        monitorView = MonitorConsoleLabel()
        CPUMonitor.shared.valueDidUpdateClosure = {[weak self] (value) in
            self?.monitorView?.update(type: .cpu, value: value)
        }
        MonitorListWindow.shared.enqueue(monitorView: monitorView!)
        isActive = true
    }

    func end() {
        CPUMonitor.shared.end()
        MonitorListWindow.shared.dequeue(monitorView: monitorView!)
        isActive = false
    }
}
