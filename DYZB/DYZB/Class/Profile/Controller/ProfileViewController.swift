//
//  ProfileViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
fileprivate let headViewHeight : CGFloat = sScreenW * 2 / 3
fileprivate let ProfileCellIdentifier  = "ProfileCellIdentifier"
class ProfileViewController: UIViewController {
    
    // MARK:- 懒加载
    fileprivate let headView : ProfileHeadView = {
       
        let headView = ProfileHeadView()
        headView.backgroundColor = UIColor.yellow
        headView.frame = CGRect(x: 0, y: -headViewHeight, width: sScreenW, height: headViewHeight)
        return headView
        
    }()
    
    fileprivate var groupDatas : [ProfileGroupModel] = [ProfileGroupModel]()
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sScreenW, height: 44)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:-20, width: sScreenW, height: sScreenH), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: headViewHeight, left: 0, bottom: 0, right: 0)

        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        
        // 注册cell
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCellIdentifier)
        
        return collectionView;
        
        }()
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true
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
    }
}

// MARK:- 主数据
extension ProfileViewController {
    fileprivate func setupDatas(){
        // 第一组数据
        let recruit = ProfileModel(imageName: "image_my_recruitment", titleName: "主播招募", subTitleName: "", targetClass: RecruitViewController.self)
        let groupOne = ProfileGroupModel()
        groupOne.groupModels = [recruit]
        
        // 第二组数据
        let myVideo = ProfileModel(imageName: "image_my_video_icon", titleName: "我的视频", subTitleName: "", targetClass: RecruitViewController.self)
        let videoCollect = ProfileModel(imageName: "image_my_video_collection", titleName: "视频收藏", subTitleName: "", targetClass: RecruitViewController.self)
        let groupTwo = ProfileGroupModel()
        groupTwo.groupModels = [myVideo,videoCollect]
        
        // 第三组数据
        let myAccount = ProfileModel(imageName: "image_my_account", titleName: "我的账户", subTitleName: "", targetClass: RecruitViewController.self)
        let platCenter = ProfileModel(imageName: "image_my_recommend", titleName: "游戏中心", subTitleName: "", targetClass: RecruitViewController.self)
        let groupThree = ProfileGroupModel()
        groupThree.groupModels = [myAccount,platCenter]
        
        // 第四组数据
        let remind = ProfileModel(imageName: "image_my_remind", titleName: "开播提醒", subTitleName: "", targetClass: RecruitViewController.self)
        let groupFour = ProfileGroupModel()
        groupFour.groupModels = [remind]
        
        groupDatas = [groupOne,groupTwo,groupThree,groupFour]
        
        collectionView.reloadData()
    }
}


extension ProfileViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return groupDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let group = groupDatas[section]
        
        return group.groupModels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCellIdentifier, for: indexPath) as! ProfileCell
        cell.contentView.backgroundColor = UIColor.gray
        let group = groupDatas[indexPath.section]
        let profileModel = group.groupModels[indexPath.item]
        cell.profileModel = profileModel
        return cell
    }
}

extension ProfileViewController : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("contentOffsetY",scrollView.contentOffset.y)
        // 禁止下拉
        if scrollView.contentOffset.y <= -headViewHeight {
            scrollView.contentOffset.y = -headViewHeight
        }
        // 禁止上拉
//        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
//            scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.size.height
//        }  
    }
}

extension ProfileViewController {
    
    func test() {
        
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        /*
         posid	800001
         roomid	0
         */
        let params = ["posid" : 800001]
        let URLString = String(format: "http://capi.douyucdn.cn/api/v1/my_info?aid=ios&client_sys=ios&time=%d&auth=%@", timeStamp,AUTH)
        NetworkTools.requestData(.post, URLString: URLString, parameters: params) { (result) in
            guard let result = result as? [String : Any] else { return }
            
            guard let error = result["error"] as? Int else { return }
            
            if error != 0 {
                print("广告有错误,待处理!!",result)
            }
            
        }
    }
}
