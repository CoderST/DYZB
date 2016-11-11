//
//  ShowUserVC.swift
//  DYZB
//
//  Created by xiudou on 16/11/9.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
class ShowUserVC: UIViewController {
    
    var testview : UILabel?
    
    // MARK:- 懒加载
    private lazy var showUserView : ShowUserView = ShowUserView()
    
    var roomAnchor : RoomFollowPerson? {
        
        didSet {
            guard let model = roomAnchor else { return }
            showUserView.userModel = model
        }
    }
    
    
    // MARK:- LIFE
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(showUserView)
        showUserView.delegate = self
        
        showUserView.snp_makeConstraints(closure: { (make) -> Void in
            make.left.right.top.bottom.equalTo(view)
        })
    }
}

// MARK:- ShowUserViewDelegate
extension ShowUserVC : ShowUserViewDelegate {
    func showUserViewCloseVC(showUserView: ShowUserView) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
