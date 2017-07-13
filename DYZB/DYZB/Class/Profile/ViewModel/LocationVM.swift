//
//  LocationVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LocationVM: NSObject {

    lazy var locationModelArray : [LocationModel] = [LocationModel]()
    
    func loadLocationDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        guard let path = Bundle.main.path(forResource: "ProvincesAndCities.plist", ofType: nil) else {
            print("path不存在")
            return }
//        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
//            print("dict不存在")
//            return }
//        
        guard let dictArray = NSArray(contentsOfFile: path) as? [[String : Any]] else {
            print("dictArray不存在")
            return }
        for dict in dictArray {
            let model = LocationModel(dict: dict)
            locationModelArray.append(model)
        }

        finishCallBack()
    }
    
    override init() {
        super.init()
        
                   }
}
