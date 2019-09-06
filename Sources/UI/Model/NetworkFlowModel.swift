//
//  NetworkTransaction.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

//@property (nonatomic, copy) NSString *requestId;
struct NetworkFlowModel {
    let requestID: String
    let request: URLRequest
    let response: URLResponse?
    let error: NSError?

    let statusCode: Int?
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval //单位秒

    let requestBodyString: String
    let requestBodySize: String
    let urlString: String?
    let method: String
    let mimeType: String
    let uploadFlow: String
    let downFlow: String
    let durationString: String
    let startDateString: String
    let statusCodeString: String
    let errorString: String?
    let isStatusCodeError: Bool
    let isImageResponseData: Bool
    let isGif: Bool

    init(request: URLRequest, response: URLResponse?, responseData: Data?, error: NSError?, startDate: Date) {
        self.requestID = UUID().uuidString
        self.request = request
        self.response = response
        self.startDate = startDate
        self.error = error

        let defaultString = "Unknown"
        requestBodyString = NetworkManager.jsonString(from: NetworkManager.httpBody(request: request) ?? Data()) ?? defaultString
        if response != nil && responseData != nil {
            mimeType = response!.mimeType ?? defaultString
            downFlow = NetworkManager.flowLengthString(NetworkManager.responseFlowLength(response!, responseData: responseData!))
        }else {
            mimeType = defaultString
            downFlow = defaultString
        }
        isImageResponseData = mimeType.hasPrefix("image/")
        isGif = mimeType.contains("gif")
        errorString = error?.localizedDescription
        urlString = request.url?.absoluteString
        method = request.httpMethod ?? defaultString
        statusCode = (response as? HTTPURLResponse)?.statusCode
        if statusCode != nil {
            statusCodeString = "\(statusCode!) \(HTTPURLResponse.localizedString(forStatusCode: statusCode!))"
            let errorStatusCodes = IndexSet(integersIn: Range.init(NSRange(location: 400, length: 200))!)
            isStatusCodeError = errorStatusCodes.contains(statusCode!)
        }else {
            statusCodeString = defaultString
            isStatusCodeError = false
        }
        endDate = Date()
        duration = endDate.timeIntervalSince(startDate)
        if duration > 1 {
            durationString = String(format: "%.1fs", duration)
        }else {
            durationString = String(format: "%.fms", duration * 1000)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startDateString = dateFormatter.string(from: startDate)
        requestBodySize = NetworkManager.flowLengthString(NetworkManager.httpBody(request: request)?.count ?? 0)
        uploadFlow = NetworkManager.flowLengthString(NetworkManager.requestFlowLength(request))
    }
}
