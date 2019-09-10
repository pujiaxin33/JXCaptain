//
//  NetworkObserverSoldier.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import WebKit

private let kNetworkObserverSoldierIsActive = "kNetworkObserverSoldierIsActive"

public class NetworkObserverSoldier: Soldier {
    public static let shared = NetworkObserverSoldier()
    public var name: String
    public var team: String
    public var icon: UIImage?
    public var contentView: UIView?
    public var hasNewEvent: Bool = false
    /// responseData数据缓存最大容量，默认：50MB
    public var responseCacheByteLimit: Int = 50 * 1024 * 1024 {
        didSet {
            cache.countLimit = responseCacheByteLimit
        }
    }
    /// 是否能拦截WKWebView的接口，默认为false。
    /// 拦截的原理参考文章：https://blog.moecoder.com/2016/10/26/support-nsurlprotocol-in-wkwebview/ 因为WKWebView是一个单独的进程，如果要通过自定义的协议进行拦截，就会导致进程间通信，降低性能。所以，需要拦截WKWebView时，需要自己设置为true。
    public var canInterceptWKWebView: Bool = false
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
    let cache = NSCache<AnyObject, AnyObject>()

    public init() {
        name = "流量"
        team = "性能检测"
        icon = ImageManager.imageWithName("JXCaptain_icon_network")
        monitor = ANRMonitor()
        cache.countLimit = responseCacheByteLimit
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
        if canInterceptWKWebView {
            WKWebView.register(schemes: ["http", "https"])
        }
        URLProtocol.registerClass(JXCaptainURLProtocol.self)
        URLSession.swizzleInit
        isActive = true
    }

    func end() {
        if canInterceptWKWebView {
            WKWebView.unregister(schemes: ["http", "https"])
        }
        URLProtocol.unregisterClass(JXCaptainURLProtocol.self)
        isActive = false
    }

    func recordRequest(request: URLRequest, response: URLResponse?, responseData: Data?, error: NSError?, startDate: Date) {
        let flowModel = NetworkFlowModel(request: request, response: response, responseData: responseData, error: error, startDate: startDate)
        flowModels.insert(flowModel, at: 0)
        if let data = responseData {
            cache.setObject(data as AnyObject, forKey: flowModel.requestID as AnyObject, cost: data.count)
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name.JXCaptainNetworkObserverSoldierNewFlowDidReceive, object: flowModel)
        }
    }
}

extension String {
    public var base64Decode: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    public var base64Encode: String {
        return Data(utf8).base64EncodedString()
    }
}

extension WKWebView {
    private class func browsing_contextController() -> (NSObject.Type)? {
        guard let str = "YnJvd3NpbmdDb250ZXh0Q29udHJvbGxlcg==".base64Decode else { assertionFailure(); return nil }
        // str: "browsingContextController"
        guard let obj =  WKWebView().value(forKey: str) else { return nil }
        return type(of: obj) as? NSObject.Type
    }

    private class func perform_browsing_contextController(aSelector: Selector, schemes: Set<String>) -> Bool {
        guard let obj = browsing_contextController(), obj.responds(to: aSelector), schemes.count > 0 else {
            assertionFailure(); return false
        }
        var result = schemes.count > 0
        schemes.forEach({ (scheme) in
            let ret = obj.perform(aSelector, with: scheme)
            result = result && (ret != nil)
        })
        return result
    }
}

extension WKWebView {
    @discardableResult public class func register(schemes: Set<String>) -> Bool {
        guard let str = "cmVnaXN0ZXJTY2hlbWVGb3JDdXN0b21Qcm90b2NvbDo=".base64Decode else {
            assertionFailure(); return false
        }
        // str: "registerSchemeForCustomProtocol:"
        let register = NSSelectorFromString(str)
        return perform_browsing_contextController(aSelector: register, schemes: schemes)
    }

    @discardableResult public class func unregister(schemes: Set<String>) -> Bool {
        guard let str = "dW5yZWdpc3RlclNjaGVtZUZvckN1c3RvbVByb3RvY29sOg==".base64Decode else {
            assertionFailure(); return false
        }
        //str: "unregisterSchemeForCustomProtocol:"
        let unregister = NSSelectorFromString(str)
        return perform_browsing_contextController(aSelector: unregister, schemes: schemes)
    }
}
