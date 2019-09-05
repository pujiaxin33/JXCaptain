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
    var receivedError: Error?

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
        startDate = nil
        receivedError = nil
    }

    func recordRequest() {
        guard let receivedResponse = receivedResponse, let receivedData = receivedData, let startDate = startDate else {
            return
        }
        NetworkObserverSoldier.shared.recordRequest(request: request, response: receivedResponse, responseData: receivedData, error: receivedError as NSError?, startDate: startDate)
    }

    //MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        guard let redirectRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        // The new request was copied from our old request, so it has our magic property.  We actually
        // have to remove that so that, when the client starts the new request, we see it.  If we
        // don't do this then we never see the new request and thus don't get a chance to change
        // its caching behaviour.
        //
        // We also cancel our current connection because the client is going to start a new request for
        // us anyway.
        URLProtocol.removeProperty(forKey: KJXCaptainURLProtocolIdentifier, in: redirectRequest)
        // Tell the client about the redirect.
        client?.urlProtocol(self, wasRedirectedTo: redirectRequest as URLRequest, redirectResponse: response)
        // Stop our load.  The CFNetwork infrastructure will create a new NSURLProtocol instance to run
        // the load of the redirect.

        // The following ends up calling -URLSession:task:didCompleteWithError: with NSURLErrorDomain / NSURLErrorCancelled,
        // which specificallys traps and ignores the error.
        sessionTask?.cancel()
        let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        receivedError = error
        client?.urlProtocol(self, didFailWithError: error)
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        client?.urlProtocol(self, didReceive: URLAuthenticationChallenge(authenticationChallenge: challenge, sender: JXCaptainURLSessionChallengeSender(completionHandler: completionHandler)))
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        receivedData = Data()
        receivedResponse = response
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(proposedResponse)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData?.append(data)
        client?.urlProtocol(self, didLoad: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            recordRequest()
            client?.urlProtocolDidFinishLoading(self)
        }else if let localError = error as NSError? {
            receivedError = error
            if localError.domain == NSURLErrorDomain && localError.code == NSURLErrorCancelled {
                // Do nothing.  This happens in two cases:
                //
                // o during a redirect, in which case the redirect code has already told the client about
                //   the failure
                //
                // o if the request is cancelled by a call to -stopLoading, in which case the client doesn't
                //   want to know about the failure
            }else {
                client?.urlProtocol(self, didFailWithError: error!)
            }
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
            protocols?.insert(JXCaptainURLProtocol.self, at: 0)
            captainConfiguration.protocolClasses = protocols
        }
    }
}

class JXCaptainURLSessionChallengeSender: NSObject, URLAuthenticationChallengeSender {
    let completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Void

    init(completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        self.completionHandler = completionHandler
        super.init()
    }

    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        completionHandler(.useCredential, credential)
    }

    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        completionHandler(.useCredential, nil)
    }

    func cancel(_ challenge: URLAuthenticationChallenge) {
        completionHandler(.cancelAuthenticationChallenge, nil)
    }

    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        completionHandler(.performDefaultHandling, nil)
    }

    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        completionHandler(.rejectProtectionSpace, nil)
    }
}
