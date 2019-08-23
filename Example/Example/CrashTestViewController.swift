//
//  CrashTestViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class CrashTestViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Crash测试"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let ocArray = NSArray()
            print(ocArray[1])
        }else if indexPath.row == 1 {
            let someVaule: Int? = nil
            print(someVaule!)
        }
    }
}
