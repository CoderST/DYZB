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
    var lastContentOffset : CGFloat = 0
    /// 控制主播的index
    var movieIndex : Int = 0
    /// 猥琐了一把,就是控制cell一次操作
    var cellOneLock : Bool = false
    /// 向上滚动的锁🔐
    var upLock : Bool = false
    /// 向下滚动的锁🔐
    var downLock : Bool = false
    /// 手指是否离开屏幕
    var userTouch : Bool = false
    
    var scrollowViewOneLock : Bool = false
    
    /// 零时变量记录当前主播的信息
    var tempAnchor : RoomYKModel?
    
    // MARK:- 自定义属性
    var room_id : Int64 = 0
    
    var currentShowArray : [RoomYKModel]?
    
    var roomcell : ShowAnchorVCCell!
    
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
        
        setupUI()
        
        initObserver()
    }
    
    // MARK:- 监听通知
    func initObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAnchorVC.ClickUser(_:)), name: NSNotification.Name(rawValue: sNotificationName_ClickUser), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAnchorVC.TapCatClick(_:)), name: NSNotification.Name(rawValue: sNotificationName_TapCatClick), object: nil)
        
        
    }
    
    // MARK:- 通知事件
    func ClickUser(_ notification : Notification){
        guard let infor = notification.userInfo else { return }
        guard let user = infor["user"] as? RoomFollowPerson else { return }
        
        let showUserVC = ShowUserVC()
        showUserVC.roomAnchor = user
        showUserVC.modalPresentationStyle = .custom
        showUserVC.transitioningDelegate = persentModel
        persentModel.presentedFrame = CGRect(x: 15, y: 100, width: sScreenW - 30, height: sScreenH - 200)
        present(showUserVC, animated: true, completion: nil)
        
    }
    
    func TapCatClick(_ notification : Notification){
        print("TapCatClickTapCatClickTapCatClick")
        cellOneLock = false
        movieIndex += 1
        let indexPath = IndexPath(row: movieIndex, section: 0)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: false)
    }
    
    
    
    // MARK:- 控制器销毁
    deinit{
        NotificationCenter.default.removeObserver(self)
        print("ShowAnchorViewController - 界面销毁")
        
    }
    
    // MARK:- 自定义方法
    func getShowDatasAndIndexPath(_ showArray : [RoomYKModel],indexPath : IndexPath?){
        print("indexPath!.row",indexPath!.row)
        currentShowArray = showArray
        movieIndex = indexPath!.row
        tableView.scrollToRow(at: indexPath!, at: UITableViewScrollPosition.top, animated: false)
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

// MARK:- UITableViewDataSource
extension ShowAnchorVC :UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return currentShowArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        roomcell = tableView.dequeueReusableCell(withIdentifier: RoomAnchorCellIdentifier, for: indexPath) as! ShowAnchorVCCell
        roomcell.parentVc = self
        
        // 1 传递主播图片数据
        let roomAnchor = currentShowArray![indexPath.row]
        roomcell.roomAnchor = roomAnchor
        
        if cellOneLock == false{
            // 2 传递主播视频数据
            tempAnchor = currentShowArray![movieIndex]
            roomcell.playingVideo(tempAnchor!)
            // 3 副播视频数据
            var subIndex = movieIndex + 1
            if subIndex <= currentShowArray!.count{
            }else{
                subIndex = 0
            }
            roomcell.subAnchorModel = currentShowArray![subIndex]
            cellOneLock = true
        }
        movieIndex = indexPath.row
        return roomcell
    }
}

// MARK:- UITableViewDelegate(以下是手动控制视频数据的传递)
extension ShowAnchorVC : UITableViewDelegate{
    // cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return sScreenH
    }
    
    // 已经结束显示的cell
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
        
        let willDisappearCell = cell as!ShowAnchorVCCell
        
        // 注意:shutdown()方法里一定要移除通知
        
        // 处理手指轻微弹起一下,会再次调用此方法
        if willDisappearCell.playerController != nil{
            // 处理主界面播放器逻辑
            willDisappearCell.shutdownAction()
            willDisappearCell.playerController!.view.removeFromSuperview()
            willDisappearCell.playerController = nil
            
        }
        
        // 处理猫耳朵播放器
        if willDisappearCell.catView.movieModel != nil{
            willDisappearCell.catView.movieModel?.shutdown()
            willDisappearCell.catView.movieModel?.view.removeFromSuperview()
            willDisappearCell.catView.movieModel = nil
            willDisappearCell.catView.removeFromSuperview()
        
        }
    }
    
}

// MARK:-UIScrollViewDelegate 以下是处理滚动cell时传递视频数据
extension ShowAnchorVC : UIScrollViewDelegate{
    
    // 手指接触拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollowViewOneLock = true
        userTouch = true
        lastContentOffset = scrollView.contentOffset.y
//        scrollView.isScrollEnabled = true
    }
    

    
    // 控制
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        let height = UIScreen.main.bounds.size.height * 0.5
//        if scrollowViewOneLock == true{
//            // 向上滚动
//            if(lastContentOffset + height < scrollView.contentOffset.y && upLock == false && userTouch == false){
//                print(movieIndex)
//                movieIndex += 1
//                print(movieIndex)
//                upLock = true
//                
//            }
//            // 向下滚动
//            if(scrollView.contentOffset.y < lastContentOffset - height && downLock == false && userTouch == false){
//                
//                movieIndex -= 1
//                downLock = true
//            }
//        }
//        
//    }
    
    
    // 已经完成减速
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        didEndAction()
//        scrollView.isScrollEnabled = true
        
           }
    
    // 手指离开拖拽
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
//        
//        if !decelerate{
//            didEndAction()
//            
//        }else{
////            scrollView.isScrollEnabled = false
//
//        }
//    }
    

    func didEndAction() {
//        if tempAnchor != currentShowArray![movieIndex]{
            // 1 主播视频数据
            let roomAnchor = currentShowArray![movieIndex]
            roomcell.playingVideo(roomAnchor)
            
//            // 2 副播视频数据
//            var subIndex = movieIndex + 1
//            // 3 判断是否越界
//            if subIndex <= currentShowArray!.count{
//                subIndex = movieIndex + 1
//            }else{
//                subIndex = 0
//            }
//            
            // 4 传递副播数据
            roomcell.subAnchorModel = currentShowArray![movieIndex + 1]
            tempAnchor = roomAnchor
            downLock = false
            upLock = false
            userTouch = false
//        }

    }
}
