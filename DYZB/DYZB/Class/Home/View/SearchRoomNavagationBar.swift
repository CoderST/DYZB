//
//  SearchRoomNavagationBar.swift
//  DYZB
//
//  Created by xiudou on 2017/6/30.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

fileprivate let margin : CGFloat = 10

fileprivate let disMissButtonWidth : CGFloat = 40
fileprivate let disMissButtonHeight : CGFloat = 40

fileprivate let textFileWidth : CGFloat = sScreenW - disMissButtonWidth - margin - margin - margin
fileprivate let textFileHeight : CGFloat = 40
class SearchRoomNavagationBar: UIView {
    
    fileprivate lazy var textFile : UITextField = {
       
        let textFile = UITextField()
        textFile.backgroundColor = .white
        textFile.placeholder = "王者荣耀"
        return textFile
    }()
    
    fileprivate lazy var disMissButton : UIButton = {
        
        let disMissButton = UIButton()
        disMissButton.setTitle("取消", for: .normal)
        return disMissButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .orange
        addSubview(textFile)
        addSubview(disMissButton)
        
        disMissButton.addTarget(self, action: #selector(disMissButtonClick), for: .touchUpInside)
    }
    
    func disMissButtonClick() {
        notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_RoomDismiss), object: nil, userInfo: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textFile.frame = CGRect(x: margin, y: (frame.height - textFileHeight) * 0.5, width: textFileWidth, height: textFileHeight)
        
        disMissButton.frame = CGRect(x: frame.width - disMissButtonWidth - margin, y: (frame.height - disMissButtonHeight) * 0.5, width: disMissButtonWidth, height: disMissButtonHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
