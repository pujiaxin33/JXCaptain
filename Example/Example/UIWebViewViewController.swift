//
//  UIWebViewViewController.swift
//  Example
//
//  Created by jiaxin on 2019/9/6.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class UIWebViewViewController: UIViewController {
    var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = UIWebView(frame: CGRect.zero)
        view.addSubview(webView)

        let url = URL(string: "https://www.baidu.com/")!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = view.bounds
    }

}
