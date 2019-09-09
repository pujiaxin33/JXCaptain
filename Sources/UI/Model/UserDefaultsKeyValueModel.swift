//
//  UserDefaultsKeyValueModel.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/9.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

enum UserDefaultsVaule {
    case string(String)
    case number(NSNumber)
    case date(Date)
    case data(Data)
    case array([Any])
    case dictionary([String:Any])
}

struct UserDefaultsKeyValueModel {
    let key: String
    let value: UserDefaultsVaule

    init(key: String, value: Any, userDefaults: UserDefaults) {
        self.key = key
        if let date = userDefaults.object(forKey: key) as? Date {
            self.value = .date(date)
        }else if let array = userDefaults.array(forKey: key) {
            self.value = .array(array)
        }else if let dict = userDefaults.dictionary(forKey: key) {
            self.value = .dictionary(dict)
        }else if let string = userDefaults.string(forKey: key) {
            self.value = .string(string)
        }else if let data = userDefaults.data(forKey: key) {
            self.value = .data(data)
        }else if let number = userDefaults.object(forKey: key) as? NSNumber {
            self.value = .number(number)
        }else {
            self.value = .string("unknown")
        }
    }

    func valueDescription() -> String {
        switch value {
        case .date(let date):
            return date.description
        case .array(let array):
            return array.description
        case .dictionary(let dict):
            return dict.description
        case .string(let string):
            return string
        case .data(let data):
            return data.description
        case .number(let number):
            return number.description
        }
    }
}
