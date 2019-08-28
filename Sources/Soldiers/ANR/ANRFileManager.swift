//
//  ANRFileManager.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/8/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class ANRFileManager {
    static func saveInfo(_ info: String) {
        guard !info.isEmpty else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        guard let fileURL = directoryURL()?.appendingPathComponent("\(dateString).txt") else {
            return
        }
        do {
            try info.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch(let error) {
            print("ANRFileManager write info error:\(error.localizedDescription)")
        }
    }

    static func directoryURL() -> URL? {
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

    static func allFiles() -> [SanboxModel] {
        guard let targetDirectory = directoryURL() else {
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
        guard let targetDirectory = directoryURL() else {
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: targetDirectory)
        }catch (let error) {
            print("ANRFileManager deleteAllFiles error:\(error.localizedDescription)")
        }
    }
}
