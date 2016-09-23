//
//  AnchorGroup.swift
//  DYZB
//
//  Created by xiudou on 16/9/20.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {

    // MARK:- 定义属性
 /// 组名称
    var tag_name : String = ""
 /// 组图片
    var icon_name : String = "home_header_normal"
    
    // MARK:- 懒加载
    /// 定义主播的模型对象数组
    lazy var anchors : [AnchorModel] = [AnchorModel]()
    
    // MARK:- set 字典数组
    var room_list : [[String : NSObject]]?{
        
        didSet{
            // 对room_list进行效验
            guard let roomList = room_list else {return}
            
            for dict in roomList{
                // 转为模型,添加到数组
                let anchorModel = AnchorModel(dict: dict)
                anchors.append(anchorModel)
            }
            
        }
    }
    
    
    override init() {
        
    }
    // MARK:- 构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 必须实现,不然会报错
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}


}
