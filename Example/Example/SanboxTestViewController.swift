//
//  SanboxTestViewController.swift
//  Example
//
//  Created by jiaxin on 2019/8/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

class SanboxTestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "沙盒测试"
        tableView.tableFooterView = UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let documentURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return
        }
        var toastText = "添加成功"
        if indexPath.row == 0 {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone.current
            let dateString = formatter.string(from: Date())
            let fileURL = documentURL.appendingPathComponent("\(dateString).txt")
            _ = try? dateString.write(to: fileURL, atomically: true, encoding: .utf8)
            do {
                try dateString.write(to: fileURL, atomically: true, encoding: .utf8)
            }catch (let error) {
                toastText = error.localizedDescription
            }
        }else if indexPath.row == 1 {
            let image = UIImage(named: "lufei.jpg")
            let imageURL = documentURL.appendingPathComponent("lufei.jpg")
            let result = FileManager.default.createFile(atPath: imageURL.path, contents: image?.jpegData(compressionQuality: 1), attributes: nil)
            if !result {
                toastText = "添加失败"
            }
        }else if indexPath.row == 2 {
            let image = UIImage(named: "icon_shield.png")
            let imageURL = documentURL.appendingPathComponent("icon_shield.png")
            let result = FileManager.default.createFile(atPath: imageURL.path, contents: image?.jpegData(compressionQuality: 1), attributes: nil)
            if !result {
                toastText = "添加失败"
            }
        }else if indexPath.row == 3 {
            let url = URL(string: "http://pic38.nipic.com/20140217/14150008_155520585000_2.gif")!
            let request = URLRequest(url: url)
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if data != nil {
                    if let documentURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                        let imageURL = documentURL.appendingPathComponent("lufei.gif")
                        let result = FileManager.default.createFile(atPath: imageURL.path, contents: data, attributes: nil)
                        if !result {
                            toastText = "添加失败"
                        }
                    }
                }
                semaphore.signal()
            }
            task.resume()
            let waitResult = semaphore.wait(timeout: .distantFuture)
            print(waitResult)
        }else if indexPath.row == 4 {
            toastText = "正在下载"
            let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if data != nil {
                    if let documentURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                        let imageURL = documentURL.appendingPathComponent("duck.mp4")
                        let result = FileManager.default.createFile(atPath: imageURL.path, contents: data, attributes: nil)
                        DispatchQueue.main.async {
                            if !result {
                                self.showText("添加视频失败")
                            }else {
                                self.showText("添加视频成功")
                            }
                        }
                    }
                }
            }
            task.resume()
        }
        showText(toastText)
    }

    func showText(_ text: String) {
        if presentedViewController != nil {
            dismiss(animated: false, completion: nil)
        }
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
