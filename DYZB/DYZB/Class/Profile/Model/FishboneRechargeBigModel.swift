//
//  FishboneRechargeBigModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/4.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class FishboneRechargeBigModel: BaseModel {

    var pay_method_switch : Int = 0
    var gold_balance : String = ""
    var first_pay : String = ""
    var ratio_msg : String = ""
    
    var fishboneRechargeModelArray : [FishboneRechargeModel] = [FishboneRechargeModel]()
    
    // MARK:- 必须调用super 不能省略
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "list"{
            if let listArray = value as? [[String : Any]] {
                for listDict in listArray {
                    fishboneRechargeModelArray.append(FishboneRechargeModel(dict: listDict))
                }
            }
        }else {
            super.setValue(value, forKey: key)
        }
    }

}
