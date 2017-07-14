//
//  LocationViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
class LocationViewController: UIViewController {
    
    fileprivate lazy var locationVM : LocationVM = LocationVM()
    fileprivate lazy var locationSubVM : LocationSubVM = LocationSubVM()
    
    fileprivate lazy var collectionView : STCollectionView = STCollectionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupData()
        
    }
    
    deinit {
        debugLog("LocationViewController -- 销毁")
    }
}

extension LocationViewController {
    
    fileprivate func setupUI(){
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension LocationViewController {
    
    fileprivate func setupData(){
        locationVM.loadLocationDatas({
        }, { (message) in
            
        }) {
            
        }
    }
}

extension LocationViewController : STCollectionViewDataSource{
    
    func numberOfSections(in stCollectionView: STCollectionView) -> Int {
        
        let sectionCount = locationVM.locationModelGroups.count
        
        return sectionCount
    }
    
    
    func collectionView(_ stCollectionView: STCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let group = locationVM.locationModelGroups[section]
        
        return group.locationModelGroup.count
    }
    
    func collectionViewTitleInRow(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> String {

        let group = locationVM.locationModelGroups[indexPath.section]
        
        let model = group.locationModelGroup[indexPath.item]
        
        return model.name
    }
    
    func isHiddenArrowImageView(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> Bool {
        let group = locationVM.locationModelGroups[indexPath.section]
        
        let model = group.locationModelGroup[indexPath.item]

        if model.city.count > 0 {
            return false
        }else{
            
            return true
        }
    }
}

extension LocationViewController : STCollectionViewDelegate {
    
    func stCollection(_ stCollectionView: STCollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = locationVM.locationModelGroups[indexPath.section]
        
        let locationModel = group.locationModelGroup[indexPath.item]

        let locationSubVC = LocationSubViewController()
        if locationModel.city.count > 0 {
            locationSubVC.locationModel = locationModel
            navigationController?.pushViewController(locationSubVC, animated: true)
        }else{
            
            let proID = locationModel.code  // 省会ID
            locationSubVM.upLoadLocationDatas("\(proID)", {
                notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_ReLoadProfileInforData), object: nil, userInfo: nil)
                self.navigationController?.popViewController(animated: true)
            }, { (message) in
                SVProgressHUD.showInfo(withStatus: message)
            }) { 
                
            }

        }
    }
    
 
    func stCollectionHeadInSection(_ stCollectionView: STCollectionView, at indexPath: IndexPath) -> String {
        let group = locationVM.locationModelGroups[indexPath.section]
        return group.headString
    }
}
