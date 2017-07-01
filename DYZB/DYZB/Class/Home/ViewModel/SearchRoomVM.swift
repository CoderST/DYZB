//
//  SearchRoomVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
// 每一个item宽
fileprivate let sMargin : CGFloat = 10
fileprivate let sAnchorItemWidth : CGFloat = (sScreenW - (4 + 1) * sMargin) / (4)
class SearchRoomVM: NSObject {
    
    
    lazy var searchRoomGroupArray : [SearchRoomGroupModel] = [SearchRoomGroupModel]()
    
    
    func loadSearchRoomDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack:@escaping (_ messaage : String)->()){
        let time = Date.getNowDate()
        // MARK:- 发送最热请求
        let urlString = "http://capi.douyucdn.cn/api/v1/mobileSearch/1/1?aid=ios&client_sys=ios&limit=20&offset=0&sk=%E7%8E%8B%E8%80%85%E8%8D%A3%E8%80%80&time=\(time)&auth=7c5828e347cec02aee5c2ef33013eb47"
        NetworkTools.requestData(.get, URLString: urlString) { (result) -> () in
            guard let resultDict = result as? [String : Any] else {return}
            
            guard let resultDataDict = resultDict["data"] as? [String : Any] else {return}
            
            guard let errorInt = resultDict["error"] as? Int else { return }
            
            if errorInt != 0{
                messageCallBack("error")
            }
            // 分类
            guard let cateDictArray = resultDataDict["cate"] as? [[String : Any]] else {return}
            let cateGroup = SearchRoomGroupModel()
            for dict in cateDictArray{
                let cateModel = SearchRoomModel(dict: dict)
                cateGroup.searchRoomModelGroup.append(cateModel)
                cateModel.width = 70
                cateModel.height = 80
                cateModel.reusableViewTitle = "分类"
            }
            self.searchRoomGroupArray.append(cateGroup)
            
            // 主播
            guard let anchorDictArray = resultDataDict["anchor"] as? [[String : Any]] else {return}
            let anchorGroup = SearchRoomGroupModel()
            for dict in anchorDictArray{
                let anchorModel = SearchRoomModel(dict: dict)
                anchorModel.width = sAnchorItemWidth
                anchorModel.height = 90
                anchorModel.reusableViewTitle = "主播"

                anchorGroup.searchRoomModelGroup.append(anchorModel)
            }
            self.searchRoomGroupArray.append(anchorGroup)
            // 直播
            guard let roomDictArray = resultDataDict["room"] as? [[String : Any]] else {return}
            let roomGroup = SearchRoomGroupModel()
            for dict in roomDictArray{
                let roomModel = SearchRoomModel(dict: dict)
                
                roomModel.width = sItemWidth
                roomModel.height = sItemNormalWidth
                roomModel.reusableViewTitle = "直播"
                roomGroup.searchRoomModelGroup.append(roomModel)
            }
            self.searchRoomGroupArray.append(roomGroup)
            
            finishCallBack()
        }
        
    }
}
