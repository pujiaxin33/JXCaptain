//
//  NetworkManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/29.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class NetworkManager {
    static func httpBody(request: URLRequest) -> Data? {
        if request.httpBody != nil {
            return request.httpBody
        }else if request.httpMethod == "POST" {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
            let stream = request.httpBodyStream
            stream?.open()
            var data = Data()
            while stream?.hasBytesAvailable == true {
                let len = stream?.read(buffer, maxLength: 1024) ?? 0
                if len > 0 && stream?.streamError == nil {
                    data.append(buffer, count: len)
                }
            }
            stream?.close()
            buffer.deallocate()
            return data
        }
        return nil
    }

    static func jsonString(from data: Data) -> String? {
        if data.isEmpty {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return String(data: data, encoding: .utf8)
        }
        if JSONSerialization.isValidJSONObject(object) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
                let string = String(data: jsonData, encoding: .utf8)
                return string?.replacingOccurrences(of: "\\/", with: "/")
            }
        }
        return nil
    }

    static func flowLengthString(_ length: Int) -> String {
        if length < 1024 {
            return String(format: "%dBytes", length)
        }else if length < 1024 * 1024 {
            return String(format: "%.1fKB", Double(length)/1204)
        }else {
            return String(format: "%.1fMB", Double(length)/1204/1024)
        }
    }

    static func requestFlowLength(_ request: URLRequest) -> Int {
        var headerFields = [String : String]()
        if request.allHTTPHeaderFields != nil {
            headerFields.merge(request.allHTTPHeaderFields!) { (current, _) -> String in
                return current
            }
        }
        if let url = request.url {
            let cookies = HTTPCookieStorage.shared.cookies(for: url)
            if cookies?.isEmpty == false {
                let cookiesHeader = HTTPCookie.requestHeaderFields(with: cookies!)
                headerFields.merge(cookiesHeader) { (current, _) -> String in
                    return current
                }
            }
        }
        let headersLength = headerFieldsLength(headerFields)
        let bodyLength = httpBody(request: request)?.count ?? 0
        return headersLength + bodyLength
    }

    static func responseFlowLength(_ response: URLResponse, responseData: Data) -> Int {
        return responseData.count
        //FIXME: https://stackoverflow.com/questions/39256489/how-to-bridge-a-long-long-c-macro-to-swift
        /*
        guard let httpResponse = response as? HTTPURLResponse else {
            return responseData.count
        }
        let headersLength = headerFieldsLength(httpResponse.allHeaderFields)
        var contentLength: Int = 0
        if httpResponse.expectedContentLength != NSURLResponseUnknownLength {
            contentLength = httpResponse.expectedContentLength
        }else {
            contentLength = responseData.count
        }
        return headersLength + contentLength
 */
    }

    static func responseData(requestID: String) -> Data? {
        return NetworkObserverSoldier.shared.cache.object(forKey: requestID as AnyObject) as? Data
    }

    static func responseImage(requestID: String) -> UIImage? {
        let responseData = NetworkObserverSoldier.shared.cache.object(forKey: requestID as AnyObject) as? Data
        if responseData != nil {
            return UIImage(data: responseData!, scale: UIScreen.main.scale)
        }
        return nil
    }

    static func responseImages(requestID: String) -> [UIImage]? {
        let responseData = NetworkObserverSoldier.shared.cache.object(forKey: requestID as AnyObject) as? Data
        if responseData != nil, let imageSource = CGImageSourceCreateWithData(responseData! as CFData, nil) {
            let imagesCount = CGImageSourceGetCount(imageSource)
            var images = [UIImage]()
            for index in 0..<imagesCount {
                if let cgimage = CGImageSourceCreateImageAtIndex(imageSource, index, nil) {
                    images.append(UIImage(cgImage: cgimage))
                }
            }
            return images
        }
        return nil
    }

    static func responseJSON(requestID: String) -> String? {
        let responseData = NetworkObserverSoldier.shared.cache.object(forKey: requestID as AnyObject) as? Data
        if responseData != nil {
            return NetworkManager.jsonString(from: responseData!)
        }
        return nil
    }

    //MARK: - Private

    private static func headerFieldsLength(_ headerFields: Any) -> Int {
        let data = try? JSONSerialization.data(withJSONObject: headerFields, options: .prettyPrinted)
        return data?.count ?? 0
    }
}
