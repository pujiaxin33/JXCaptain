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
    var icon: UIImage? { get }
    var contentView: UIView? { get }
    func prepare()
    func action(naviController: UINavigationController)
}

public class Captain {
    public static let `default` = Captain()
    public var screenEdgeInsets: UIEdgeInsets
    internal var soldiers = [Soldier]()
    internal let floatingWindow = CaptainFloatingWindow()

    init() {
        let defaultSoldiers: [Soldier] = [AppInfoSoldier(), SanboxBrowserSoldier(), CrashSoldier(), WebsiteEntrySoldier()]
        soldiers.append(contentsOf: defaultSoldiers)
        var topEdgeInset: CGFloat = 20
        var bottomEdgeInset: CGFloat = 12
        if #available(iOS 11.0, *) {
            let safeAreaInsets = floatingWindow.safeAreaInsets
            if safeAreaInsets.top > 0 {
                topEdgeInset = safeAreaInsets.top
            }
            if safeAreaInsets.bottom > 0 {
                bottomEdgeInset = safeAreaInsets.bottom
            }
        }
        screenEdgeInsets = UIEdgeInsets(top: topEdgeInset, left: 12, bottom: bottomEdgeInset, right: 12)
    }

    public func show() {
        floatingWindow.isHidden = false
    }

    public func hide() {
        floatingWindow.rootViewController?.dismiss(animated: false, completion: nil)
        floatingWindow.isHidden = true
    }

    public func prepare() {
        soldiers.forEach { $0.prepare() }
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
