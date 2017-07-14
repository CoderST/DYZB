//
//  LocationModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationModel: BaseModel {

    var name : String = ""
    var code : Int = 0
    var city : [LocationSubModel] = [LocationSubModel]()
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "city"{
            guard let CitiesArray = value as? [[String : Any]] else { return }
            for dict in CitiesArray{
                let model = LocationSubModel(dict: dict)
                city.append(model)
            }
        }else{
            
            super.setValue(value, forKey: key)
        }
    }
}


class LocationSubModel : BaseModel {
    
    var name : String = ""
    var code : Int = 0
//    var lat : Int = ""
//    var lon : String = ""
}

class LocationModelGroup: BaseModel {
    
    var locationModelGroup : [LocationModel] = [LocationModel]()
    var headString : String = ""
}
