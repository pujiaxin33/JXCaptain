//
//  CrashFileManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class CrashFileManager {
    static func saveCrashInfo(_ crashInfo: String, crashTypeName: String) {
        guard !crashInfo.isEmpty else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        guard let fileURL = crashDirectory()?.appendingPathComponent("\(crashTypeName)-\(dateString).txt") else {
            return
        }
        do {
            try crashInfo.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch(let error) {
            print("write crashInfo error:\(error.localizedDescription)")
        }
    }

    static func crashDirectory() -> URL? {
        let fileManager = FileManager.default
        guard let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let directoryURL = cacheURL.appendingPathComponent("Crash", isDirectory: true)
        if !fileManager.fileExists(atPath: directoryURL.path) {
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            }catch (let error){
                print("fileManager create crash directory error:\(error.localizedDescription)")
                return nil
            }
        }
        return directoryURL
    }

    static func allCrashFiles() -> [SanboxModel] {
        guard let targetDirectory = crashDirectory() else {
            return [SanboxModel]()
        }
        let fileManager = FileManager.default
        guard let fileURLs = try? fileManager.contentsOfDirectory(at: targetDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            return [SanboxModel]()
        }
        let sortedFileURLs = fileURLs.sorted { (first, second) -> Bool in
            let firstAttributes = try? fileManager.attributesOfItem(atPath: first.path)
            let secondAttributes = try? fileManager.attributesOfItem(atPath: second.path)
            let firstDate = firstAttributes?[FileAttributeKey.creationDate] as? Date
            let secondDate = secondAttributes?[FileAttributeKey.creationDate] as? Date
            if firstDate != nil && secondDate != nil {
                return firstDate! > secondDate!
            }
            return false
        }
        var sanboxInfos = [SanboxModel]()
        for fileURL in sortedFileURLs {
            let model = SanboxModel(fileURL: fileURL, name: fileURL.lastPathComponent)
            sanboxInfos.append(model)
        }
        return sanboxInfos
    }

    static func deleteAllFiles() {
        guard let targetDirectory = crashDirectory() else {
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: targetDirectory)
        }catch (let error) {
            print("deleteAllFiles error:\(error.localizedDescription)")
        }
    }
}
