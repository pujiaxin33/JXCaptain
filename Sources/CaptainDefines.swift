//
//  CaptainDefines.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public protocol Soldier {
    var name: String { get }
    var team: String { get }
    var icon: UIImage? { get }
    var contentView: UIView? { get }
    var hasNewEvent: Bool { get }
    func prepare()
    func action(naviController: UINavigationController)
}

//hasNewEvent、contentView添加默认实现，有需要的Soldier才添加。
public extension Soldier {
    var hasNewEvent: Bool { return false }
    var contentView: UIView? { return nil }
}

protocol Monitor {
    associatedtype ValueType
    var valueDidUpdateClosure: ((ValueType) -> Void)? { set get }
    func start()
    func end()
}

enum MonitorType {
    case fps
    case memory
    case cpu
    case anr
}

public extension Notification.Name {
    static let JXCaptainSoldierNewEventDidChange = Notification.Name("JXCaptainSoldierNewEventDidChange")
    static let JXCaptainNetworkObserverSoldierNewFlowDidReceive = Notification.Name("JXCaptainNetworkObserverSoldierNewFlowDidReceive")
}
