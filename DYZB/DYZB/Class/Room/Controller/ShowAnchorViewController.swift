//
//  ShowAnchorViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/27.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import IJKMediaFramework
class ShowAnchorViewController: UIViewController {
    // MARK:- 常量
    private let sMarginLR :CGFloat = 15
    private let sMarginT :CGFloat = 30
    private let RoomAnchorCellIdentifier = "RoomAnchorCellIdentifier"
    
    // MARK:- 自定义属性
    var room_id : Int64 = 0
//    var playerVC : IJKFFMoviePlayerController?
    var currentIndex : Int = 0
    
    var refreshGifHeader : DYRefreshGifHeader?
    
    // MARK:- 懒加载
    private lazy var roomAnchorVM : RoomAnchorVM = RoomAnchorVM()
        private lazy var tableView : UITableView = {
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.pagingEnabled = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = sScreenH
        tableView.registerClass(RoomAnchorCell.self, forCellReuseIdentifier: self.RoomAnchorCellIdentifier)
        return tableView
    }()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        setupUI()
         refreshGifHeader  = DYRefreshGifHeader(refreshingTarget: self, refreshingAction: "refreshGifHeaderAction")
        tableView.mj_header = refreshGifHeader
        getNetworkData()
        
        
       
    }
    
    // MARK:- 自定义方法
    func refreshGifHeaderAction(){
        currentIndex++
        if currentIndex == roomAnchorVM.roomYKModelArray.count{
            currentIndex = 0
        }
        refreshGifHeader?.stateLabel?.hidden = false
        refreshGifHeader?.setTitle("下拉切换另一个", forState: .Pulling)
        refreshGifHeader?.setTitle("下拉切换另一个", forState: .Idle)
        if roomAnchorVM.roomYKModelArray.count > 0{
        tableView.mj_header.endRefreshing()
        tableView.reloadData()
        }
    }
    
    
}
// MARK:- 网络请求
extension ShowAnchorViewController {
    
    private func getNetworkData(){
        // 其实这里有个问题:如果要实现喵播上拉下拉
        tableView.mj_header.beginRefreshing()
        roomAnchorVM.getRoomAnchorData(room_id) { () -> () in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
        }

    }
}
// MARK:- 设置UI
extension ShowAnchorViewController {
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

extension ShowAnchorViewController :UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let roomcell = tableView.dequeueReusableCellWithIdentifier(RoomAnchorCellIdentifier, forIndexPath: indexPath) as! RoomAnchorCell
        if roomAnchorVM.roomYKModelArray.count > 0{
            roomcell.parentVc = self
            let anchor = roomAnchorVM.roomYKModelArray[currentIndex]
            roomcell.roomAnchor = anchor
        }
        return roomcell
    }
}

extension ShowAnchorViewController : UITableViewDelegate{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return sScreenH
    }
}

