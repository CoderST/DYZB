//
//  LocationViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
class LocationViewController: UIViewController {
    
    fileprivate lazy var locationVM : LocationVM = LocationVM()
    
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
    func numberOfRowsInSTCollectionView(_ collectionView: STCollectionView) -> NSInteger {
        
        return locationVM.locationModelArray.count
    }
    
    func collectionViewTitleInRow(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> String {
        let model = locationVM.locationModelArray[indexPath.item]
        return model.State
        
    }
    
    func isHiddenArrowImageView(_ collectionView: STCollectionView, _ indexPath: IndexPath) -> Bool {
        let model = locationVM.locationModelArray[indexPath.item]
        if model.Cities.count > 0 {
            return false
        }else{
            
            return true
        }
    }
}

extension LocationViewController : STCollectionViewDelegate {
    
    func stCollection(_ stCollectionView: STCollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = locationVM.locationModelArray[indexPath.item]
        let cities = model.Cities
        
        let locationSubVC = LocationSubViewController()
        locationSubVC.cities = cities
        navigationController?.pushViewController(locationSubVC, animated: true)
    }
}
