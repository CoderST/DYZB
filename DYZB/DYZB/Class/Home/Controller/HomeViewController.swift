//
//  HomeViewController.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//   首页面内的所有控件

import UIKit
import SVProgressHUD
fileprivate let pageTitlesViewH :CGFloat = 40
fileprivate let cicleButtonWH : CGFloat = 44
class HomeViewController: UIViewController {
    
    // MARK:- 懒加载 动画相关定义
    fileprivate var duration : CFTimeInterval = 0.3
    /// firstButton
    fileprivate var transcribeButtonStartPoint : CGPoint = .zero
    fileprivate var transcribeButtonEndPoint : CGPoint = .zero
    fileprivate var transcribeButtonControlPoint : CGPoint = .zero
    /// secondButton
    fileprivate var liveButtonStartPoint : CGPoint = .zero
    fileprivate var liveButtonEndPoint : CGPoint = .zero
    fileprivate var liveButtonControlPoint : CGPoint = .zero
    /// direction
    fileprivate var direction : Direction = .plus
    /// 变量
    fileprivate var istranscribeButtonStart : Bool = false
    fileprivate var isliveButtonStart : Bool = false
    
    fileprivate lazy var animationModel : AnimationModel = AnimationModel()
    
    fileprivate lazy var centerButton : CicleButton = {
        let centerButton = CicleButton()
        let normalImage = UIImage(named: "btn_livevideo_start_user")
        let selectedImage = UIImage(named: "btn_livevideo_close_user")
        centerButton.setBackgroundImage(normalImage, for: .normal)
        centerButton.setBackgroundImage(selectedImage, for: .selected)
        centerButton.frame = CGRect(x: sScreenW - cicleButtonWH - 10, y: sScreenH - cicleButtonWH - 10 - sTabBarH, width: cicleButtonWH, height: cicleButtonWH)
        return centerButton
    }()
    
    /// 录制
    fileprivate lazy var transcribeButton : CicleButton = {
        let transcribeButton = CicleButton()
        let normalImage = UIImage(named: "btn_video_user")
        transcribeButton.setBackgroundImage(normalImage, for: .normal)
        transcribeButton.backgroundColor = .black
        transcribeButton.frame = CGRect(x: 0, y: 0, width: cicleButtonWH, height: cicleButtonWH)
        
        return transcribeButton
    }()
    
    /// 直播
    fileprivate lazy var liveButton : CicleButton = {
        let liveButton = CicleButton()
        let normalImage = UIImage(named: "btn_live_user")
        liveButton.setBackgroundImage(normalImage, for: .normal)
        liveButton.frame = CGRect(x: 0, y: 0, width: cicleButtonWH, height: cicleButtonWH)
        
        return liveButton
    }()

    
    
    // MARK:- 懒加载
    fileprivate lazy var baseVM : BaseViewModel = BaseViewModel()
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

        let pageView = STPageView(frame: rect, titles: titles, childsVC: childsVC, parentVC: self!, style: style, titleViewParentView: nil)
        return pageView
        }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationModel.delegate = self
        
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
        
        // 添加按钮点击动画组件
        setupAnimationButton()
        
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
        
        // 二维码
        let messageItem = UIBarButtonItem(imageName: "messageNormal", highImageName: "messageNormalHL", size: size, target: self, action: #selector(HomeViewController.messageItemAction))
        
        navigationItem.rightBarButtonItems = [searchItem,qrcodeItem,historItem,messageItem]
        
    }

    
    fileprivate func setupPageContentView(){
        view.addSubview(pageView)
        
        view.addSubview(centerButton)
    }
    
    fileprivate func setupAnimationButton(){
        /// 添加点击事件
        centerButton.addTarget(self, action: #selector(centerButtonClick(sender:)), for: .touchUpInside)
        transcribeButton.addTarget(self, action: #selector(transcribeButtonClick(sender:)), for: .touchUpInside)
        liveButton.addTarget(self, action: #selector(liveButtonClick(sender:)), for: .touchUpInside)
        
        
        transcribeButton.center = CGPoint(x: centerButton.center.x, y: centerButton.center.y)
        liveButton.center = CGPoint(x: centerButton.center.x, y: centerButton.center.y)
        
        view.addSubview(transcribeButton)
        view.addSubview(liveButton)
        view.addSubview(centerButton)
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
    
    @objc fileprivate func messageItemAction(){
        debugLog("messageItemAction - 消息")
        let messageVC = MessageViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }

}

// MARK:- 动画按钮点击事件
extension HomeViewController {
    
    @objc fileprivate func centerButtonClick(sender : CicleButton){
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == false{
            
            /// 中间按钮旋转
            animationModel.rorateAnimation(holdView: sender, duration: duration, fromValue: M_PI / 4, toValue: 0)
            
            /// firstButton
            animationModel.animationandView(direction: .minus, view: transcribeButton, rect: transcribeButton.frame, duration: duration, startPoint: transcribeButtonEndPoint, endPoint: transcribeButtonStartPoint, controlPoint: transcribeButtonControlPoint, finishBlock: {
                self.istranscribeButtonStart = false
            })
            
            /// liveButton
            animationModel.animationandView(direction: .minus, view: liveButton, rect: liveButton.frame, duration: duration, startPoint: liveButtonEndPoint, endPoint: liveButtonStartPoint, controlPoint: liveButtonControlPoint, finishBlock: {
                self.isliveButtonStart = false
            })
            
        }else{
            
            /// 中间按钮旋转
            animationModel.rorateAnimation(holdView: sender, duration: duration, fromValue: 0, toValue: M_PI / 4)
            
            /// firstButton
            transcribeButtonStartPoint = centerButton.center
            transcribeButtonEndPoint = CGPoint(x: centerButton.center.x, y: centerButton.frame.origin.y - centerButton.frame.height)
            transcribeButtonControlPoint = CGPoint(x: centerButton.frame.origin.x - transcribeButton.frame.width, y: centerButton.frame.origin.y - 20)
            animationModel.animationandView(direction: .plus, view: transcribeButton, rect: transcribeButton.frame, duration: duration, startPoint: transcribeButtonStartPoint, endPoint: transcribeButtonEndPoint, controlPoint: transcribeButtonControlPoint, finishBlock: {
                self.istranscribeButtonStart = true
            })
            
            /// liveButton
            liveButtonStartPoint = centerButton.center
            liveButtonEndPoint = CGPoint(x: centerButton.frame.origin.x - liveButton.frame.width, y: centerButton.center.y)
            liveButtonControlPoint = CGPoint(x: centerButton.frame.origin.x - 20, y: centerButton.frame.maxY + liveButton.frame.height)
            
            animationModel.animationandView(direction: .plus, view: liveButton, rect: liveButton.frame, duration: duration, startPoint: liveButtonStartPoint, endPoint: liveButtonEndPoint, controlPoint: liveButtonControlPoint, finishBlock: {
                self.isliveButtonStart = true
            })
        }
        
    }
    
    fileprivate func recoverActiion(){
        centerButton.isSelected = false
        animationModel.rorateAnimation(holdView: centerButton, duration: duration, fromValue: M_PI / 4, toValue: 0)
        transcribeButton.center = transcribeButtonStartPoint
        liveButton.center = liveButtonStartPoint

    }
    
    @objc fileprivate func transcribeButtonClick(sender : CicleButton){
        SVProgressHUD.show()
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        SVProgressHUD.setDefaultStyle(.light)
        print("firstButtonClick")
        recoverActiion()
        baseVM.iPhoneStatus({ 
            SVProgressHUD.dismiss()
            let model = self.baseVM.phoneStatusModel
            if model.ident_status == "0"{
                // 创建
                let alertController = UIAlertController(title: "", message: "录制和上传视频需要绑定手机哦", preferredStyle:.alert)
                
                // 设置2个UIAlertAction
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "去绑定", style: .default) { (UIAlertAction) in
                    print("点击了好的")
                }
                
                // 添加
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                // 弹出
                self.present(alertController, animated: true, completion: nil)
            }
        }) { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }
        
//        baseVM.iPhoneStatus {
//
//        
//        }
    }
    
    @objc fileprivate func liveButtonClick(sender : CicleButton){
        print("liveButtonClick")
        SVProgressHUD.show()
        recoverActiion()
        baseVM.iPhoneStatus({ 
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultStyle(.light)
            let model = self.baseVM.phoneStatusModel
            if model.ident_status == "0"{
                // 创建
                let alertController = UIAlertController(title: "", message: "需要绑定手机,并完成实名认证才能开启直播,成为斗鱼新秀仅一步之遥哟", preferredStyle:.alert)
                
                // 设置2个UIAlertAction
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (UIAlertAction) in
                })
                let okAction = UIAlertAction(title: "去绑定", style: .default) { (UIAlertAction) in
                    print("点击了好的")
                }
                
                // 添加
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                
                // 弹出
                self.present(alertController, animated: true, completion: nil)
            }
        }) { (message) in
            SVProgressHUD.showInfo(withStatus: message)
        }
    }
}

// MARK:- 代理
extension HomeViewController : AnimationModelDelegate{
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if flag && istranscribeButtonStart {
            transcribeButton.center = transcribeButtonEndPoint
        }else{
            transcribeButton.center = transcribeButtonStartPoint
        }
        
        if flag && isliveButtonStart {
            liveButton.center = liveButtonEndPoint
        }else{
            liveButton.center = liveButtonStartPoint
        }
        
        //        centerButton.layer.removeAllAnimations()
        transcribeButton.layer.removeAllAnimations()
        liveButton.layer.removeAllAnimations()
    }
    
}
