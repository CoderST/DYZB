//
//  LiveViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController {
  
    // MARK:- 懒加载
    fileprivate lazy var liveViewModel : LiveViewModel  = LiveViewModel()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTitlesDatas()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        removeOrAddTitleView(isHidden: false, navigationBar: navigationController!.navigationBar)
        setStatusBarBackgroundColor(UIColor.orange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        removeOrAddTitleView(isHidden: true, navigationBar: navigationController!.navigationBar)
        setStatusBarBackgroundColor(UIColor.clear)
    }
    
    // 移除和添加titleView
    fileprivate func removeOrAddTitleView(isHidden : Bool, navigationBar : UINavigationBar) {
        
        for subView in navigationBar.subviews{
            
            if subView is STTitlesView{
                subView.isHidden = isHidden
            }
        }
        
    }
    
    ///设置状态栏背景颜色
    func setStatusBarBackgroundColor(_ color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }

}

// MARK:- UI设置
extension LiveViewController {

    
    func loadTitlesDatas() {
        
        liveViewModel.loadLiveTitles {
            // 获得titles数据
            let liveModelDatas = self.liveViewModel.liveModelDatas
            // 去除titles
            var titles : [String] = [String]()
            // 创建零时数组
            var childsVC = [UIViewController]()
            for liveModelData in liveModelDatas{
                let title = liveModelData.cate_name
                titles.append(title)
                
                let subVC = LiveSubViewController()
                subVC.cate_id = liveModelData.cate_id
                childsVC.append(subVC)
            }
            let rect = CGRect(x: 0, y: 64, width: sScreenW, height: sScreenH - 64 - 49)
            // 样式
            let style = STPageViewStyle()
            style.isShowScrollLine = true
            style.isScrollEnable = true
            style.normalColor = UIColor(r: 250, g: 250, b: 250, alpha: 0.8)
            style.selectColor = UIColor(r: 255.0, g: 255.0, b: 255.0)
            style.isShowScrollLine = true
            style.bottomLineColor = UIColor.white
            style.titleViewBackgroundColor = UIColor.orange
            // titleView
            let titleView = self.navigationController?.navigationBar
            let pageView = STPageView(frame: rect, titles: titles, childsVC: childsVC, parentVC: self, style: style, parentView: titleView)
            self.view.addSubview(pageView)

        }
        
    }

}

