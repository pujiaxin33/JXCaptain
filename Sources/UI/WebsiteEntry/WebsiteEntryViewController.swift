//
//  WebsiteEntryViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class WebsiteEntryViewController: BaseViewController {
    let soldier: WebsiteEntrySoldier
    var tipsLabel: UILabel!
    var inputTextView: UITextView!
    var confirmButton: UIButton!

    init(soldier: WebsiteEntrySoldier) {
        self.soldier = soldier
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "H5任意门"

        tipsLabel = UILabel()
        tipsLabel.textColor = .lightGray
        tipsLabel.text = "请在下方输入网址："
        view.addSubview(tipsLabel)

        inputTextView = UITextView()
        if soldier.defaultWebsite != nil {
            inputTextView.text = soldier.defaultWebsite
        }else {
            inputTextView.text = "http://"
        }
        inputTextView.font = .systemFont(ofSize: 17)
        inputTextView.keyboardType = .URL
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 1
        view.addSubview(inputTextView)

        confirmButton = UIButton(type: .custom)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.setTitle("点击跳转", for: .normal)
        confirmButton.layer.cornerRadius = 5
        confirmButton.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        confirmButton.addTarget(self, action: #selector(confirmButtonDidClick), for: .touchUpInside)
        view.addSubview(confirmButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        inputTextView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tipsLabel.frame = CGRect(x: 12, y: 12, width: 200, height: 20)
        inputTextView.frame = CGRect(x: 12, y: tipsLabel.frame.maxY + 3, width: view.bounds.size.width - 12*2, height: 200)
        confirmButton.frame = CGRect(x: 12, y: inputTextView.frame.maxY + 10, width: inputTextView.bounds.size.width, height: 50)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextView.endEditing(true)
    }

    @objc func confirmButtonDidClick() {
        guard !inputTextView.text.isEmpty else {
            let alert = UIAlertController(title: nil, message: "网址不能为空！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        inputTextView.endEditing(true)
        if soldier.webDetailControllerClosure == nil {
            navigationController?.pushViewController(WebDetailViewController(website: inputTextView.text), animated: true)
        }else {
            navigationController?.pushViewController(soldier.webDetailControllerClosure!(inputTextView.text), animated: true)
        }
    }
}
