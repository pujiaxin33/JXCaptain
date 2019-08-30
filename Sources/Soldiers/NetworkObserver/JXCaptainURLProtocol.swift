//
//  JXCaptainURLProtocol.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

private let KJXCaptainURLProtocolIdentifier = "KJXCaptainURLProtocolIdentifier"

class JXCaptainURLProtocol: URLProtocol, URLSessionDataDelegate {
    var session: URLSession!
    var sessionTask: URLSessionTask?
    var receivedData: Data?
    var receivedResponse: URLResponse?
    var startDate: Date?

    override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: KJXCaptainURLProtocolIdentifier, in: request) != nil {
            return false
        }
        if request.url?.scheme != "http" && request.url?.scheme != "https" {
            return false
        }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let mutableRequest = ((request as NSURLRequest).mutableCopy() as? NSMutableURLRequest) else {
            return request
        }
        URLProtocol.setProperty("JXCaptain", forKey: KJXCaptainURLProtocolIdentifier, in: mutableRequest)
        return mutableRequest as URLRequest
    }

    override func startLoading() {
        startDate = Date()
        sessionTask = session.dataTask(with: request)
        sessionTask?.resume()
    }

    override func stopLoading() {
        sessionTask?.cancel()
        sessionTask = nil
        receivedData = nil
        receivedResponse = nil
    }

    func recordRequest() {
        guard let receivedResponse = receivedResponse, let receivedData = receivedData, let startDate = startDate else {
            return
        }
        Captain.default.networkSoldier()?.recordRequest(request: request, response: receivedResponse, responseData: receivedData, startDate: startDate)
    }

    //MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        receivedData = Data()
        receivedResponse = response
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData?.append(data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let localError = error as NSError?, localError.code != NSURLErrorCancelled {
            client?.urlProtocol(self, didFailWithError: error!)
        }else {
            recordRequest()
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}

extension URLSession {

    static let swizzleInit: Void = {
        let originalSelector = Selector(("initWithConfiguration:delegate:delegateQueue:"))
        let swizzledSelector = Selector(("initWithCaptainConfiguration:delegate:delegateQueue:"))
        let originalMethod = class_getInstanceMethod(URLSession.self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(URLSession.self, swizzledSelector)
        guard originalMethod != nil, swizzledMethod != nil else {
            return
        }
        let didAddMethod = class_addMethod(URLSession.self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        if didAddMethod {
            class_replaceMethod(URLSession.self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
    }()

    @objc convenience init(captainConfiguration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue queue: OperationQueue?) {
        self.init(captainConfiguration: captainConfiguration, delegate: delegate, delegateQueue: queue)

        let result = captainConfiguration.protocolClasses?.contains(where: { (type) -> Bool in
            if type == JXCaptainURLProtocol.self {
                return true
            }else {
                return false
            }
        })
        if result != true {
            var protocols = captainConfiguration.protocolClasses
            protocols?.append(JXCaptainURLProtocol.self)
            captainConfiguration.protocolClasses = protocols
        }
    }
}
