//
//  WebDetailViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import WebKit

class WebDetailViewController: BaseViewController, WKNavigationDelegate {
    let website: String
    let webView: WKWebView
    let progressLine: CALayer

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    init(website: String) {
        if website.hasPrefix("http://") || website.hasPrefix("https://") {
            self.website = website
        }else {
            self.website = "https://" + website
        }
        webView = WKWebView(frame: CGRect.zero)
        progressLine = CALayer()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)

        progressLine.backgroundColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        view.layer.addSublayer(progressLine)

        guard let url = URL(string: website) else {
            let alert = UIAlertController(title: nil, message: "网址无效！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    override func viewDidLayoutSubviews() {
        webView.frame = view.bounds
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 0 || webView.estimatedProgress == 1 {
                progressLine.frame = CGRect.zero
                progressLine.isHidden = true
            }else {
                progressLine.isHidden = false
            }
            progressLine.frame = CGRect(x: 0, y: 0, width: CGFloat(webView.estimatedProgress)*view.bounds.size.width, height: 5)
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("JXCaptain H5任意门 didFail with error:\(error.localizedDescription)")
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (result, error) in
            if let title = result as? String {
                self.title = title
            }
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
