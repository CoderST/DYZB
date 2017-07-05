//
//  GameViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/26.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class GameViewModel {

    lazy var gamesData : [GameModel] = [GameModel]()
    
    func requestGameData(_ finishCallBack:@escaping ()->()){
        NetworkTools.requestData(.get, URLString: "http://capi.douyucdn.cn/api/v1/getColumnDetail", parameters: ["shortName" : "game"]) { (result) -> () in
            guard let resultDic = result as? [String : Any] else {return}
            
            guard let resultArray = resultDic["data"] as?[[String : Any]] else {return}
            
            for dic in resultArray{
                let model = GameModel(dict: dic)
                self.gamesData.append(model)
            }
            
            finishCallBack()
        }
    }
}
