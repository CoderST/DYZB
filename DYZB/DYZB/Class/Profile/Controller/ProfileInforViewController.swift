//
//  ProfileInforViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/9.
//  Copyright © 2017年 xiudo. All rights reserved.
//  我的详情页面

import UIKit
let BasicSettingCellIdentifier = "BasicSettingCellIdentifier"
let headImageCellHeight : CGFloat = 60
let normalCellHeight : CGFloat = 44
class ProfileInforViewController: BaseViewController {
    
    var user : User?
    var profileInforDataFrameModel : ProfileInforDataFrameModel!
    
    
    fileprivate lazy var groups : [SettingGroup] = [SettingGroup]()
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:sStatusBarH + sNavatationBarH, width: sScreenW, height: sScreenH - (sStatusBarH + sNavatationBarH)), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        collectionView.register(BasicSettingCell.self, forCellWithReuseIdentifier: BasicSettingCellIdentifier)
        return collectionView;
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        baseContentView = collectionView
        
        view.addSubview(collectionView)
        
        if let user = user {
            
            profileInforDataFrameModel = ProfileInforDataFrameModel(user: user)
            // 第一组
            setuoGroupOne(profileInforDataFrameModel)
            // 第二组
            setuoGroupTwo(profileInforDataFrameModel)
            // 第三组
            setuoGroupThree(profileInforDataFrameModel)
            
            endAnimation()
            
            collectionView.reloadData()
        }

    }
    
    fileprivate func setuoGroupOne(_ profileInforDataFrameModel : ProfileInforDataFrameModel){
        /// 头像
        // 1 创建需要类型的item
        let avaModel = ArrowImageItem(icon: "", title: "头像", rightImageName: profileInforDataFrameModel.avatarName, VcClass: nil)
        // 2 计算出item的frame
        let avaModelFrame = SettingItemFrame(avaModel)
        // 3 是否需要定义特殊处理(有实现,没有不用实现)
        
        avaModel.optionHandler = {[weak self] in
            // 创建
            // preferredStyle 为 ActionSheet
            let alertController = UIAlertController(title: "上传头像", message: nil, preferredStyle:.actionSheet)
            
            // 设置2个UIAlertAction
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let photographAction = UIAlertAction(title: "拍照", style: .default, handler: nil)
            let photoAlbumAction = UIAlertAction(title: "从相册选择", style: .default, handler: nil)
            
            // 添加到UIAlertController
            alertController.addAction(cancelAction)
            alertController.addAction(photoAlbumAction)
            alertController.addAction(photographAction)
            
            // 弹出
            self?.present(alertController, animated: true, completion: nil)

        }
        avaModel.optionHeight = {[weak self] in
            return headImageCellHeight
        }
        
        /// 昵称
        let nickNameModel = ArrowItem(icon: "", title: "昵称", subtitle: profileInforDataFrameModel.nickname, VcClass: TestViewController.self)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        /// 性别
        let sexModel = ArrowItem(icon: "", title: "性别", subtitle: profileInforDataFrameModel.sexString, VcClass: nil)
        let sexModelFrame = SettingItemFrame(sexModel)
        sexModel.optionHandler = {[weak self] in
            print("setuoGroupOne点击了性别")
        }
        
        /// 生日
        let birthDayModel = ArrowItem(icon: "", title: "生日", subtitle: profileInforDataFrameModel.birthdayString, VcClass: nil)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        
        /// 所在地
        let locationModel = ArrowItem(icon: "", title: "所在地", subtitle: profileInforDataFrameModel.locationString, VcClass: nil)
        let locationModelFrame = SettingItemFrame(locationModel)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [avaModelFrame,nickNameModelFrame,sexModelFrame,birthDayModelFrame,locationModelFrame]
        
        groups.append(settingGroup)

        
    }
    
    fileprivate func setuoGroupTwo(_ profileInforDataFrameModel : ProfileInforDataFrameModel){
        let avaModel = ArrowItem(icon: "", title: "实名认证", subtitle: profileInforDataFrameModel.realNameAuthentication, VcClass: nil)
        let avaModelFrame = SettingItemFrame(avaModel)
        avaModel.optionHandler = {[weak self] in
            print("setuoGroupTwo点击了实名认证")
        }
        let nickNameModel = ArrowItem(icon: "", title: "密码", subtitle: profileInforDataFrameModel.passWord, VcClass: TestViewController.self)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        let sexModel = ArrowItem(icon: "", title: "邮箱", subtitle: profileInforDataFrameModel.emailString, VcClass: TestViewController.self)
        let sexModelFrame = SettingItemFrame(sexModel)
        
        let birthDayModel = ArrowItem(icon: "", title: "手机", subtitle: profileInforDataFrameModel.mobile_phoneString, VcClass: TestViewController.self)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        
        let locationModel = ArrowItem(icon: "", title: "QQ", subtitle: profileInforDataFrameModel.qq, VcClass: TestViewController.self)
        let locationModelFrame = SettingItemFrame(locationModel)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [avaModelFrame,nickNameModelFrame,sexModelFrame,birthDayModelFrame,locationModelFrame]
        
        groups.append(settingGroup)
    }
    
    fileprivate func setuoGroupThree(_ profileInforDataFrameModel : ProfileInforDataFrameModel){
  
        let nickNameModel = ArrowItem(icon: "", title: "经验值", subtitle: profileInforDataFrameModel.empiricalValue, VcClass: nil)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        let sexModel = ArrowItem(icon: "", title: "鱼丸", subtitle: profileInforDataFrameModel.fishBall, VcClass: nil)
        let sexModelFrame = SettingItemFrame(sexModel)
        
        let birthDayModel = ArrowItem(icon: "", title: "鱼翅", subtitle: profileInforDataFrameModel.fin, VcClass: TestViewController.self)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [nickNameModelFrame,sexModelFrame,birthDayModelFrame]
        
        groups.append(settingGroup)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLog("viewWillAppear")
    }
}


extension ProfileInforViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let group = groups[section]
        return group.settingGroup.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicSettingCellIdentifier, for: indexPath) as! BasicSettingCell
        let group = groups[indexPath.section]
        let settingItemFrame = group.settingGroup[indexPath.item]
        cell.settingItemFrame = settingItemFrame
//        cell.contentView.backgroundColor = UIColor.randomColor()
        return cell
    }
}

extension ProfileInforViewController : UICollectionViewDelegateFlowLayout {
        
    // 组间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.section]
        let settingItemFrame = group.settingGroup[indexPath.item]
        if settingItemFrame.settingItem.optionHandler != nil {
            settingItemFrame.settingItem.optionHandler!()
        }else if settingItemFrame.settingItem is ArrowItem{
            
            let arrowItem = settingItemFrame.settingItem as! ArrowItem
            guard let desClass = arrowItem.VcClass else { return }
            guard let desVCType = desClass as? UIViewController.Type else { return }
            let desVC = desVCType.init()
            navigationController?.pushViewController(desVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let group = groups[indexPath.section]
        let settingItemFrame = group.settingGroup[indexPath.item]
        if settingItemFrame.settingItem.optionHeight != nil {
            let height = settingItemFrame.settingItem.optionHeight!()
            return CGSize(width: sScreenW, height: height)
        }
        
        return CGSize(width: sScreenW, height: normalCellHeight)
        
    }
}

