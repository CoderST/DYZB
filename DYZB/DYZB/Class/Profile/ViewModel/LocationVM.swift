//
//  LocationVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationVM: NSObject {
    
    //    lazy var locationModelArray : [LocationModel] = [LocationModel]()
    
    
    lazy var locationModelGroups : [LocationModelGroup] = [LocationModelGroup]()
    
    fileprivate lazy var  locationModelOneGroup : LocationModelGroup = LocationModelGroup()
    fileprivate lazy var  locationModelTwoGroup : LocationModelGroup = LocationModelGroup()
    
    func loadLocationDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        guard let path = Bundle.main.path(forResource: "china.plist", ofType: nil) else {
            print("path不存在")
            return }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            print("dict不存在")
            return }
        guard let dictArray = dict["data"] as? [[String : Any]] else { return }
        //        guard let dictArray = NSArray(contentsOfFile: path) as? [[String : Any]] else {
        //            print("dictArray不存在")
        //            return }
        //        for dict in dictArray {
        //            let model = LocationModel(dict: dict)
        //
        //            locationModelArray.append(model)
        //        }
        
        for (int, dict) in dictArray.enumerated(){
            let model = LocationModel(dict: dict)
            if int < 4 {
                locationModelOneGroup.headString = "直辖市"
                locationModelOneGroup.locationModelGroup.append(model)
            }else{
                locationModelTwoGroup.headString = "省会"
                locationModelTwoGroup.locationModelGroup.append(model)
            }
        }
        
        locationModelGroups.append(locationModelOneGroup)
        locationModelGroups.append(locationModelTwoGroup)

        finishCallBack()
    }
}
