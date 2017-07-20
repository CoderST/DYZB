//
//  MyAccountViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//  我的账户

import UIKit

class MyAccountViewController: ProfileInforViewController {

    fileprivate lazy var baseViewModel : BaseViewModel = BaseViewModel()
    override func viewDidLoad() {
//        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(collectionView)
        title = "我的账户"
        // 消费记录
        let cost = ArrowItem(icon: "image_cost_record", title: "消费记录", VcClass: MyTaskViewController.self)
        let costModelFrame = SettingItemFrame(cost)
        // 票务中心
         let ticket = ArrowItem(icon: "Image_ticket", title: "票务中心", VcClass: CostRecordViewController.self)
        let ticketModelFrame = SettingItemFrame(ticket)
        // 我的淘宝订单
         let myorder = ArrowItem(icon: "usercenter_myorder", title: "我的淘宝订单", VcClass: CostRecordViewController.self)
        let myorderModelFrame = SettingItemFrame(myorder)
        
        let settingGroup : SettingGroup = SettingGroup()
        
        settingGroup.settingGroup = [costModelFrame,ticketModelFrame,myorderModelFrame]
        groups.removeAll()
        groups.append(settingGroup)
        collectionView.reloadData()

        
    }
}

extension MyAccountViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = groups[indexPath.section]
        let settingItemFrame = group.settingGroup[indexPath.item]
        if settingItemFrame.settingItem.optionHandler != nil {
            settingItemFrame.settingItem.optionHandler!()
        }else if settingItemFrame.settingItem is ArrowItem{
            
            let arrowItem = settingItemFrame.settingItem as! ArrowItem
            guard let desClass = arrowItem.VcClass else { return }
            guard let desVCType = desClass as? UIViewController.Type else { return }
            let desVC = desVCType.init()
            desVC.title = arrowItem.title
            // 消费记录
            if desVC is MyTaskViewController{
                let desvc = desVC as! MyTaskViewController
                baseViewModel.updateDate({ 
                    guard let time = userDefaults.object(forKey: dateKey) as? Int else { return }
                    desvc.open_url = "http://apiv2.douyucdn.cn/H5nc/welcome/to?aid=ios&client_sys=ios&id=1&time=\(time)&token=\(TOKEN)&auth=\(AUTH)"
                    self.navigationController?.pushViewController(desVC, animated: true)
                })
                
            }else{
                navigationController?.pushViewController(desVC, animated: true)
            }
     
            
            
        }
    }
}
