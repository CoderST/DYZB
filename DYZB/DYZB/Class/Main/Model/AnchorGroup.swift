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
            
            guard let roomList = room_list else {return}
            
            for dict in roomList{
                anchors.append(AnchorModel(dict: dict))
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
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
