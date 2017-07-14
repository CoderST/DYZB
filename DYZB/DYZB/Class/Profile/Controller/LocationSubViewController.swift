//
//  LocationSubViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/13.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
class LocationSubViewController: UIViewController {
    
    /// 省会model
    var locationModel : LocationModel = LocationModel()
    
    fileprivate lazy var locationSubVM : LocationSubVM = LocationSubVM()
    
    fileprivate lazy var collectionView : STCollectionView = STCollectionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    deinit {
        debugLog("LocationSubViewController -- 销毁")
    }
}

extension LocationSubViewController {
    
    func setupUI(){
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension LocationSubViewController : STCollectionViewDataSource{
    
    func collectionViewTitleInRow(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> String {
        let model = locationModel.city[indexPath.item]
        return model.name
        
    }

    func collectionView(_ stCollectionView: STCollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationModel.city.count
    }
    
    func isHiddenArrowImageView(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> Bool {
        // 没有下级页面 全部隐藏
        return true
    }
}

extension LocationSubViewController : STCollectionViewDelegate {
    
    func stCollection(_ stCollectionView: STCollectionView, didSelectItemAt indexPath: IndexPath) {
        let locationSubModel = locationModel.city[indexPath.item]
//        let city = model.name
        /** http://capi.douyucdn.cn/api/v1/set_userinfo_custom?aid=ios&client_sys=ios&time=1499930940&auth=3d4bf3c09cfd003962eb3394dffb3617
         location 蚌埠 13,12
         */
        let proID = locationModel.code  // 省会ID
        let cityID = locationSubModel.code  // 市区ID
        var ID  : String = ""
        if locationModel.city.count > 0{
          ID = String(format: "%d,%d",proID,cityID)
        }else{
            ID = "\(proID)"
        }
        locationSubVM.upLoadLocationDatas(ID, {
             notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_ReLoadProfileInforData), object: nil, userInfo: nil)
            self.popAction()
        }, { (message) in
             SVProgressHUD.showInfo(withStatus: message)
        }) { 
            
        }
        
        
    }
    
    fileprivate func popAction(){
        
        // 在请求回调成功里pop到个人信息(ProfileInforViewController)指定控制器
        for i in 0..<(navigationController?.viewControllers.count)! {
            
            if self.navigationController?.viewControllers[i].isKind(of: ProfileInforViewController.self) == true {
                
                _ = navigationController?.popToViewController(navigationController?.viewControllers[i] as! ProfileInforViewController, animated: true)
                break
            }
        }
    }
}
