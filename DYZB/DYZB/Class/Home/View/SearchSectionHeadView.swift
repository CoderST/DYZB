//
//  SearchSectionHeadView.swift
//  DYZB
//
//  Created by xiudou on 2017/6/27.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let delButtonWH : CGFloat = 20
class SearchSectionHeadView: UICollectionReusableView {
    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: titleFontSize)
        return titleLabel
        
    }()
    
    fileprivate let delButton : UIButton = {
        
        let delButton = UIButton()
        delButton.setTitle("清空", for: .normal)
        delButton.titleLabel?.font = UIFont.systemFont(ofSize: titleFontSize)
        return delButton
        
    }()
    
    var title : String?{
        
        didSet{
            guard let title = title else { return }
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(delButton)
        
        delButton.addTarget(self, action: #selector(delButtonAction), for: .touchUpInside)
        delButton.backgroundColor = .red
    }
    
    var isHiddenDelButton: Bool = false{
        
        didSet{
            
            delButton.isHidden = isHiddenDelButton
        }
    }
    
    @objc fileprivate func delButtonAction(){
        // 删除最近搜索记录
        notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_DelHistory), object: nil, userInfo: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: searchModelMargin, y: 0, width: frame.width - searchModelMargin, height: frame.height)
        
        delButton.frame = CGRect(x: frame.width - 2 * delButtonWH, y: 0, width: delButtonWH * 2, height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
