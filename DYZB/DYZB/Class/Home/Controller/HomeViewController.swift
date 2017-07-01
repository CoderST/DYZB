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
    
    // MARK:- 懒加载
    // 滚动条下面装着要显示控制器
    fileprivate lazy var pageView : STPageView = {[weak self] in
        
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let rect = CGRect(x: 0, y: 64, width: sScreenW, height: sScreenH - 64 - 49)
        var childsVC = [UIViewController]()
        let recommendViewController = RecommendViewController()
        let gameViewController = GameViewController()
        let amuseViewController = AmuseViewController()
        let funnyViewController = FunnyViewController()
        childsVC.append(recommendViewController)
        childsVC.append(gameViewController)
        childsVC.append(amuseViewController)
        childsVC.append(funnyViewController)
        // 样式
        let style = STPageViewStyle()
        style.titleViewHeight = 44
        style.isShowScrollLine = true

        let pageView = STPageView(frame: rect, titles: titles, childsVC: childsVC, parentVC: self!, style: style, parentView: nil)
        return pageView
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
//        setupPageTitlesView()
        
        // 添加ContentView
        setupPageContentView()
        
    }
    
    fileprivate func setupNavgationrBar(){
        // LOGO
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", target: self, action: #selector(HomeViewController.logoAction))
        let size = CGSize(width: 40, height: 40)
        // 历史记录
         let historItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size, target: self, action: #selector(HomeViewController.historItemAction))
        // 搜索
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size, target: self, action: #selector(HomeViewController.searchItemAction))
        // 二维码
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size, target: self, action: #selector(HomeViewController.qrcodeItemAction))
        
        navigationItem.rightBarButtonItems = [historItem,searchItem,qrcodeItem]
        
    }
    
    fileprivate func setupPageContentView(){
        view.addSubview(pageView)
    }
    
}

// MARK:- 点击事件
extension HomeViewController{
    
    @objc fileprivate func logoAction(){
        debugLog("logoAction")
    }

    
    @objc fileprivate func historItemAction(){
        debugLog("historItemAction - 历史记录")
        let watchHistoryVC = WatchHistoryViewController()
        navigationController?.pushViewController(watchHistoryVC, animated: true)
    }
    
    @objc fileprivate func searchItemAction(){
        debugLog("searchItemAction - 搜索")
        let searchVC = SearchBaseViewController()
        present(searchVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func qrcodeItemAction(){
        debugLog("qrcodeItemAction - 二维码")
        let qrc = QrcodeViewController()
        navigationController?.pushViewController(qrc, animated: true)
    }

}
