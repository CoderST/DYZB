//
//  ProfileViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
import FDFullscreenPopGesture
fileprivate let cicleButtonWH : CGFloat = 55
class ProfileViewController: UIViewController {
    
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
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    fileprivate lazy var headView : ProfileHeadView = {
        
        let headView = ProfileHeadView()
        headView.frame = CGRect(x: 0, y: -profileHeadViewHeight, width: sScreenW, height: profileHeadViewHeight)
        return headView
        
    }()
    
    fileprivate lazy var profileVM : ProfileViewModel = ProfileViewModel()
    
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:0, width: sScreenW, height: sScreenH), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: profileHeadViewHeight, left: 0, bottom: 0, right: 0)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)

        return collectionView;
        
    }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationModel.delegate = self
        /// 三方设置隐藏
        navigationController?.fd_prefersNavigationBarHidden = true
        
        setupUI()
        
        baseViewModel.updateDate {
            self.setupProfileDatas()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 下面这种方式隐藏会出现BUG 用带animated的方式隐藏
        // [self.navigationController setNavigationBarHidden:YES animated:animated];
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        baseViewModel.updateDate {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 下面这种方式隐藏会出现BUG 用带animated的方式隐藏
//        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}


// MARK:- 设置UI
extension ProfileViewController {
    
    fileprivate func setupUI() {
        
        // 添加collectionView
        view.addSubview(collectionView)
        
        // 绑定
        profileVM.bindViewModel(bindView: collectionView)
        
        // 添加collectionView上面的headView
        collectionView.addSubview(headView)
        
        // 设置动画右下角按钮
        setupAnimationButton()
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

// MARK:- 主数据
extension ProfileViewController {
    // 本地数据
    fileprivate func setupProfileDatas(){
        
        profileVM.loadProfileDatas({
            if let user = self.profileVM.user{
                self.headView.user = user
            }
            self.collectionView.reloadData()
        }, { (message) in
            debugLog(message)
        }) {
            debugLog("失败")
        }
    }
    
}

// MARK:- 点击事件
extension ProfileViewController {
    
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
        print("firstButtonClick")
        recoverActiion()
        baseViewModel.iPhoneStatus({ 
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultStyle(.light)
            let model = self.baseViewModel.phoneStatusModel
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
    }
    
    @objc fileprivate func liveButtonClick(sender : CicleButton){
        print("secondButtonClick")
        SVProgressHUD.show()
        recoverActiion()
        baseViewModel.iPhoneStatus({ 
            SVProgressHUD.dismiss()
            SVProgressHUD.setDefaultStyle(.light)
            let model = self.baseViewModel.phoneStatusModel
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
extension ProfileViewController : AnimationModelDelegate{
    
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

