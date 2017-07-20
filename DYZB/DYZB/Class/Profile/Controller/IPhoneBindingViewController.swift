//
//  IPhoneBindingViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class IPhoneBindingViewController: UIViewController {

    fileprivate lazy var iPhoneBindingView : IPhoneBindingView = IPhoneBindingView()
    
    var scrollView : UIScrollView!
    

    
    override func loadView() {
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        
        view = scrollView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        setupUI()
        scrollView.delegate = self
        
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLog(CountryViewModel.shareCountryVM.groups.count)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
    }
    
    deinit {
        view.endEditing(false)
    }
}

extension IPhoneBindingViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        
        if !decelerate {
            view.endEditing(false)
        }
    }
}

// MARK:- 添加UI 设置Frame
extension IPhoneBindingViewController {
    fileprivate func setupUI() {
        scrollView.isScrollEnabled = true
        scrollView.addSubview(iPhoneBindingView)
        scrollView.contentSize = CGSize(width: 0, height: iPhoneBindingView.frame.height)
    }
    

}


