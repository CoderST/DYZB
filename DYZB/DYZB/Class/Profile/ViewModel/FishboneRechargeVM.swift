//
//  FishboneRechargeVM.swift
//  DYZB
//
//  Created by xiudou on 2017/7/4.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class FishboneRechargeVM: NSObject {
    /*
     http://capi.douyucdn.cn/api/dy_mobilepay/pay_goods/ios?aid=ios&client_sys=ios&time=1499147100&token=94153348_11_7452d666f21c53f4_2_22753003&auth=90d320588be96d7d7ab94a51e922a05c
     //        guard let path = Bundle.main.path(forResource: "searchViewTitles.plist", ofType: nil) else {
     //            print("path不存在")
     //            return }
     //        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
     //            print("dict不存在")
     //            return }
     //        guard let dictArray = dict["titleArray"] as? [[String : Any]] else { return }
     */
    
    lazy var fishboneRechargeBigModel : FishboneRechargeBigModel =  FishboneRechargeBigModel()
    
    func loadFishboneRechargeDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        
        guard let path = Bundle.main.path(forResource: "FishboneRecharge.plist", ofType: nil) else {
            print("path不存在")
            return }
        guard let resultDict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            print("dict不存在")
            return }
        guard let error = resultDict["error"] as? Int else{
            return }
        
        if error != 0 {
            print("数据有错误!!",error,resultDict)
            return
        }
        guard let dataDict = resultDict["data"] as? [String : Any] else {
            return }
        print(dataDict)
        self.fishboneRechargeBigModel = FishboneRechargeBigModel(dict: dataDict)
        
        finishCallBack()

    }
    
}

// MARK:- 下面的方法没有取到数据 用上面的本地数据代替
extension FishboneRechargeVM {
    func testloadFishboneRechargeDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        //        let nowDate = Date.getNowDate()
        guard let nowDate = userDefaults.object(forKey: dateKey) as? Int else{
            
            return
        }
        //        let nowDate =  Date.getNowDateInt()
        let date = (nowDate / 60) * 60
        
        let urlString = "http://capi.douyucdn.cn/api/dy_mobilepay/pay_goods/ios?aid=ios&client_sys=ios&time=\(date)&token=\(TOKEN)&auth=\(AUTH)"
        NetworkTools.requestData(.get, URLString: urlString) { (result) in
            guard let resultDict = result as? [String : Any] else { return }
            guard let error = resultDict["error"] as? Int else{
                return }
            
            if error != 0 {
                print("数据有错误!!",error,resultDict)
                return
            }
            guard let dataDict = resultDict["data"] as? [String : Any] else {
                return }
            
            self.fishboneRechargeBigModel = FishboneRechargeBigModel(dict: dataDict)
            
            finishCallBack()
        }
    }
}
