//
//  UserDefaultsKeyValueDetailViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/9.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class UserDefaultsKeyValueDetailViewController: BaseViewController {
    let defaults: UserDefaults
    var keyValueModel: UserDefaultsKeyValueModel
    var tipsLabel: UILabel!
    var inputTextView: UITextView!

    init(defaults: UserDefaults, keyValueModel: UserDefaultsKeyValueModel) {
        self.defaults = defaults
        self.keyValueModel = keyValueModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Value"

        let copy = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyValue))
        let update = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateValue))

        tipsLabel = UILabel()
        tipsLabel.text = "Key:\(keyValueModel.key)"
        view.addSubview(tipsLabel)

        inputTextView = UITextView()
        inputTextView.font = .systemFont(ofSize: 17)
        inputTextView.keyboardType = .URL
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.text = keyValueModel.valueDescription()
        view.addSubview(inputTextView)

        inputTextView.isEditable = true
        navigationItem.rightBarButtonItems = [update, copy]
        switch keyValueModel.value {
        case .string(_):
            inputTextView.keyboardType = .default
        case .number(_):
            inputTextView.keyboardType = .numbersAndPunctuation
        default:
            inputTextView.isEditable = false
            navigationItem.rightBarButtonItems = [copy]
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tipsLabel.frame = CGRect(x: 12, y: 12, width: view.bounds.size.width - 12*2, height: 20)
        inputTextView.frame = CGRect(x: 12, y: tipsLabel.frame.maxY + 3, width: view.bounds.size.width - 12*2, height: 200)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextView.endEditing(true)
    }

    @objc func copyValue() {
        UIPasteboard.general.string = keyValueModel.valueDescription()
    }

    @objc func updateValue() {
        if inputTextView.text.isEmpty {
            defaults.setValue(nil, forKey: keyValueModel.key)
            return
        }
        guard let newValueText = inputTextView.text else {
            return
        }
        defaults.set(newValueText, forKey: keyValueModel.key)
        if let newValue = defaults.value(forKey: keyValueModel.key) {
            keyValueModel = UserDefaultsKeyValueModel(key: keyValueModel.key, value: newValue, userDefaults: defaults)
            inputTextView.text = keyValueModel.valueDescription()
        }else {
            inputTextView.text = nil
        }
    }
}
