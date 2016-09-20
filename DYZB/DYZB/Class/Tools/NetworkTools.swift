//
//  NetworkTools.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType {
    
    case GET
    case POST
}
class NetworkTools {

    class func requestData(type : MethodType,URLString : String,parameters:[String : AnyObject]? = nil,finishCallBack : (result : AnyObject) -> ()){
    print(parameters)
        // 确定请求类型
        let method = type == .GET ? Method.GET : Method.POST
        
        // 发送网络请求
       Alamofire.request(method, URLString, parameters: parameters).responseJSON { (response) -> Void in
        
        // 守护结果
        guard let result = response.result.value else{
            print("没有结果")
            return
        }
        
        finishCallBack(result: result)
        
        }
        
    }
    
}
