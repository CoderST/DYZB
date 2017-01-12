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
    fileprivate let sMarginLR :CGFloat = 15
    fileprivate let sMarginT :CGFloat = 30
    fileprivate let RoomAnchorCellIdentifier = "RoomAnchorCellIdentifier"
    
    // MARK:- 自定义属性
    var room_id : Int64 = 0
//    var playerVC : IJKFFMoviePlayerController?
    var currentIndex : Int = 0
    
    var refreshGifHeader : DYRefreshGifHeader?
    
    // MARK:- 懒加载
    fileprivate lazy var roomAnchorVM : RoomAnchorVM = RoomAnchorVM()
        fileprivate lazy var tableView : UITableView = {
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isPagingEnabled = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = sScreenH
        tableView.register(RoomAnchorCell.self, forCellReuseIdentifier: self.RoomAnchorCellIdentifier)
        return tableView
    }()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
         refreshGifHeader  = DYRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(ShowAnchorViewController.refreshGifHeaderAction))
        tableView.mj_header = refreshGifHeader
        getNetworkData()
        
        
       
    }
    
    deinit{
        print("ShowAnchorViewController - 界面销毁")
    }
    
    // MARK:- 自定义方法
     func refreshGifHeaderAction(){
        currentIndex += 1
        if currentIndex == roomAnchorVM.roomYKModelArray.count{
            currentIndex = 0
        }
        refreshGifHeader?.stateLabel?.isHidden = false
        refreshGifHeader?.setTitle("下拉切换另一个", for: .pulling)
        refreshGifHeader?.setTitle("下拉切换另一个", for: .idle)
        if roomAnchorVM.roomYKModelArray.count > 0{
        tableView.mj_header.endRefreshing()
        tableView.reloadData()
        }
    }
    
    
   
    
}
// MARK:- 网络请求
extension ShowAnchorViewController {
    
    fileprivate func getNetworkData(){
        // 其实这里有个问题:如果要实现喵播上拉下拉
        tableView.mj_header.beginRefreshing()
//        roomAnchorVM.getRoomAnchorData(1) { () -> () in
//            
//            self.tableView.mj_header.endRefreshing()
//            self.tableView.reloadData()
//        }
        
        roomAnchorVM.getRoomAnchorData(1, finishCallBack: { () -> () in
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            
            }) { () -> () in
                // 没有数据
                print("没有数据")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let roomcell = tableView.dequeueReusableCell(withIdentifier: RoomAnchorCellIdentifier, for: indexPath) as! RoomAnchorCell
        if roomAnchorVM.roomYKModelArray.count > 0{
            roomcell.parentVc = self
            let anchor = roomAnchorVM.roomYKModelArray[currentIndex]
            roomcell.roomAnchor = anchor
        }
        return roomcell
    }
}

extension ShowAnchorViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return sScreenH
    }
}

