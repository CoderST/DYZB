//
//  AppDelegate.swift
//  DYZB
//
//  Created by xiudou on 16/9/15.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import XHLaunchAd
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    fileprivate var proname : String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UITabBar.appearance().tintColor = UIColor.orange
        
        // 添加广告
        addAd()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// MARK:- 广告
extension AppDelegate {
    
    func addAd(){
        //设置数据等待时间 请求广告URL前,必须设置,否则会先进入window的RootVC
        XHLaunchAd.setWaitDataDuration(3)
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        /*
         posid	800001
         roomid	0
         */
        // http://capi.douyucdn.cn/lapi/sign/appapi/getinfo?aid=ios&client_sys=ios&time=1498010940&token=94153348_11_8156dadc9bd1725c_2_22753001&auth=7b28d8c1af4ca89c77af7dd59408645f
        let params = ["posid" : 800001, "roomid" : 0]
        let URLString = String(format: "http://capi.douyucdn.cn/lapi/sign/appapi/getinfo?aid=ios&client_sys=ios&time=%d&token=94153348_11_8156dadc9bd1725c_2_22753001&auth=%@", timeStamp,AUTH)
        
        NetworkTools.requestData(.post, URLString: URLString, parameters: params) { (result) in
            
            guard let result = result as? [String : Any] else { return }
            print(result)
            guard let error = result["error"] as? Int else { return }
            
            if error != 0 {
                print("广告有错误,auth要最新的",error,result)
                return
            }
            
            guard let resultDataArray = result["data"] as? [[String : Any]] else {return}
            var adModels : [AdVertModel] = [AdVertModel]()
            for dict in resultDataArray{
                let adModel = AdVertModel(dict: dict)
                adModels.append(adModel)
            }
      
            let adModel = adModels.last!
            self.proname = adModel.proname
            //2.自定义配置
            let imageAdconfiguration = XHLaunchImageAdConfiguration()
            //广告停留时间
            imageAdconfiguration.duration = adModel.showtime
            //广告frame
            imageAdconfiguration.frame = CGRect(x: 0, y: 0, width: sScreenW, height: sScreenH)
            //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
            imageAdconfiguration.imageNameOrURLString = adModel.srcid
            //网络图片缓存机制(只对网络图片有效)
            imageAdconfiguration.imageOption = .refreshCached
            //图片填充模式
            imageAdconfiguration.contentMode = .scaleToFill
            //广告点击打开链接
            imageAdconfiguration.openURLString = adModel.link
            //广告显示完成动画
            imageAdconfiguration.showFinishAnimate = .fadein
            //广告显示完成动画时间
//            imageAdconfiguration.showFinishAnimateTime = 0.8
            //跳过按钮类型
            imageAdconfiguration.skipButtonType = .timeText
            //后台返回时,是否显示广告
            imageAdconfiguration.showEnterForeground = false
//            let view = UIView()
//            view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//            view.backgroundColor = UIColor.red
//            imageAdconfiguration.subViews = [view]
            //显示图片开屏广告
            XHLaunchAd.imageAd(with: imageAdconfiguration, delegate: self)
        }
    }
    
}

// MARK:- 点击广告跳转
extension AppDelegate : XHLaunchAdDelegate{
    func xhLaunchAd(_ launchAd: XHLaunchAd, clickAndOpenURLString openURLString: String) {
        let adVC = ADLinkViewController()
        adVC.title = self.proname
        adVC.openURLString = openURLString
        let tabVC = window?.rootViewController as!UITabBarController
        let nav = tabVC.selectedViewController as!UINavigationController
        nav.pushViewController(adVC, animated: true)
    }
}
