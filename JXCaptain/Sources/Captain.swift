//
//  Captain.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public protocol Soldier {
    var name: String { get }
    var team: String { get }
    var icon: UIImage { get }
    func action()
    func moveToDashboard(naviController: UINavigationController)
}

public class Captain {
    public static let `default` = Captain()
    internal var soldiers = [Soldier]()
    internal let floatingWindow = CaptainFloatingWindow()

    init() {
        let defaultSoldiers: [Soldier] = [AppInfoSoldier(), SanboxBrowserSoldier(), CrashSoldier()]
        soldiers.append(contentsOf: defaultSoldiers)
    }

    public func show() {
        floatingWindow.isHidden = false
    }

    public func hide() {
        floatingWindow.rootViewController?.dismiss(animated: false, completion: nil)
        floatingWindow.isHidden = true
    }

    public func action() {
    }

    public func enqueueSoldier(_ soldier: Soldier) {
        soldiers.append(soldier)
    }

    public func removeAllSoldiers() {
        soldiers.removeAll()
    }

    public func dequeueSoldiers(soldierTypes: [Soldier.Type]) {
        for (index, soldier) in soldiers.enumerated() {
            let currentSoldierType = type(of: soldier)
            let isExisted = soldierTypes.contains { (type) -> Bool in
                if type == currentSoldierType {
                    return true
                }else {
                    return false
                }
            }
            if isExisted {
                soldiers.remove(at: index)
                break
            }
        }
    }
}
