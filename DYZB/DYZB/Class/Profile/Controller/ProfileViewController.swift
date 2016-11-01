//
//  ProfileViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startLiveingBtn = UIButton ()
        startLiveingBtn.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        startLiveingBtn.backgroundColor = UIColor.redColor()
        startLiveingBtn.setTitle("GO->直播", forState: .Normal)
        startLiveingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startLiveingBtn.layer.cornerRadius = 200
        startLiveingBtn.addTarget(self, action: "startLiveingBtnClick", forControlEvents: .TouchUpInside)
        startLiveingBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        view.addSubview(startLiveingBtn)
    }
    
    @objc private func startLiveingBtnClick(){
        let showVC = ShowBaseSanFangViewController()
        
        presentViewController(showVC, animated: true, completion: nil)
    }

}
