//
//  HomeViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }

}

// MARK:- 设置UI
extension HomeViewController{
    
    private func setupUI(){
        
        // 设置导航栏
        setupNavgationrBar()
        
    }
    
    private func setupNavgationrBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        let size = CGSize(width: 35, height: 35)
        let historItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historItem,searchItem,qrcodeItem]
        
    }
    
}
