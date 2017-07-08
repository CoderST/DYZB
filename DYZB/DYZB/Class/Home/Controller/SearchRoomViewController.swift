//
//  SearchRoomViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/29.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let navigationBarHeight : CGFloat = 64
protocol SearchRoomViewControllerDelegate : class{
    func dissMissVC(searchRoomViewController : SearchRoomViewController)
}
class SearchRoomViewController: UIViewController {

    weak var delegate : SearchRoomViewControllerDelegate?
    
    fileprivate lazy var navigationBar : SearchRoomNavagationBar = {
        
        let navigationBar = SearchRoomNavagationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: sScreenW, height: navigationBarHeight)
        return navigationBar
        
    }()

    
    // 滚动条下面装着要显示控制器
    fileprivate lazy var pageView : STPageView = {[weak self] in
        
        let titles = ["全部", "直播", "主播", "相关度"]
        let rect = CGRect(x: 0, y: navigationBarHeight, width: sScreenW, height: sScreenH - navigationBarHeight)
        var childsVC = [UIViewController]()
        let recommendViewController = SearchSubRoomViewController()
        let gameViewController = SearchSubRoomViewController()
        let amuseViewController = SearchSubRoomViewController()
        let funnyViewController = SearchSubRoomViewController()
        childsVC.append(recommendViewController)
        childsVC.append(gameViewController)
        childsVC.append(amuseViewController)
        childsVC.append(funnyViewController)
        // 样式
        let style = STPageViewStyle()
        style.titleViewHeight = 44
        style.isContentViewScrollEnabled = false
        style.titleViewBackgroundColor = .white
        let pageView = STPageView(frame: rect, titles: titles, childsVC: childsVC, parentVC: self!, style: style, titleViewParentView: nil)
        return pageView
        }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        notificationCenter.addObserver(self, selector: #selector(disButtonClick), name: NSNotification.Name(rawValue: sNotificationName_RoomDismiss), object: nil)
        
//        setupLiveViewControllerUI()
//        
//        
//        loadMainData(cate_id)

    }

  
    
    func disButtonClick(){
        dismiss(animated: false) {
            self.delegate?.dissMissVC(searchRoomViewController: self)
        }
    }
    
}

extension SearchRoomViewController {
    
    func setupUI(){
        view.addSubview(navigationBar)
        // 添加ContentView
        view.addSubview(pageView)
        
//        let disButton = UIButton(type: .contactAdd)
//        disButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        view.addSubview(disButton)
//        
//        disButton.addTarget(self, action: #selector(disButtonClick), for: .touchUpInside)
    }
}
