//
//  AmuseViewModel.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class AmuseViewModel: BaseViewModel {

    func loadAmuseDates(_ finishCallBack:@escaping ()->()){
        
        loadAnchDates(true, urlString: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishCallBack: finishCallBack)
    }
}
