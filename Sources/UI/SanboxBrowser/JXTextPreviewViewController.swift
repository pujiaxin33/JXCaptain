//
//  JXTextPreviewViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/10/8.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class JXTextPreviewViewController: UIViewController {
    let text: String
    var textView: UITextView!

    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 12)
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.isScrollEnabled = true
        textView.textAlignment = .left
        textView.text = text
        view.addSubview(textView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(didNaviCopyItemClick))
    }

    @objc func didNaviCopyItemClick() {
        UIPasteboard.general.string = text
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let margin: CGFloat = 12
        textView.frame = view.bounds.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
    }
}
