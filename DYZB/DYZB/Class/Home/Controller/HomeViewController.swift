//
//  HomeViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//   首页面内的所有控件

import UIKit

private let pageTitlesViewH :CGFloat = 40

class HomeViewController: UIViewController {
    
    // MARK:- 定义属性
    
    
    // MARK:- 懒加载
    
    // 滚动条
    fileprivate lazy var pageTitlesView : PageTitlesView = {
        
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titlesFrame = CGRect(x: 0, y: sStatusBarH + sNavatationBarH, width: sScreenW, height: pageTitlesViewH)
        let pageTitlesView = PageTitlesView(frame: titlesFrame, titles: titles)
        return pageTitlesView
        }()
    
    // 滚动条下面装着要显示控制器
    fileprivate lazy var pageContentView : PageContentView = {[weak self] in
        
        // 创建零时数组
        var childVcs = [UIViewController]()
        
        // 计算高度
        let contentH = sScreenH - sStatusBarH - sNavatationBarH - pageTitlesViewH - sTabBarH
        // 设定尺寸
        let pageContentViewFrame = CGRect(x: 0, y: sStatusBarH + sNavatationBarH + pageTitlesViewH, width: sScreenW, height: contentH)
        
        // 初始化第一个界面要显示的内容
        childVcs.append(RecommendViewController())
        childVcs.append(GameViewController())
        childVcs.append(AmuseViewController())
        childVcs.append(FunnyViewController())
        
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
    
    fileprivate func setupUI(){
        
        // 设置导航栏
        setupNavgationrBar()
        
        // 添加Page滚动
        setupPageTitlesView()
        
        // 添加ContentView
        setupPageContentView()
        
    }
    
    fileprivate func setupNavgationrBar(){
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        let size = CGSize(width: 40, height: 40)
        let historItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historItem,searchItem,qrcodeItem]
        
    }
    
    fileprivate func setupPageTitlesView(){
        view.addSubview(pageTitlesView)
        pageTitlesView.delegate = self
    }
    
    fileprivate func setupPageContentView(){
        view.addSubview(pageContentView)
        pageContentView.delegate = self
    }
    
}

// MARK:- PageTitlesViewDelegate
extension HomeViewController : PageTitlesViewDelegate{
    
    func pageTitlesView(_ pageTitlesView: PageTitlesView, index: Int) {
        
        pageContentView.setCurrentIndex(index)
        
    }
}

// MARK:- PageContentViewDelegate
extension HomeViewController : PageContentViewDelegate{
    
    func pageContentView(_ pageContentView: PageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        //         pageTitlesView.setPageTitlesView(progress, originalIndex: originalIndex, targetIndex: targetIndex)
        
        pageTitlesView.setPageTitlesView(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
    
    
}
