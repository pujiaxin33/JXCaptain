//
//  FPSMonitor.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class FPSMonitor: Monitor {
    static let shared = FPSMonitor()
    typealias ValueType = Int
    var valueDidUpdateClosure: ((ValueType) -> Void)?
    var link: CADisplayLink?
    var periodCount: Int = 0
    var periodStartTime: CFTimeInterval = 0


    deinit {
        link?.invalidate()
        link = nil
        valueDidUpdateClosure = nil
    }

    func start() {
        link = CADisplayLink(target: self, selector: #selector(processLink))
        link?.add(to: RunLoop.main, forMode: .common)
    }

    func end() {
        link?.invalidate()
        link = nil
    }

    @objc func processLink() {
        if periodStartTime == 0 {
            periodStartTime = link!.timestamp
            return
        }
        periodCount += 1
        let duration = link!.timestamp - periodStartTime
        if duration < 1 {
            return
        }
        let fps = CFTimeInterval(periodCount)/duration
        valueDidUpdateClosure?(Int(fps))
        periodStartTime = link!.timestamp
        periodCount = 0
    }
}
