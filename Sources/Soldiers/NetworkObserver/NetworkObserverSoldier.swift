//
//  NetworkObserverSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

private let kNetworkObserverSoldierIsActive = "kNetworkObserverSoldierIsActive"

public class NetworkObserverSoldier: Soldier {
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var hasNewEvent: Bool = false
    public var threshold: Double = 1
    var isActive: Bool {
        set(new) {
            UserDefaults.standard.set(new, forKey: kNetworkObserverSoldierIsActive)
        }
        get {
            return UserDefaults.standard.bool(forKey: kNetworkObserverSoldierIsActive)
        }
    }
    var monitorView: MonitorConsoleLabel?
    let monitor: ANRMonitor
    var flowModels = [NetworkFlowModel]()

    public init() {
        name = "流量监控"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_network")
        monitor = ANRMonitor()
    }

    public func prepare() {
        if isActive {
            start()
        }
    }

    public func action(naviController: UINavigationController) {
        naviController.pushViewController(NetworkObserverDashboardViewController(soldier: self), animated: true)
    }

    func start() {
        URLProtocol.registerClass(JXCaptainURLProtocol.self)
        URLSession.swizzleInit
        isActive = true
    }

    func end() {
        URLProtocol.unregisterClass(JXCaptainURLProtocol.self)
        isActive = false
    }

    func recordRequest(request: URLRequest, response: URLResponse, responseData: Data, startDate: Date) {
        let flowModel = NetworkFlowModel(request: request, response: response, responseData: responseData, startDate: startDate)
        flowModels.insert(flowModel, at: 0)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.JXCaptainNetworkObserverSoldierNewFlowDidReceive, object: flowModel)
        }
    }
}
