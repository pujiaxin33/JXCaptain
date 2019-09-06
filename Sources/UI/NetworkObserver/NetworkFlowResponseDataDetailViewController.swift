//
//  NetworkFlowDetailTextViewController.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class NetworkFlowResponseDataDetailViewController: BaseViewController, UIScrollViewDelegate {
    let flowModel: NetworkFlowModel
    let cellType: NetworkFlowDetailCellType
    var text: String?
    var image: UIImage?
    var mediaURL: URL?
    var previewImageView: UIImageView?
    var previewScrollView: UIScrollView?
    var previewTextView: UITextView?
    var previewPlayerController: AVPlayerViewController?

    init(flowModel: NetworkFlowModel, cellType: NetworkFlowDetailCellType) {
        self.flowModel = flowModel
        self.cellType = cellType
        self.text = nil
        self.image = nil
        self.mediaURL = nil
        if cellType == .requestBody {
            self.text = flowModel.requestBodyString
        }else if cellType == .responseBody {
            if flowModel.isImageResponseData {
                self.image = NetworkManager.responseImage(requestID: flowModel.requestID)
            }else if flowModel.isVedio || flowModel.isAudio {
                let mediaData = NetworkManager.responseData(requestID: flowModel.requestID)
                let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                let tempMediaURL = tempDirectoryURL.appendingPathComponent(flowModel.mediaFileName)
                if (try? mediaData?.write(to: tempMediaURL)) != nil {
                    self.mediaURL = tempMediaURL
                }
            }else {
                self.text =  NetworkManager.responseJSON(requestID: flowModel.requestID)
            }
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if cellType == .requestBody {
            title = "Request"
        }else {
            title = "Response"
        }
        view.backgroundColor = .white

        if image != nil {
            previewScrollView = UIScrollView()
            previewScrollView?.delegate = self
            previewScrollView?.minimumZoomScale = 1
            var imageWidthScale: CGFloat = 1
            if view.bounds.size.width > 0 {
                imageWidthScale = (image?.size.width ?? 0)/view.bounds.size.width
            }
            previewScrollView?.maximumZoomScale = max(2, imageWidthScale)
            view.addSubview(previewScrollView!)

            previewImageView = UIImageView()
            if flowModel.isGif {
                previewImageView?.animationImages = NetworkManager.responseImages(requestID: flowModel.requestID)
                previewImageView?.startAnimating()
            }else {
                previewImageView?.image = image
            }
            previewImageView?.contentMode = .scaleAspectFit
            previewScrollView?.addSubview(previewImageView!)

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyItemDidClick))
        }else if text != nil {
           initTextView(with: text!)

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(copyItemDidClick))
        }else if mediaURL != nil {
            previewPlayerController = AVPlayerViewController()
            previewPlayerController?.player = AVPlayer(url: mediaURL!)
            addChild(previewPlayerController!)
            view.addSubview(previewPlayerController!.view)
        }
    }

    @objc func copyItemDidClick() {
        if text != nil {
            UIPasteboard.general.string = text
        }else if image != nil {
            UIPasteboard.general.image = image
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewTextView?.frame = view.bounds
        previewScrollView?.frame = view.bounds
        previewScrollView?.contentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height)
        var imageWidth = previewImageView?.image?.size.width ?? 0
        var imageHeight = previewImageView?.image?.size.width ?? 0
        if previewImageView?.animationImages?.isEmpty == false {
            imageWidth = previewImageView?.animationImages?.first?.size.width ?? 0
            imageHeight = previewImageView?.animationImages?.first?.size.height ?? 0
        }
        let imageViewWidth = min(imageWidth, view.bounds.size.width)
        let imageViewHeight = min(imageHeight, view.bounds.size.height)
        previewImageView?.bounds = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        previewImageView?.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        previewPlayerController?.view.frame = view.bounds
    }

    func initTextView(with text: String) {
        previewTextView = UITextView()
        previewTextView?.isEditable = false
        previewTextView?.font = .systemFont(ofSize: 12)
        previewTextView?.textColor = .black
        previewTextView?.backgroundColor = .white
        previewTextView?.isScrollEnabled = true
        previewTextView?.textAlignment = .left
        previewTextView?.text = text
        view.addSubview(previewTextView!)
    }

    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        if scrollView.contentSize.width > view.bounds.size.width {
            center.x = scrollView.contentSize.width/2
        }
        if scrollView.contentSize.height > view.bounds.size.height {
            center.y = scrollView.contentSize.height/2
        }
        previewImageView?.center = center
    }

}
