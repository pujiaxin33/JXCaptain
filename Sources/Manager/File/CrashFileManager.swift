//
//  CrashFileManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public class CrashFileManager: SoldierFileManager {
    public static func crashDirectory() -> URL? {
        let fileManager = FileManager.default
        guard let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let directoryURL = cacheURL.appendingPathComponent("Crash", isDirectory: true)
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }catch (let error){
                print("CrashFileManager create crash directory error:\(error.localizedDescription)")
                return nil
            }
        }
        return directoryURL
    }
}
