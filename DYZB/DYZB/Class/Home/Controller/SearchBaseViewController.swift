//
//  SearchBaseViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchBaseViewController: UIViewController {

    fileprivate lazy var searchVC : SearchViewController = SearchViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewController(searchVC)
        
        view.addSubview(searchVC.view)
    }

}
