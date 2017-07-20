//
//  CountryViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let CountryVCCellIdentifier = "CountryVCCellIdentifier"
fileprivate let CountryVCSectionViewIdentifier = "CountryVCSectionViewIdentifier"

protocol CountryViewControllerDelegate : class {
    func countryViewController(_ countryViewController: CountryViewController, didSelectModel countryModel: CountryModel)
}

class CountryViewController: UIViewController {

    weak var delegate : CountryViewControllerDelegate?
    
    fileprivate lazy var countryViewModel : CountryViewModel = CountryViewModel.shareCountryVM
    
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = XDPlanFlowLayout()
        layout.naviHeight = 0
        let width = sScreenW
        layout.itemSize = CGSize(width: width, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:sStatusBarH + sNavatationBarH, width: sScreenW, height: sScreenH - (sStatusBarH + sNavatationBarH)), collectionViewLayout: layout)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        layout.headerReferenceSize = CGSize(width: sScreenW, height: 20)
        // 设置数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(r: 231, g: 231, b: 231)
        
        // 注册cell
        collectionView.register(CountryVCCell.self, forCellWithReuseIdentifier: CountryVCCellIdentifier)
        collectionView.register(CountryVCSectionView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CountryVCSectionViewIdentifier)
        return collectionView;
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        setupData()
    }
}

extension CountryViewController {
    
    fileprivate func setupUI(){
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
    }
}

extension CountryViewController {
    
    fileprivate func setupData() {
        countryViewModel.loadCountryDatas({ 
            self.collectionView.reloadData()
        }, { (message) in
            
        }) { 
            
        }
        
    }
}


extension CountryViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        
        return countryViewModel.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        let group = countryViewModel.groups[section]
        return group.group.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryVCCellIdentifier, for: indexPath) as! CountryVCCell
        cell.countryModel = countryViewModel.groups[indexPath.section].group[indexPath.item]
        return cell
    }
}

extension CountryViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        // 1.取出section的HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CountryVCSectionViewIdentifier, for: indexPath) as!CountryVCSectionView
     
        headerView.title = countryViewModel.groups[indexPath.section].sectionTitle
        return headerView

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let group = countryViewModel.groups[indexPath.section]
        let model = group.group[indexPath.item]
        delegate?.countryViewController(self, didSelectModel: model)
        navigationController?.popViewController(animated: true)
    }
}
