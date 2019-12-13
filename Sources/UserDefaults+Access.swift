//
//  UserDefaults+Access.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/12/13.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

extension UserDefaults {
    var isNetworkObserverSoldierActive: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isANRSoldierActive: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isANRSoldierHasNewEvent: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isCPUSoldierActive: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isMemorySoldierActive: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isFPSSoldierActive: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
    var isCrashSoldierHasNewEvent: Bool {
        set { set(newValue, forKey: #function) }
        get { bool(forKey: #function) }
    }
}
