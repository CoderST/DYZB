//
//  ShowAnchorViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//
// MARK:- 双手上下不间断滑动会有BUG  当第一条数组或者最后一条数据再往前或者后加载需要处理 待处理
import UIKit
import SnapKit
import MJRefresh
import IJKMediaFramework
class ShowAnchorVC: UIViewController {
    
    // MARK:- 常量
    fileprivate let sMarginLR :CGFloat = 15
    fileprivate let sMarginT :CGFloat = 30
    fileprivate let RoomAnchorCellIdentifier = "RoomAnchorCellIdentifier"
    
    // MARK:- 变量
    /// 控制主播的index
    fileprivate var movieIndex : Int = 0
    /// 猥琐了一把,就是控制cell一次操作
    fileprivate var cellOneLock : Bool = false
    /// 零时变量记录当前主播的信息
    fileprivate var tempAnchor : RoomYKModel?
    /// 是否为当前主播
    fileprivate var currentAnchor : RoomYKModel?
    
    // MARK:- 自定义属性
    fileprivate var room_id : Int64 = 0
    /// 当前需要展示主播数组
    fileprivate var currentShowArray : [RoomYKModel] = [RoomYKModel]()
    /// 记录cell
    fileprivate var roomcell : ShowAnchorVCCell!
    
    // MARK:- 懒加载
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isPagingEnabled = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = sScreenH
        tableView.register(ShowAnchorVCCell.self, forCellReuseIdentifier: self.RoomAnchorCellIdentifier)
        return tableView
    }()
    
    fileprivate lazy var persentModel : PresentModel = PresentModel()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 设置UI
        setupUI()
        
        // 监听通知
        notificationCenterAddObserver()
    }
    
    
    /// 获取主要数据
    func getShowDatasAndIndexPath(_ showArray : [RoomYKModel],indexPath : IndexPath?){
        guard let indexPath = indexPath else { return }
        currentShowArray = showArray
        movieIndex = indexPath.row
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    
    // MARK:- 控制器销毁
    deinit{
        notificationCenter.removeObserver(self)
        print("ShowAnchorViewController - 界面销毁")
        
    }
    
}

// MARK:- 设置UI
extension ShowAnchorVC {
    func setupUI(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}

// MARK:- 监听通知 - 通知事件
extension ShowAnchorVC {
    
    
    fileprivate func notificationCenterAddObserver(){
        /// 点击关注用户通知
        notificationCenter.addObserver(self, selector: #selector(ShowAnchorVC.ClickUser(_:)), name: NSNotification.Name(rawValue: sNotificationName_ClickUser), object: nil)
        
        /// 点击猫耳朵通知
        notificationCenter.addObserver(self, selector: #selector(ShowAnchorVC.TapCatClick(_:)), name: NSNotification.Name(rawValue: sNotificationName_TapCatClick), object: nil)
        
        
    }
    
    /// 关注用户
    @objc fileprivate func ClickUser(_ notification : Notification){
        guard let infor = notification.userInfo else { return }
        guard let user = infor["user"] as? RoomFollowPerson else { return }
        
        let showUserVC = ShowUserVC()
        showUserVC.roomAnchor = user
        showUserVC.modalPresentationStyle = .custom
        showUserVC.transitioningDelegate = persentModel
        persentModel.presentedFrame = CGRect(x: 15, y: 100, width: sScreenW - 30, height: sScreenH - 200)
        present(showUserVC, animated: true, completion: nil)
        
    }
    
    /// 猫耳朵
    @objc fileprivate func TapCatClick(_ notification : Notification){
        print("TapCatClickTapCatClickTapCatClick")
        cellOneLock = false
        movieIndex += 1
        let indexPath = IndexPath(row: movieIndex, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    
}


// MARK:- UITableViewDataSource
extension ShowAnchorVC :UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return currentShowArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        roomcell = tableView.dequeueReusableCell(withIdentifier: RoomAnchorCellIdentifier, for: indexPath) as! ShowAnchorVCCell
        roomcell.parentVc = self
        
        // 1 传递主播数据
        let roomAnchor = currentShowArray[indexPath.row]
        roomcell.roomAnchor = roomAnchor
        
        if cellOneLock == false{
            // 2 传递主播视频数据
            tempAnchor = currentShowArray[movieIndex]
            roomcell.playingVideo(tempAnchor!)
            // 3 副播视频数据
            var subIndex = movieIndex + 1
            if subIndex <= currentShowArray.count{
            }else{
                subIndex = 0
            }
            roomcell.subAnchorModel = currentShowArray[subIndex]
            cellOneLock = true
        }
        movieIndex = indexPath.row
        return roomcell
    }
}

// MARK:- UITableViewDelegate(以下是手动控制视频数据的传递)
extension ShowAnchorVC : UITableViewDelegate{
    /// cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return sScreenH
    }
    
    /// 已经结束显示的cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        if movieIndex == indexPath.row{
            
            return
        }
        
        // 逻辑处理
        anchorAndCatCellAction(cell)
        
    }
    
}

// MARK:-UIScrollViewDelegate 以下是处理滚动cell时传递视频数据
extension ShowAnchorVC : UIScrollViewDelegate{
    
    /// 已经完成减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        didEndAction()
        
    }
    
    
}


// MARK:- 自定义方法
extension ShowAnchorVC {
    
    /// 滚动结束调用
    fileprivate func didEndAction() {
        // 1 主播视频数据
        let roomAnchor = currentShowArray[movieIndex]
        //            currentAnchor = roomAnchor
        if tempAnchor?.userId == roomAnchor.userId{
            return
        }
        roomcell.playingVideo(roomAnchor)
        // 4 传递副播数据
        roomcell.subAnchorModel = currentShowArray[movieIndex + 1]
        
        tempAnchor = roomAnchor
        
    }
    
    fileprivate func anchorAndCatCellAction(_ cell: UITableViewCell){
        let willDisappearCell = cell as!ShowAnchorVCCell
        
        // 注意:shutdown()方法里一定要移除通知
        
        // 处理主界面播放器逻辑(手指轻微弹起一下,会再次调用此方法)
        if willDisappearCell.playerController != nil{
            
            willDisappearCell.shutdownAction()
            willDisappearCell.playerController!.view.removeFromSuperview()
            willDisappearCell.playerController = nil
            
        }
        
        // 处理猫耳朵播放器
        if willDisappearCell.catView.subPlayerController != nil{
            willDisappearCell.catView.subPlayerController?.shutdown()
            willDisappearCell.catView.subPlayerController?.view.removeFromSuperview()
            willDisappearCell.catView.subPlayerController = nil
            willDisappearCell.catView.removeFromSuperview()
            
        }

    }

}
