//
//  FPSSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kFPSSoldierIsActive = "kFPSSoldierIsActive"

public class FPSSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var hasNewEvent: Bool = false
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kFPSSoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kFPSSoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?
    let monitor: FPSMonitor

    public init() {
        name = "FPS"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_fps")
        monitor = FPSMonitor()
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(FPSDashboardViewController(soldier: self), animated: true)
    }

    func start() {
        monitor.start()
        monitorView = MonitorConsoleLabel()
        monitor.valueDidUpdateClosure = {[weak self] (value) in
            self?.monitorView?.update(type: .fps, value: Double(value))
        }
        MonitorListWindow.shared.enqueue(monitorView: monitorView!)
        isActive = true
    }

    func end() {
        monitor.end()
        MonitorListWindow.shared.dequeue(monitorView: monitorView!)
        isActive = false
    }
}
