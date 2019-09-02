//
//  NetworkFlowDetailTextViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class NetworkFlowDetailTextViewController: BaseViewController {
    let text: String
    var textView: UITextView!

    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textView = UITextView()
        textView.text = text
        textView.font = .systemFont(ofSize: 13)
        textView.isEditable = false
        view.addSubview(textView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyItemDidClick))
    }

    @objc func copyItemDidClick() {
        UIPasteboard.general.string = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textView.frame = view.bounds
    }

}
