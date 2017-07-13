//
//  LocationModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationModel: BaseModel {

    var State : String = ""
    var Cities : [LocationSubModel] = [LocationSubModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "Cities"{
            guard let CitiesArray = value as? [[String : Any]] else { return }
            for dict in CitiesArray{
                let model = LocationSubModel(dict: dict)
                Cities.append(model)
            }
        }else{
            
            super.setValue(value, forKey: key)
        }
    }
}


class LocationSubModel : BaseModel {
    
    var city : String = ""
//    var lat : Int = ""
//    var lon : String = ""
}
