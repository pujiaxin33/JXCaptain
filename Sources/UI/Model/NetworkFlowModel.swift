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
    let request: URLRequest
    let response: URLResponse
    let responseData: Data

    let statusCode: Int?
    let startDate: Date?
    let endDate: Date?
    let duration: TimeInterval? //单位秒

    let requestBody: String?
    let responseBody: String?
    let urlString: String?
    let method: String?
    let mineType: String?
    let uploadFlow: String?
    let downFlow: String?
    let durationString: String?


    init(request: URLRequest, response: URLResponse, responseData: Data, startDate: Date) {
        self.request = request
        self.response = response
        self.responseData = responseData
        self.startDate = startDate

        requestBody = NetworkManager.jsonString(from: NetworkManager.httpBody(request: request) ?? Data())
        responseBody = NetworkManager.jsonString(from: responseData)
        urlString = request.url?.absoluteString
        method = request.httpMethod
        statusCode = (response as? HTTPURLResponse)?.statusCode
        mineType = response.mimeType
        endDate = Date()
        duration = endDate!.timeIntervalSince(startDate)
        if duration! > 1 {
            durationString = String(format: "%.1fs", duration!)
        }else {
            durationString = String(format: "%.fms", duration! * 1000)
        }

        uploadFlow = NetworkManager.flowLengthString(NetworkManager.requestFlowLength(request))
        downFlow = NetworkManager.flowLengthString(NetworkManager.responseFlowLength(response, responseData: responseData))
    }


}
