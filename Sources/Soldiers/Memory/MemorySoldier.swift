//
//  MemorySoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kMemorySoldierIsActive = "kMemorySoldierIsActive"

class MemorySoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kMemorySoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kMemorySoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?

    public init() {
        name = "内存"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_memory")
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(MemoryDashboardViewController(memorySoldier: self), animated: true)
    }

    func start() {
        MemoryMonitor.shared.start()
        monitorView = MonitorConsoleLabel()
        MemoryMonitor.shared.valueDidUpdateClosure = {[weak self] (value) in
            self?.monitorView?.update(type: .memory, value: value)
        }
        MonitorListWindow.shared.enqueue(monitorView: monitorView!)
        isActive = true
    }

    func end() {
        MemoryMonitor.shared.end()
        MonitorListWindow.shared.dequeue(monitorView: monitorView!)
        isActive = false
    }
}
