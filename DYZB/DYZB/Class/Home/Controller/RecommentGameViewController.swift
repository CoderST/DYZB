//
//  RecommentGameViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/7.
//  Copyright © 2017年 xiudo. All rights reserved.
//  推荐游戏ViewController

import UIKit
import SVProgressHUD
class RecommentGameViewController: BaseViewController {

    // MARK:- 对外
    var baseGameModel : BaseGameModel = BaseGameModel()
    
    // MARK:- 懒加载
    fileprivate lazy var recommentGameVM : RecommentGameVM = RecommentGameVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = baseGameModel.tag_name
        loadTitlesDatas()
    }
}

// MARK:- UI设置
extension RecommentGameViewController {
    
    
    func loadTitlesDatas() {
        
        recommentGameVM.loadRecommentGameTitlesDatas(tag_id: "\(baseGameModel.tag_id)",{
            // 判断是否有titles
            // 获得titles数据
            var recommentGameTitles = self.recommentGameVM.recommentGameTitleModelArray
            let style = STPageViewStyle()
            // 创建零时数组
            var childsVC = [UIViewController]()
            var titles : [String] = [String]()
            let allModel = RecommentGameTitleModel()
            allModel.id = "\(self.baseGameModel.tag_id)"
            allModel.name = "全部"
            if recommentGameTitles.count > 0{
                // 插入全部标题
                recommentGameTitles.insert(allModel, at: 0)
                // 取出titles
                for recommentGameTitle in recommentGameTitles{
                    let title = recommentGameTitle.name
                    titles.append(title)
                    let subVC = RecommentGameSubViewController()
                    subVC.baseGameModel = self.baseGameModel
                    subVC.id = recommentGameTitle.id
                    childsVC.append(subVC)
                }
                
            }else{
                let subVC = RecommentGameSubViewController()
                subVC.baseGameModel = self.baseGameModel
                subVC.id = self.baseGameModel.tag_id
                childsVC.append(subVC)
                /// 设置titleView高度为0
                style.titleViewHeight = 0

            }
            
            let rect = CGRect(x: 0, y: 64, width: sScreenW, height: sScreenH - sStatusBarH - sNavatationBarH)
            
            /// 样式
            
            // cover
            style.isShowCover = true
            style.coverBoderStyle = .border
            style.coverBoderWidth = 1
            style.coverRadius = style.coverHeight * 0.5
            style.coverBoderColor = UIColor(r: 253.0, g: 110, b: 20)
            // titleView
            style.isShowScrollLine = false
            style.isScrollEnable = true
            style.normalColor = UIColor(r: 100, g: 100, b: 100, alpha: 1.0)
            style.selectColor = style.coverBoderColor
            style.titleViewBackgroundColor = UIColor.white
            // content
            style.isContentViewScrollEnabled = false
            
            let pageView = STPageView(frame: rect, titles: titles, childsVC: childsVC, parentVC: self, style: style, titleViewParentView: nil)
            self.view.addSubview(pageView)

        }, { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }) {
            SVProgressHUD.showError(withStatus: "")
        }
    }
    
}
