////
////  DatabaseOperations.swift
////  DYZB
////
////  Created by xiudou on 2017/6/26.
////  Copyright © 2017年 xiudo. All rights reserved.
////
//
//import UIKit
//
//class SQLManager: NSObject {
//
//    /// 单例
//    static let manager : SQLManager = SQLManager()
//    class func shareInstance() -> SQLManager{
//        return manager
//    }
//    
//    ///数据库对象
//    private var dbBase : OpaquePointer? = nil
//    
//    // 创建数据库文件，首先需要一个文件名，然后通过文件名得到地址，再通过地址去创建数据库文件
//    /// 打开数据库
//    func openDB(DBName: String){
//        
//        //1、拿到数据库路径
//        let path = DBName.documentDir()
//        //打印路径，以便拿到数据文件
//        debugLog(path)
//        
//        //2、转化为c字符串
//        let cPath = path.cString(using: String.Encoding.utf8)
//        /*
//         参数一：c字符串，文件路径
//         参数二：OpaquePointer 一个数据库对象的地址
//         
//         注意Open方法的特性：如果指定的文件路径已有对应的数据库文件会直接打开，如果没有则会创建在打开
//         使用Sqlite_OK判断
//         sqlite3_open(cPath, &dbBase)
//         */
//        /*
//         #define SQLITE_OK           0   /* Successful result */
//         */
//        if sqlite3_open(cPath, &dbBase) != SQLITE_OK{
//            print("数据库打开失败")
//            return
//        }
//        
//        createTab(tableName: DBName)
//    }
//    
//    func execSQL(sql : String) -> Bool {
//        // 1、先把OC字符串转化为C字符串
//        let cSQL = sql.cString(using: String.Encoding.utf8)
//        
//        // 2、执行语句
//        /// 在SQLite3中，除了查询以外（创建/删除/更新）都是用同一个函数
//        /*
//         1. 已经打开的数据库对象
//         2. 需要执行的SQL语句，c字符串
//         3. 执行SQL语句之后的回调，一般写nil
//         4. 是第三个参数的第一个参数，一般传nil
//         5. 错误信息，一般传nil
//         
//         SQLITE_API int SQLITE_STDCALL sqlite3_exec(
//         sqlite3*,                                  /* An open database */
//         const char *sql,                           /* SQL to be evaluated */
//         int (*callback)(void*,int,char**,char**),  /* Callback function */
//         void *,                                    /* 1st argument to callback */
//         char **errmsg                              /* Error msg written here */
//         );
//         */
//        
//        if sqlite3_exec(dbBase, cSQL, nil, nil, nil) != SQLITE_OK {
//            return false
//        }
//        return true
//    }
//    
//    @discardableResult func createTab(tableName : String?) -> Bool{
//        
//        assert(tableName != nil, "必须传入表名称")
//        
//        //1、编写SQL语句
//        let sql = "CREATE TABLE IF NOT EXISTS table_\(tableName!) (id integer PRIMARY KEY);"
//        print(sql)
//        
//        let flag = execSQL(sql: sql)
//        if !flag {
//            print("创建表失败")
//        }
//        return flag
//    }
//    //这里要注明一下，为什么SQL语句是这样子组成的，看了打印信息就明白了
////    CREATE TABLE IF NOT EXISTS T_Person
////    (
////    id INTEGER PRIMARY KEY AUTOINCREMENT,
////    name TEXT NOT NULL,
////    age INTEGER, 
////    money REAL DEFAULT 100.0
////    );
//    
//    /// 插入
////    func insertSQL() -> Bool{
////        //断言
////        assert(name != nil, "姓名不能为空")
////    }
//}
