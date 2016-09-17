//
//  HomeViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

private let pageTitlesViewH :CGFloat = 40

class HomeViewController: UIViewController {
    
    // MARK:- 定义属性
    
    
    // MARK:- 懒加载
    private lazy var pageTitlesView : PageTitlesView = {[weak self] in
        
        let titles = ["1","2","3","4"]
        let titlesFrame = CGRect(x: 0, y: StatusBar + NavatationBar, width: ScreenW, height: pageTitlesViewH)
        let pageTitlesView = PageTitlesView(frame: titlesFrame, titles: titles)
        return pageTitlesView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        
         var childVcs = [UIViewController]()
        let contentH = ScreenH - StatusBar - NavatationBar - pageTitlesViewH
        let pageContentViewFrame = CGRect(x: 0, y: StatusBar + NavatationBar + pageTitlesViewH, width: ScreenW, height: contentH)
        for var index = 0; index < 4; ++index {

            let VC = UIViewController()
            childVcs.append(VC)
            
        }
            let pageContentView = PageContentView(frame: pageContentViewFrame, childVcs: childVcs, parentViewController: self)
        
        
        return pageContentView
    }()
    
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        
        setupUI()

    }

}

// MARK:- 设置UI
extension HomeViewController{
    
    private func setupUI(){
        
        // 设置导航栏
        setupNavgationrBar()
        
        // 添加Page滚动
        setupPageTitlesView()
        
        //
        setupPageContentView()
        
    }
    
    private func setupNavgationrBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        let size = CGSize(width: 35, height: 35)
        let historItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historItem,searchItem,qrcodeItem]
        
    }
    
    private func setupPageTitlesView(){
        view.addSubview(pageTitlesView)
        pageTitlesView.delegate = self
    }
    
    private func setupPageContentView(){
        view.addSubview(pageContentView)
        pageContentView.delegate = self
    }
    
}

extension HomeViewController : PageTitlesViewDelegate{
    
    func pageTitlesView(pageTitlesView: PageTitlesView, index: Int) {
        
        pageContentView.setCurrentIndex(index)
        
        print("-------",index)
    }
}

extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(pageContentView: PageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
//         pageTitlesView.setPageTitlesView(progress, originalIndex: originalIndex, targetIndex: targetIndex)
        
        pageTitlesView.setPageTitlesView(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
    
    
}
