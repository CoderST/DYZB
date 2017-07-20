//
//  ProfileViewModel.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

fileprivate let ProfileCellIdentifier  = "ProfileCellIdentifier"
let profileHeadViewHeight : CGFloat = sScreenW * 5 / 6
class ProfileViewModel: NSObject,ViewModelProtocol {

    var user : User?
    
    // 本地cell数据数组
    var groupDatas : [ProfileGroupModel] = [ProfileGroupModel]()
    
    // 获取最新请求时间
    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    
    func loadProfileDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        let group = DispatchGroup()
        group.enter()
        // 第一组数据
        let recruit = ProfileModel(imageName: "image_my_recruitment", titleName: "主播招募", subTitleName: "", targetClass: MyTaskViewController.self)
        let groupOne = ProfileGroupModel()
        groupOne.groupModels = [recruit]
        
        // 第二组数据
        let myVideo = ProfileModel(imageName: "image_my_video_icon", titleName: "我的视频", subTitleName: "", targetClass: RecruitViewController.self)
        let videoCollect = ProfileModel(imageName: "image_my_video_collection", titleName: "视频收藏", subTitleName: "", targetClass: RecruitViewController.self)
        let groupTwo = ProfileGroupModel()
        groupTwo.groupModels = [myVideo,videoCollect]
        
        // 第三组数据
        let myAccount = ProfileModel(imageName: "image_my_account", titleName: "我的账户", subTitleName: "", targetClass: MyAccountViewController.self)
        let platCenter = ProfileModel(imageName: "image_my_recommend", titleName: "游戏中心", subTitleName: "", targetClass: GameCenterViewController.self)
        let groupThree = ProfileGroupModel()
        groupThree.groupModels = [myAccount,platCenter]
        
        // 第四组数据
        let remind = ProfileModel(imageName: "image_my_remind", titleName: "开播提醒", subTitleName: "", targetClass: RecruitViewController.self)
        let groupFour = ProfileGroupModel()
        groupFour.groupModels = [remind]
        
        groupDatas = [groupOne,groupTwo,groupThree,groupFour]

        group.leave()
        
//        let now = Date()
//        //当前时间的时间戳
//        let timeInterval:TimeInterval = now.timeIntervalSince1970
//        let timeStamp = Int(timeInterval)
        /*
         posid	800001
         roomid	0
         */
        let params = ["token" : TOKEN]
        let URLString = String(format: "http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=%@&auth=%@", Date.getNowDate(),AUTH)
        group.enter()
        NetworkTools.requestData(.post, URLString: URLString, parameters: params) { (result) in
            guard let result = result as? [String : Any] else {
                failCallBack()
                return }
            
            guard let error = result["error"] as? Int else{
                failCallBack()
                return }
            
            if error != 0 {
                group.leave()
                debugLog(result)
                failCallBack()
                return
            }
            guard let dict = result["data"] as? [String : Any] else {
                failCallBack()
                return }
            self.user = User(dict: dict)
            debugLog(dict)
            group.leave()
            finishCallBack()
        }

    }

    // MARK:- 绑定
    func bindViewModel(bindView: UIView) {
        if bindView is UICollectionView{
            let collectionView = bindView as! UICollectionView
            collectionView.dataSource = self
            collectionView.delegate = self
            // 注册cell
            collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCellIdentifier)
        }
    }
}

extension ProfileViewModel : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return groupDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let group = groupDatas[section]
        return group.groupModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellIdentifier, for: indexPath) as! ProfileCell
        let group = groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        cell.profileModel = profileModel
        return cell
    }
}

extension ProfileViewModel : UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugLog(scrollView.contentOffset.y)
        // 禁止下拉
        if scrollView.contentOffset.y <= -profileHeadViewHeight {
            scrollView.contentOffset.y = -profileHeadViewHeight
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        if let desVC = profileModel.targetClass as? UIViewController.Type {
            let vc = desVC.init()
            
            if vc is MyTaskViewController {
                let desvc = vc as!MyTaskViewController
                // 获取时间
                baseViewModel.updateDate {
                    guard let time = userDefaults.object(forKey: dateKey) as? Int else { return }
                    let url = "http://www.douyu.com/h5mobile/welcome/jump/5?aid=ios&client_sys=ios&time=\(time)&token=\(TOKEN)&auth=\(AUTH)"
                    desvc.open_url = url
                    getNavigation().pushViewController(vc, animated: true)
                }

                
            }else{
                
                getNavigation().pushViewController(vc, animated: true)
            }
            
        }
    }
    
    // 组间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }
}
