//
//  SearchVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
class SearchVM: NSObject {
    
    lazy var searchArrayGroup : [SearchModelGroup] = [SearchModelGroup]()
    
    lazy var searchLocalModelArray : SearchModelGroup = SearchModelGroup()
    fileprivate lazy var searchModelArray : SearchModelGroup = SearchModelGroup()
    
    fileprivate lazy var dictArray : [[String : Any]] = [[String : Any]]()

    
    func loadSearchDatas(_ insertTitle : String?, _ finishCallBack : ()->()) {
        
        if var historyDictArray = userDefaults.array(forKey: historyKey) as? [[String : Any]]{
            if insertTitle != nil {
                dictArray.removeAll()
                 let dict : [String : Any] = ["title" : insertTitle!]
                
                // 如果在历史记录中有最新的值 则不做处理,吧最新的值放在第一个位置
                for historyDict in historyDictArray{
                    guard let historTitle = historyDict["title"] as? String else { continue }
                    if historTitle == insertTitle!{
                    let dictArray = historyDictArray as NSArray
                    let index =  dictArray.index(of: historyDict)
                        historyDictArray.remove(at: index)
                        historyDictArray.insert(historyDict, at: 0)
                        userDefaults.set(historyDictArray, forKey: historyKey)
                        userDefaults.synchronize()
                        searchLocalModelArray.searchModelArray.removeAll()
//                        for dict in historyDictArray{
//                            let model = SearchModel(dict: dict)
//                            let modelFrame = SearchModelFrame(model)
//                            searchLocalModelArray.searchModelArray.append(modelFrame)
//                        }
                        searchArrayGroup.append(searchLocalModelArray)
                        finishCallBack()
                        return
                    }
                    
                }
                
                searchArrayGroup.removeAll()
                 searchLocalModelArray.searchModelArray.removeAll()
                dictArray.append(dict)
                historyDictArray = dictArray + historyDictArray
                userDefaults.set(historyDictArray, forKey: historyKey)
                userDefaults.synchronize()
            }
//            for dict in historyDictArray{
//                let model = SearchModel(dict: dict)
//                let modelFrame = SearchModelFrame(model)
//                searchLocalModelArray.searchModelArray.append(modelFrame)
//            }
            searchArrayGroup.append(searchLocalModelArray)
            
        }else{
            print("historyDictArray本地历史记录不存在")

            searchArrayGroup.removeAll()
                if insertTitle != nil {
                    dictArray.removeAll()
                    let dict : [String : Any] = ["title" : insertTitle!]
                    dictArray.append(dict)
                    userDefaults.set(dictArray, forKey: historyKey)
                    userDefaults.synchronize()
                
//                    let model = SearchModel(dict: dict)
//                    let modelFrame = SearchModelFrame(model)
//                    searchLocalModelArray.searchModelArray.append(modelFrame)

                    searchArrayGroup.append(searchLocalModelArray)
                
                }else{
                    
                    searchArrayGroup.append(searchLocalModelArray)
            }
            

            
        }
        
        
        // 查找plist
        guard let path = Bundle.main.path(forResource: "SearchVC.plist", ofType: nil) else {
            print("path不存在")
            return }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            print("dict不存在")
            return }
        guard let dictArray = dict["searchArray"] as? [[String : Any]] else { return }
        searchModelArray.searchModelArray.removeAll()
//        for dict in dictArray{
//            let model = SearchModel(dict: dict)
//            let modelFrame = SearchModelFrame(model)
//            modelFrame.cellSize.width = sScreenW
//            searchModelArray.searchModelArray.append(modelFrame)
//        }
        searchArrayGroup.append(searchModelArray)
        
        finishCallBack()
    }
}
