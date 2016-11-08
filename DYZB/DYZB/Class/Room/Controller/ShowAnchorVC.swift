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
    private let sMarginLR :CGFloat = 15
    private let sMarginT :CGFloat = 30
    private let RoomAnchorCellIdentifier = "RoomAnchorCellIdentifier"
    
    // MARK:- 变量
    var lastContentOffset : CGFloat = 0
    var currentIndex : Int = 0
    /// 猥琐了一把,就是控制
    var cellOneLock : Bool = false
    /// 向上滚动的锁🔐
    var upLock : Bool = false
    /// 向下滚动的锁🔐
    var downLock : Bool = false
    /// 手指是否离开屏幕
    var userTouch : Bool = false
    
    var scrollowViewOneLock : Bool = false
    
    // MARK:- 自定义属性
    var room_id : Int64 = 0
    var currentShowArray : [RoomYKModel]?
    var roomcell : ShowAnchorVCCell!
    
    // MARK:- 懒加载
    private lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.pagingEnabled = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = sScreenH
        tableView.registerClass(ShowAnchorVCCell.self, forCellReuseIdentifier: self.RoomAnchorCellIdentifier)
        return tableView
    }()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
    }
    
    // MARK:- 控制器销毁
    deinit{
        print("ShowAnchorViewController - 界面销毁")
    }
    
    // MARK:- 自定义方法
    func getShowDatasAndIndexPath(showArray : [RoomYKModel],indexPath : NSIndexPath?){
        print("indexPath!.row",indexPath!.row)
        currentShowArray = showArray
        currentIndex = indexPath!.row
        tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        //        tableView.reloadData()
    }
    
}

// MARK:- 设置UI
extension ShowAnchorVC {
    func setupUI(){
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}

// MARK:- UITableViewDataSource
extension ShowAnchorVC :UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return currentShowArray?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        roomcell = tableView.dequeueReusableCellWithIdentifier(RoomAnchorCellIdentifier, forIndexPath: indexPath) as! ShowAnchorVCCell
        roomcell.parentVc = self
        let roomAnchor = currentShowArray![indexPath.row]
        roomcell.roomAnchor = roomAnchor
        if cellOneLock == false{
            
            roomcell.playingWithPlaceHoldImageView(roomAnchor)
            cellOneLock = true
        }
        return roomcell
    }
}

// MARK:- UITableViewDelegate
extension ShowAnchorVC : UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return sScreenH
    }
    
    // 已经结束显示的cell
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        let willDisappearCell = cell as!ShowAnchorVCCell
        // 注意:shutdown()方法里一定要移除通知
        // 处理手指轻微弹起一下,会再次调用此方法
        if willDisappearCell.playerVC != nil{
            willDisappearCell.shutdown()
            willDisappearCell.playerVCQuit()
            willDisappearCell.playerVC?.view.removeFromSuperview()
            willDisappearCell.playerVC = nil
            
        }
    }
    
}

// MARK:-UIScrollViewDelegate 以下是处理滚动cell传递视频数据
extension ShowAnchorVC : UIScrollViewDelegate{
    
    
    // 手指接触拖拽
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollowViewOneLock = true
        userTouch = true
        lastContentOffset = scrollView.contentOffset.y
    }
    
    // 手指离开拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool){
        
        userTouch = false
        
    }
    
    // 控制
    func scrollViewDidScroll(scrollView: UIScrollView){
        let height = UIScreen.mainScreen().bounds.size.height * 0.5
        if scrollowViewOneLock == true{
            // 向上滚动
            if(lastContentOffset + height < scrollView.contentOffset.y && upLock == false && userTouch == false){
                
                ++currentIndex
                upLock = true
                
            }
            // 向下滚动
            if(scrollView.contentOffset.y < lastContentOffset - height && downLock == false && userTouch == false){
                
                --currentIndex
                downLock = true
            }
        }
        
    }
    
    // 已经完成减速
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        print("currentIndex == \(currentIndex)")
        let roomAnchor = currentShowArray![currentIndex]
        roomcell.playingWithPlaceHoldImageView(roomAnchor)
        downLock = false
        upLock = false
        
    }    
}
