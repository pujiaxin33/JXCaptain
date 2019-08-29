//
//  ANRFileManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class ANRFileManager: SoldierFileManager {
    public static func directoryURL() -> URL? {
        let fileManager = FileManager.default
        guard let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let tempDirectoryURL = cacheURL.appendingPathComponent("ANR", isDirectory: true)
        if !fileManager.fileExists(atPath: tempDirectoryURL.path) {
            do {
                try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            }catch (let error){
                print("ANRFileManager create ANR directory error:\(error.localizedDescription)")
                return nil
            }
        }
        return tempDirectoryURL
    }
}
