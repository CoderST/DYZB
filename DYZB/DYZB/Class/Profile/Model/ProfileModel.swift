//
//  ProfileModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {

    var imageName : String
    var titleName : String
    var subTitleName : String?
    var targetClass : AnyClass
    
    init(imageName : String, titleName : String, subTitleName : String?, targetClass : AnyClass) {
        self.imageName = imageName
        self.titleName = titleName
        self.subTitleName = subTitleName
        self.targetClass = targetClass
        super.init()
        
    }
}
