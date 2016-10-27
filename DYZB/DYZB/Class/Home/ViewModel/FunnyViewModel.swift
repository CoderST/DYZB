//
//  FunnyViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class FunnyViewModel: BaseViewModel {

    func loadFunnyDatas(finishCallBack:()->()){
        
        loadAnchDates(false, urlString: "http://capi.douyucdn.cn/api/v1/getColumnRoom/3", parameters: ["limit" : "0","offset" : "0"], finishCallBack: finishCallBack)
    
    }
}
