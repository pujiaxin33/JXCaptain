//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXCaptain

class ViewController: UIViewController {
    var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView()
        textView.backgroundColor = .lightGray
        view.addSubview(textView)

        let signal = UserDefaults.standard.value(forKey: "ksignal") as? String
        let uncaught = UserDefaults.standard.value(forKey: "kuncaught") as? String
        textView.text = (signal ?? "signal empty \n") + (uncaught ?? "uncaught empty\n")

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "呼叫队长", style: .plain, target: self, action: #selector(naviRightItemDidClick))
    }

    @objc func naviRightItemDidClick() {
        Captain.default.show()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textView.frame = CGRect(x: 0, y: 100, width: view.bounds.size.width, height: view.bounds.size.height - 100)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let array = [Int]()
        print(array[1])
    }

}

