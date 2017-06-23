//
//  GameCenterVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/22.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class GameCenterVM: NSObject {

    var gameModelArray : [GameCenterModel] = [GameCenterModel]()
    
    func loadGameCenterDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        
        //当前时间的时间戳
        let URLString = String(format: "http://capi.douyucdn.cn/api/app_api/get_app_list?type=ios&time=%@&devid=99F096BA-477A-4D0A-AB26-69B76DDB85C6&client_sys=ios&sign=7ae9b6366022b7575f36765f82bf2771", Date.getNowDate())
        NetworkTools.requestData(.get, URLString: URLString) { (result) in
            guard let result = result as? [String : Any] else {
                return }
            
            guard let error = result["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,result)
                return
            }
            guard let dict = result["data"] as? [String : Any] else {
                return }
            guard let dictArray = dict["data"] as? [[String : Any]] else {
                return }
            for dict in dictArray{
                let gameModel = GameCenterModel(dict: dict)
                self.gameModelArray.append(gameModel)
            }
            finishCallBack()
        }
    }
}
