//
//  ProfileInforViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/9.
//  Copyright © 2017年 xiudo. All rights reserved.
//  我的详情页面

import UIKit
import SVProgressHUD
import TZImagePickerController
let BasicSettingCellIdentifier = "BasicSettingCellIdentifier"
let headImageCellHeight : CGFloat = 60
let normalCellHeight : CGFloat = 44
class ProfileInforViewController: BaseViewController {
    
    fileprivate var user : User?{
        
        didSet{
            
            guard let user = user else { return }
            
            //            if let user = user {
            groups.removeAll()
            profileInforDataFrameModel = ProfileInforDataFrameModel(user: user)
            // 第一组
            setuoGroupOne(profileInforDataFrameModel)
            // 第二组
            setuoGroupTwo(profileInforDataFrameModel)
            // 第三组
            setuoGroupThree(profileInforDataFrameModel)
            
            endAnimation()
            
            collectionView.reloadData()
            //            }
            
        }
    }
    var profileInforDataFrameModel : ProfileInforDataFrameModel!
    
    fileprivate lazy var profileInforVM : ProfileInforVM = ProfileInforVM()
    
    lazy var groups : [SettingGroup] = [SettingGroup]()
    
    lazy var collectionView : UICollectionView = {
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
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        baseContentView = collectionView
        view.addSubview(collectionView)
        
        super.viewDidLoad()
        
        title = "个人信息"
        
        //  请求一下最新数据
        setupData()
        
        // 接收通知
       notificationCenter.addObserver(self, selector: #selector(reLoadProfileInforData), name: NSNotification.Name(rawValue: sNotificationName_ReLoadProfileInforData), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    deinit {
        debugLog("ProfileInforViewController -- 销毁")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugLog("viewWillAppear")
    }
}

// MARK:- 获取数据
extension ProfileInforViewController {
    fileprivate func setupData(){
        
        profileInforVM.loadProfileInforDatas({
            self.user = self.profileInforVM.user
        }, { (message) in
            
        }) {
            
        }
        
    }
}

// MARK:- 创建组
extension ProfileInforViewController {
    
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
            let photographAction = UIAlertAction(title: "拍照", style: .default, handler: { (alertAction) in
                
            })
            let photoAlbumAction = UIAlertAction(title: "从相册选择", style: .default, handler: { (alertAction) in
                guard let imagePickerVc = TZImagePickerController(maxImagesCount: 1, delegate: self) else { return }
                imagePickerVc.sortAscendingByModificationDate = false
                imagePickerVc.photoWidth = 1024.0
                imagePickerVc.photoPreviewMaxWidth = 3072.0
                self?.navigationController?.present(imagePickerVc, animated: true, completion: nil)
            })
            
            // 添加到UIAlertController
            alertController.addAction(cancelAction)
            alertController.addAction(photoAlbumAction)
            alertController.addAction(photographAction)
            
            // 弹出
            self?.present(alertController, animated: true, completion: nil)
            
        }
        avaModel.optionHeight = {
            return headImageCellHeight
        }
        
        /// 昵称
        let nickNameModel = ArrowItem(icon: "", title: "昵称", subtitle: profileInforDataFrameModel.nickname, VcClass: TestViewController.self)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        /// 性别
        let sexModel = ArrowItem(icon: "", title: "性别", subtitle: profileInforDataFrameModel.sexString, VcClass: nil)
        let sexModelFrame = SettingItemFrame(sexModel)
        sexModel.optionHandler = {[weak self] in
            // preferredStyle 为 ActionSheet
            let alertController = UIAlertController(title: "上传头像", message: nil, preferredStyle:.actionSheet)
            
            // 设置2个UIAlertAction
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let womanAction = UIAlertAction(title: "女", style: .default, handler: { (alertAction) in
                self?.profileInforVM.loadSexProfileInforDatas(sexString: "2", {
                    SVProgressHUD.showSuccess(withStatus: "成功")
                    // 再次请求个人详情的数据
//                    self?.profileInforVM.loadProfileInforDatas({
//                        self?.user = self?.profileInforVM.user
//                    }, { (message) in
//                        
//                    }, {
//                        
//                    })
                    self?.reLoadProfileInforData()
                }, { (message) in
                    SVProgressHUD.showInfo(withStatus: message)
                }, {
                    SVProgressHUD.showError(withStatus: "")
                })
            })
            let manAction = UIAlertAction(title: "男", style: .default, handler: { (alertAction) in
                self?.profileInforVM.loadSexProfileInforDatas(sexString: "1", {
                    
                    // 再次请求个人详情的数据
                    self?.reLoadProfileInforData()
//                    self?.profileInforVM.loadProfileInforDatas({
//                        self?.user = self?.profileInforVM.user
//                        SVProgressHUD.showSuccess(withStatus: "成功")
//                    }, { (message) in
//                        
//                    }, {
//                        
//                    })
                }, { (message) in
                    SVProgressHUD.showInfo(withStatus: message)
                }, {
                    SVProgressHUD.showError(withStatus: "")
                })
            })
            
            // 添加到UIAlertController
            alertController.addAction(cancelAction)
            alertController.addAction(manAction)
            alertController.addAction(womanAction)
            
            // 弹出
            self?.present(alertController, animated: true, completion: nil)
        }
        
        /// 生日
        let birthDayModel = ArrowItem(icon: "", title: "生日", subtitle: profileInforDataFrameModel.birthdayString, VcClass: nil)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        birthDayModel.optionHandler = {
            guard let birthdayString = self.user?.birthday else { return }
            guard let date = Date.dateFromString("yyyyMMdd", birthdayString) else { return }
            let showDate = DatePackerView(frame: self.view.bounds, date)
            showDate.showDatePicker(self.view)
            showDate.delegate = self
        }
        
        /// 所在地
        let locationModel = ArrowItem(icon: "", title: "所在地", subtitle: profileInforDataFrameModel.locationString, VcClass: LocationViewController.self)
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
        let nickNameModel = ArrowItem(icon: "", title: "密码", subtitle: profileInforDataFrameModel.passWord, VcClass: MyTaskViewController.self)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        // 如果邮箱有值则不能跳转  没哟值则跳转绑定
        var sexModel : SettingItem!
        if profileInforDataFrameModel.emailString.characters.count > 0{
            sexModel = SettingItem(icon: "", title: "邮箱", subTitle: profileInforDataFrameModel.emailString)
        }else{
            
            sexModel = ArrowItem(icon: "", title: "邮箱", subtitle: profileInforDataFrameModel.emailString, VcClass: TestViewController.self)
        }
        let sexModelFrame = SettingItemFrame(sexModel)
        
        let birthDayModel = ArrowItem(icon: "", title: "手机", subtitle: profileInforDataFrameModel.mobile_phoneString, VcClass: IPhoneBindingViewController.self)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        
        let locationModel = ArrowItem(icon: "", title: "QQ", subtitle: profileInforDataFrameModel.qq, VcClass: BindQQViewController.self)
        let locationModelFrame = SettingItemFrame(locationModel)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [avaModelFrame,nickNameModelFrame,sexModelFrame,birthDayModelFrame,locationModelFrame]
        
        groups.append(settingGroup)
    }
    
    fileprivate func setuoGroupThree(_ profileInforDataFrameModel : ProfileInforDataFrameModel){
        
        let  nickNameModel = SettingItem(icon: "", title: "经验值", subTitle: profileInforDataFrameModel.empiricalValue)
        let nickNameModelFrame = SettingItemFrame(nickNameModel)
        
        let sexModel = SettingItem(icon: "", title: "鱼丸", subTitle: profileInforDataFrameModel.fishBall)
        let sexModelFrame = SettingItemFrame(sexModel)
        
        let birthDayModel = ArrowItem(icon: "", title: "鱼翅", subtitle: profileInforDataFrameModel.fin, VcClass: FishboneRechargeViewController.self)
        let birthDayModelFrame = SettingItemFrame(birthDayModel)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [nickNameModelFrame,sexModelFrame,birthDayModelFrame]
        
        groups.append(settingGroup)
    }
}

extension ProfileInforViewController {
    
    @objc fileprivate func reLoadProfileInforData(){
            // 再次请求个人详情的数据
            profileInforVM.loadProfileInforDatas({
                self.user = self.profileInforVM.user
            }, { (message) in
                
            }, {
                
            })
        }

    }


// MARK:- UICollectionViewDataSource
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
        return cell
    }
}
// MARK:- UICollectionViewDelegateFlowLayout
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
            // 修改密码
            if desVC is MyTaskViewController{
                let desvc = desVC as! MyTaskViewController
                desvc.open_url = "http://www.douyu.com/api/v1/change_password?client_sys=ios&token=\(TOKEN)&auth=\(AUTH)"
            }
            
            // QQ 
            if desVC is BindQQViewController{
                let desvc = desVC as! BindQQViewController
                
                desvc.completeButtonValue(completeButtoncallBack: { (isok) in
                    // 刷新页面
                    self.reLoadProfileInforData()
                })
            }
            desVC.title = arrowItem.title
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
// MARK:- TZImagePickerControllerDelegate
extension ProfileInforViewController : TZImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!){
        guard let image = photos.first else { return }
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.3) else { return }
        debugLog(imageData)
        profileInforVM.loadUpImageProfileInforDatas(imageData: imageData, {
            
        }, { (message) in
            
        }) {
            
        }
    }
}

extension ProfileInforViewController : DatePackerViewDelegate {
    
    func datePackerView(_ datePackerView: DatePackerView, indexItem: String) {
        print(indexItem)
        profileInforVM.loadBirthDayProfileInforDatas(birthDay: indexItem, {
            self.reLoadProfileInforData()
        }, { (message) in
            
        }) { 
            
        }
    }
}
