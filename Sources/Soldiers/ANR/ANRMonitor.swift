//
//  ANRMonitor.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class ANRMonitor: Monitor {
    typealias ValueType = Double
    var valueDidUpdateClosure: ((ValueType) -> Void)?
    var threshold: Double = 1
    private var thread: ANRPingThread?

    deinit {
        valueDidUpdateClosure = nil
        end()
    }

    func start() {
        end()
        thread = ANRPingThread(threshold: threshold, handler: {[weak self] (value) in
            self?.valueDidUpdateClosure?(value)
        })
        thread?.start()
    }

    func end() {
        thread?.cancel()
        thread = nil
    }
}
