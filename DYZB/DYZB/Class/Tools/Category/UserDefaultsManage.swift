//
//  userDefaultsManage.swift
//  DYZB
//
//  Created by xiudou on 2017/6/28.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class UserDefaultsManage: NSObject {
    
    /// 单例
    static let userDefaultsManage : UserDefaultsManage = UserDefaultsManage()
    class func shareInstance() -> UserDefaultsManage{
        return userDefaultsManage
    }
    
    // 存储数组
    func addArrayDatas(_ key : String, titleArray : [String]){
        
        if inquireDatasForKey(key) {
            userDefaults.set(titleArray, forKey: key)
            userDefaults.synchronize()
        }else{
            
            print("存储失败")
        }
    }
    
    // 添加某个对象
    func addString(_ key : String, _ addString : String, index : Int = 0)->[String]?{
            
//            guard var stringArray = userDefaults.array(forKey: key) as? [String] else {
//                print("stringArray - 添加失败")
//                return nil
//            }
            
            let stringArray = userDefaults.array(forKey: key)
            if stringArray == nil {
                var stringArray : [String] = [String]()
                stringArray.append(addString)
                userDefaults.set(stringArray, forKey: historyKey)
                userDefaults.synchronize()
                return stringArray
            }else{
                guard var stringMutableArray  = stringArray as? [String] else { return nil }
                stringMutableArray.insert(addString, at: index)
                userDefaults.set(stringMutableArray, forKey: key)
                userDefaults.synchronize()
                return stringMutableArray
            }
   
        
    }
    
    // 删除某个对象
    func delString(_ key : String, _ delString : String)->[String]?{
        if inquireDatasForKey(key) {
            
            guard var stringArray = userDefaults.array(forKey: key) as? [String] else {
                print("stringArray - 删除失败")
                return nil
                
            }
            
            guard let delIndex = stringArray.index(of: delString) else {
                
                print("delIndex- 删除失败")
                return nil
                
            }
            stringArray.remove(at: delIndex)
            userDefaults.set(stringArray, forKey: key)
            userDefaults.synchronize()
            return stringArray
        }else{
            print("error - 删除失败")
            return nil
        }
        
    }
    
    // 点击缓存中的对象,吧此对象排在第一个位置,如果已经是第一个位置,则不做处理
    func switchStringToFirstIndex(_ key : String, _ switchString : String)->[String]?{
        
        if inquireDatasForKey(key) {
            var stringArray = userDefaults.array(forKey: key) as! [String]
            // 如果找到 则调整index
            if let switchIndex = stringArray.index(of: switchString){
                if switchIndex != 0{
                    stringArray.remove(at: switchIndex)
                    stringArray.insert(switchString, at: 0)
                    userDefaults.set(stringArray, forKey: key)
                    userDefaults.synchronize()
                }
                return stringArray
            }else{  // 找不到 则添加到第一个位置
               let stringArray = addString(key, switchString, index: 0)
                return stringArray
            }
            
        }else{
            
            let stringArray = addString(key, switchString)
            
            return stringArray
        }
        
    }
    
    // 删除对应KEY的所有缓存
    func removeAllDatas(_ key : String){
        if inquireDatasForKey(key){
            guard var stringArray = userDefaults.array(forKey: key) as? [String] else {
                print("stringArray - 删除失败")
                return
                
            }
            
            stringArray.removeAll()
            userDefaults.set(stringArray, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    func checkLocalDatas(_ key : String)->[String]?{
        if inquireDatasForKey(key) {
            guard let stringArray = userDefaults.array(forKey: key) as? [String] else {
                print("stringArray - 删除失败")
                return nil
                
            }
            
            return stringArray
        }
        
        return nil
    }
    
    // 查找本地:根据某个KEY
    func inquireDatasForKey(_ key : String)->Bool{
        
        guard let _ = userDefaults.array(forKey: key) as? [String] else {
            print("查找失败")
            return false
            
        }
        
        return true
        
    }
    
}

