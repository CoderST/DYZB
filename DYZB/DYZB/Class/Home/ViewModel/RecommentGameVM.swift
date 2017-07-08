//
//  RecommentGameVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/7.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class RecommentGameVM: BaseViewModel {

    /// titles
    lazy var recommentGameTitleModelArray : [RecommentGameTitleModel] = [RecommentGameTitleModel]()
    
    /// 全部和其他的标题
    lazy var recommentGameElseModelArray : [RecommentGameElseModel] = [RecommentGameElseModel]()

}

/// titles请求
extension RecommentGameVM {
    
    func loadRecommentGameTitlesDatas(tag_id : String, _ finishCallBack:@escaping ()->(), _ messageCallBack:@escaping (_ messaage : String)->(),failCallBack :@escaping ()->()){
        
        // MARK:- 发送最热请求
        let urlString = "http://capi.douyucdn.cn/api/v1/getThreeCate?client_sys=ios&tag_id=\(tag_id)"
        NetworkTools.requestData(.get, URLString: urlString) { (result) -> () in
            guard let resultDict = result as? [String : Any] else {return}
            
            guard let errorInt = resultDict["error"] as? Int else { return }
            
            if errorInt != 0{
                messageCallBack("error")
                
                return
            }
            
            guard let resultDictArray = resultDict["data"] as? [[String : Any]] else {return}
            for dict in resultDictArray{
                let model = RecommentGameTitleModel(dict: dict)
                self.recommentGameTitleModelArray.append(model)
            }
            
            finishCallBack()
        }
    }
}

/// 全部的数据
extension RecommentGameVM {
    
    func loadRecommentGameAllDatas(tag_id : String, _ finishCallBack:@escaping ()->(), _ messageCallBack:@escaping (_ messaage : String)->(),failCallBack :@escaping ()->()){
        
        // MARK:- 发送最热请求
        let urlString = "http://capi.douyucdn.cn/api/v1/live/\(tag_id)?offset=0&client_sys=ios&limit=20"
        
        loadAnchDates(false, urlString: urlString, finishCallBack: finishCallBack)
//        NetworkTools.requestData(.get, URLString: urlString) { (result) -> () in
//            guard let resultDict = result as? [String : Any] else {return}
//            
//            guard let errorInt = resultDict["error"] as? Int else { return }
//            
//            if errorInt != 0{
//                messageCallBack("error")
//                
//                return
//            }
//            
//            guard let resultDictArray = resultDict["data"] as? [[String : Any]] else {return}
//            for dict in resultDictArray{
//                let model = RecommentGameElseModel(dict: dict)
//                self.recommentGameElseModelArray.append(model)
//            }
//            
//            finishCallBack()
//        }
    }
}

/// 妹子主播 英雄上单  野区霸主....
extension RecommentGameVM {
    func loadRecommentGameElseDatas(_ cate_id : String, _ finishCallBack:@escaping ()->(), _ messageCallBack:@escaping (_ messaage : String)->(),failCallBack :@escaping ()->()){
        // http://capi.douyucdn.cn/api/v1/live/124?offset=0&client_sys=ios&limit=20
        // MARK:- 发送最热请求
        let urlString = "http://capi.douyucdn.cn/api/v1/getThreeList?cate_id=\(cate_id)&client_sys=ios&offset=0&limit=20"
        
        loadAnchDates(false, urlString: urlString, finishCallBack: finishCallBack)
        
//        NetworkTools.requestData(.get, URLString: urlString) { (result) -> () in
//            guard let resultDict = result as? [String : Any] else {return}
//            
//            guard let errorInt = resultDict["error"] as? Int else { return }
//            
//            if errorInt != 0{
//                messageCallBack("error")
//                
//                return
//            }
//            
//            guard let resultDictArray = resultDict["data"] as? [[String : Any]] else {return}
//            for dict in resultDictArray{
//                let model = RecommentGameElseModel(dict: dict)
//                self.recommentGameElseModelArray.append(model)
//            }
//            
//            finishCallBack()
//        }
    }
}
