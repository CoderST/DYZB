//
//  GameAnchorViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

class GameAnchorViewController: BaseShowViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = UIColor.orangeColor()
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBarHidden = false
    }

}
