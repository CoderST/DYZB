//
//  SearchHistoryVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchHistoryVM: NSObject {
    
    lazy var searchArrayGroup : [SearchModelGroup] = [SearchModelGroup]()
    
    // 清除第一组数据
    func clearSearchOneGroup(){
         guard let searchOneGroup = searchArrayGroup.first else { return }
        searchOneGroup.searchModelArray.removeAll()
    }
    
    // 每次开始加载
    func loadSearchWillAppearDatas(_ finishCallBack : @escaping ()->(), _ messageCallBack : @escaping (_ message : String)->()){
        searchArrayGroup.removeAll()
        let searchOneGroup : SearchModelGroup = SearchModelGroup()
        if let stringCacheArray = UserDefaultsManage.shareInstance().checkLocalDatas(historyKey){
            for string in stringCacheArray{
                let model = SearchModel(title: string, rank: -1)
                let modelFrame = SearchModelFrame(model)
                searchOneGroup.searchModelArray.append(modelFrame)
            }
            
            searchArrayGroup.append(searchOneGroup)
        }else{
            searchArrayGroup.append(searchOneGroup)
        }
        
        // http://apiv2.douyucdn.cn/video/search/getTodayTopData?client_sys=ios&limit=10
        NetworkTools.requestData(.get, URLString: "http://apiv2.douyucdn.cn/video/search/getTodayTopData?client_sys=ios&limit=10") { (result) in
//            print(result)
            guard let resultDict = result as? [String : Any] else {
                finishCallBack()
                return}
            
            guard let errorInt = resultDict["error"] as? Int else {
                finishCallBack()
                return }
            
            if errorInt != 0{
                
                messageCallBack("error")
            }
            
            guard let stringArray = resultDict["data"] as? [String] else {return}
            var rank : Int = 1
            let searchTwoGroup : SearchModelGroup = SearchModelGroup()
            for string in stringArray{
                let model = SearchModel(title: string, rank: rank)
                let modelFrame = SearchModelFrame(model)
                modelFrame.cellSize.width = sScreenW
                searchTwoGroup.searchModelArray.append(modelFrame)
                rank = rank + 1
            }
            self.searchArrayGroup.append(searchTwoGroup)
            finishCallBack()
        }
//        // 查找plist
//        guard let path = Bundle.main.path(forResource: "SearchVC.plist", ofType: nil) else {
//            print("path不存在")
//            return }
//        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
//            print("dict不存在")
//            return }
//        guard let stringArray = dict["searchArray"] as? [String] else { return }
//        var rank : Int = 1
//        let searchTwoGroup : SearchModelGroup = SearchModelGroup()
//        for string in stringArray{
//            let model = SearchModel(title: string, rank: rank)
//            let modelFrame = SearchModelFrame(model)
//            modelFrame.cellSize.width = sScreenW
//            searchTwoGroup.searchModelArray.append(modelFrame)
//            rank = rank + 1
//        }
//        searchArrayGroup.append(searchTwoGroup)
//        
//        finishCallBack()

        
    }


    // 点击item相关处理
    func switchStringCacheDatas(_ insertTitle : String, _ finishCallBack : ()->()){
        
        if let stringArray = UserDefaultsManage.shareInstance().switchStringToFirstIndex(historyKey, insertTitle){
            // 取出第一组
            guard let searchOneGroup = searchArrayGroup.first else { return }
            searchOneGroup.searchModelArray.removeAll()
            for string in stringArray{
                let model = SearchModel(title: string, rank: -1)
                let modelFrame = SearchModelFrame(model)
                searchOneGroup.searchModelArray.append(modelFrame)
            }
            finishCallBack()
        }else{
            print("error - loadSearchCacheDatas")
        }
        
        
        
    }
}
