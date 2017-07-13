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
    
    var cities : [LocationSubModel] = [LocationSubModel]()
    
    
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
    func numberOfRowsInSTCollectionView(_ collectionView: STCollectionView) -> NSInteger {
        
        return cities.count
    }
    
    func collectionViewTitleInRow(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> String {
        let model = cities[indexPath.item]
        return model.city
        
    }
    
    func isHiddenArrowImageView(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> Bool {
        return true
    }
}

extension LocationSubViewController : STCollectionViewDelegate {
    
    func stCollection(_ stCollectionView: STCollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = cities[indexPath.item]
        let city = model.city
        /** http://capi.douyucdn.cn/api/v1/set_userinfo_custom?aid=ios&client_sys=ios&time=1499930940&auth=3d4bf3c09cfd003962eb3394dffb3617
         location 蚌埠 13,12
         要更改plist
         
         */
        debugLog(city)
        SVProgressHUD.showInfo(withStatus: city)
        
        // 在请求回调成功里pop到个人信息(ProfileInforViewController)指定控制器
        for i in 0..<(navigationController?.viewControllers.count)! {
            
            if self.navigationController?.viewControllers[i].isKind(of: ProfileInforViewController.self) == true {
                
                _ = navigationController?.popToViewController(navigationController?.viewControllers[i] as! ProfileInforViewController, animated: true)
                break
            }            
        }
    }
}
