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
        startLiveingBtn.backgroundColor = UIColor.red
        startLiveingBtn.setTitle("GO->直播", for: UIControlState())
        startLiveingBtn.setTitleColor(UIColor.white, for: UIControlState())
        startLiveingBtn.layer.cornerRadius = 200
        startLiveingBtn.addTarget(self, action: #selector(ProfileViewController.startLiveingBtnClick), for: .touchUpInside)
        startLiveingBtn.setTitleColor(UIColor.black, for: UIControlState())
        
        view.addSubview(startLiveingBtn)
    }
    
    @objc fileprivate func startLiveingBtnClick(){
        let showVC = ShowBaseSanFangViewController()
        
        present(showVC, animated: true, completion: nil)
    }

}
