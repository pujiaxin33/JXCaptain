//
//  JXDatabaseConnector.swift
//  JXCaptain
//
//  Created by jiaxin on 2019/9/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import SQLite3

public class JXDatabaseConnector {
    let databasePath: String
    var db: OpaquePointer?

    public init(path: String) {
        databasePath = path
    }

    @discardableResult
    public func open() -> Bool {
        if db != nil {
            return true
        }
        let resultCode = sqlite3_open(databasePath, &db)
        if resultCode == SQLITE_OK {
            return true
        }
        print("open \(databasePath) error:\(resultCode)")
        return false
    }

    @discardableResult
    func close() -> Bool {
        guard let db = db else {
            return true
        }
        var resultCode: Int32 = 0
        var retry = false
        var triedFinalizingOpenStatements = false
        repeat {
            retry = false
            resultCode = sqlite3_close(db)
            if SQLITE_BUSY == resultCode || SQLITE_LOCKED == resultCode {
                if !triedFinalizingOpenStatements {
                    triedFinalizingOpenStatements = true
                    var pStmt: OpaquePointer?
                    pStmt = sqlite3_next_stmt(db, nil)
                    while pStmt != nil {
                        sqlite3_finalize(pStmt)
                        retry = true
                        pStmt = sqlite3_next_stmt(db, nil)
                    }
                }else if SQLITE_OK != resultCode {
                    print("close \(databasePath) error:\(resultCode)")
                }
            }
        } while retry
        self.db = nil
        return true
    }

    public func allTables() -> [String] {
        let queryResult = executeQuery(sql: "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
        let result = queryResult.compactMap { (dict) -> String? in
            return dict["name"] as? String
        }
        return result
    }

    public func allColumns(with tableName: String) -> [String] {
        let queryResult = executeQuery(sql: "PRAGMA table_info('\(tableName)')")
        let result = queryResult.compactMap { (dict) -> String? in
            return dict["name"] as? String
        }
        return result
    }

    public func allData(with tableName: String) -> [[String:Any]] {
        return executeQuery(sql: "SELECT * FROM \(tableName)")
    }

    func executeQuery(sql: String) -> [[String:Any]] {
        open()
        var resultArray = [[String:Any]]()
        var pstmt: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &pstmt, nil) == SQLITE_OK, pstmt != nil {
            while sqlite3_step(pstmt) == SQLITE_ROW {
                let dataNumber = sqlite3_data_count(pstmt)
                guard dataNumber > 0 else {
                    continue
                }
                var dict = [String:Any].init(minimumCapacity: Int(dataNumber))
                let columnCount = sqlite3_column_count(pstmt)
                for index in 0..<columnCount {
                    let name = String(cString: sqlite3_column_name(pstmt, index))
                    let value = objectForColumnIndex(Int32(index), stmt: pstmt!)
                    if value != nil {
                        dict[name] = value!
                    }
                }
                resultArray.append(dict)
            }
        }
        close()
        return resultArray
    }

    func objectForColumnIndex(_ columnIndex: Int32, stmt: OpaquePointer) -> Any? {
        let type = sqlite3_column_type(stmt, columnIndex)
        var resultValue: Any?
        if type == SQLITE_INTEGER {
            resultValue = sqlite3_column_int64(stmt, columnIndex)
        }else if type == SQLITE_FLOAT {
            resultValue = sqlite3_column_double(stmt, columnIndex)
        }else if type == SQLITE_BLOB {
            resultValue = dataForColumnIndex(columnIndex, stmt: stmt)
        }else {
            resultValue = stringForColumnIndex(columnIndex, stmt: stmt)
        }
        return resultValue
    }

    func dataForColumnIndex(_ columnIndex: Int32, stmt: OpaquePointer) -> Data? {
        if sqlite3_column_type(stmt, columnIndex) == SQLITE_NULL || columnIndex < 0 {
            return nil
        }
        let dataBuffer = sqlite3_column_blob(stmt, columnIndex)
        let dataSize = sqlite3_column_bytes(stmt, columnIndex)
        if dataBuffer == nil {
            return nil
        }
        return Data(bytes: dataBuffer!, count: Int(dataSize))
    }

    func stringForColumnIndex(_ columnIndex: Int32, stmt: OpaquePointer) -> String? {
        if sqlite3_column_type(stmt, columnIndex) == SQLITE_NULL || columnIndex < 0 {
            return nil
        }
        let cString = sqlite3_column_text(stmt, columnIndex)
        if cString == nil {
            return nil
        }
        return String(cString: cString!)
    }
}
