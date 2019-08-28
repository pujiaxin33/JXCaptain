//
//  ANRPingThread.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public class ANRPingThread: Thread {
    let threshold: Double
    let handler: ((Double)->())?
    private var isApplicationInActive = true
    private let semaphore: DispatchSemaphore
    private var isMainThreadBlocked: Bool = false

    public init(threshold: Double, handler: ((Double)->())?) {
        self.threshold = threshold
        self.handler = handler
        semaphore = DispatchSemaphore(value: 0)
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    override public func main() {
        while !isCancelled {
            if isApplicationInActive {
                isMainThreadBlocked = true
                DispatchQueue.main.async {
                    self.isMainThreadBlocked = false
                    self.semaphore.signal()
                }
                Thread.sleep(forTimeInterval: self.threshold)
                if self.isMainThreadBlocked {
                    handler?(self.threshold)
                }
                _ = semaphore.wait(timeout: .distantFuture)
            }else {
                Thread.sleep(forTimeInterval: self.threshold)
            }
        }
    }

    //MARK: - Private
    @objc private func applicationDidBecomeActive() {
        isApplicationInActive = true
    }

    @objc private func applicationDidEnterBackground() {
        isApplicationInActive = false
    }
}
