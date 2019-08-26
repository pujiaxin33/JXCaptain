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
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kFPSSoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kFPSSoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?

    public init() {
        name = "FPS"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_fps")
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(FPSDashboardViewController(fpsSoldier: self), animated: true)
    }

    func start() {
        FPSMonitor.shared.start()
        monitorView = MonitorConsoleLabel()
        FPSMonitor.shared.valueDidUpdateClosure = {[weak self] (value) in
            self?.monitorView?.update(type: .fps, value: Double(value))
        }
        MonitorListWindow.shared.enqueue(monitorView: monitorView!)
        isActive = true
    }

    func end() {
        FPSMonitor.shared.end()
        MonitorListWindow.shared.dequeue(monitorView: monitorView!)
        isActive = false
    }
}
