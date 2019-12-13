//
//  MemorySoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class MemorySoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    var isActive: Bool {
        set { UserDefaults.standard.isMemorySoldierActive = newValue }
        get { UserDefaults.standard.isMemorySoldierActive }
    }
    var monitorView: MonitorConsoleLabel?
    let monitor: MemoryMonitor

    public init() {
        name = "内存"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_memory")
        monitor = MemoryMonitor()
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(MemoryDashboardViewController(soldier: self), animated: true)
    }

    public func start() {
        monitor.start()
        monitorView = MonitorConsoleLabel()
        monitor.valueDidUpdateClosure = {[weak self] (value) in
            self?.monitorView?.update(type: .memory, value: value)
        }
        MonitorListWindow.shared.enqueue(monitorView: monitorView!)
        isActive = true
    }

    public func end() {
        monitor.end()
        MonitorListWindow.shared.dequeue(monitorView: monitorView!)
        isActive = false
    }
}
