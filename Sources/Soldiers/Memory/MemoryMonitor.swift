//
//  MemoryMonitor.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import MachO

class MemoryMonitor: Monitor {
    static let shared = MemoryMonitor()
    typealias ValueType = Double
    var valueDidUpdateClosure: ((ValueType) -> Void)?
    var link: CADisplayLink?


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
        valueDidUpdateClosure?(memory())
    }

    private func memory() -> Double {
        var vmInfo = task_vm_info_data_t()
        let TASK_VM_INFO_COUNT = MemoryLayout<task_vm_info>.stride/MemoryLayout<natural_t>.stride
        var count = mach_msg_type_number_t(TASK_VM_INFO_COUNT)
        let kerr = withUnsafeMutablePointer(to: &vmInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        if kerr == KERN_SUCCESS {
            return Double(vmInfo.phys_footprint/1024/1024)
        }else {
            return -1
        }
    }
}
