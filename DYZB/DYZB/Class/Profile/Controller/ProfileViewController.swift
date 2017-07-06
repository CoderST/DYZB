//
//  ProfileViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
fileprivate let headViewHeight : CGFloat = sScreenW * 5 / 6
fileprivate let cicleButtonWH : CGFloat = 55
fileprivate let ProfileCellIdentifier  = "ProfileCellIdentifier"
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
        headView.frame = CGRect(x: 0, y: -headViewHeight, width: sScreenW, height: headViewHeight)
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
        collectionView.contentInset = UIEdgeInsets(top: headViewHeight, left: 0, bottom: 0, right: 0)

        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        
        // 注册cell
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCellIdentifier)
        
        return collectionView;
        
        }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationModel.delegate = self
        
        setupUI()
        
//        setupProfileDatas()
        
        baseViewModel.updateDate {
            self.setupProfileDatas()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
        
        baseViewModel.updateDate {
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
}


// MARK:- 设置UI
extension ProfileViewController {
    
    fileprivate func setupUI() {
        // 添加collectionView
        view.addSubview(collectionView)
        // 添加collectionView上面的headView
        collectionView.addSubview(headView)
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
    
    @objc fileprivate func transcribeButtonClick(sender : CicleButton){
        
        print("firstButtonClick")
    }
    
    @objc fileprivate func liveButtonClick(sender : CicleButton){
        print("secondButtonClick")
    }
}


extension ProfileViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return profileVM.groupDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let group = profileVM.groupDatas[section]
        return group.groupModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellIdentifier, for: indexPath) as! ProfileCell
        let group = profileVM.groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        cell.profileModel = profileModel
        return cell
    }
}

extension ProfileViewController : UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugLog(scrollView.contentOffset.y)
        // 禁止下拉
        if scrollView.contentOffset.y <= -headViewHeight {
            scrollView.contentOffset.y = -headViewHeight
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = profileVM.groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        if let desVC = profileModel.targetClass as? UIViewController.Type {
            let vc = desVC.init()
            
//            print("navigationController =",navigationController)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 组间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
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

