//
//  ShowAnchorListVC.swift
//  DYZB
//
//  Created by xiudou on 16/11/5.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
class ShowAnchorListVC: UIViewController {
    
    // MARK:- 属性
//    @IBOutlet weak var collectionView: UICollectionView!
    // MARK:- 常量
    private let ShowAnchorListCellInden = "ShowAnchorListCellInden"
    // MARK:- 变量
    private var page : Int = 1
    
    // MARK:- 懒加载
    private let roomAnchorVM : RoomAnchorVM = RoomAnchorVM()
    
    private let collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: sScreenW, height: sScreenH - sNavatationBarH - sStatusBarH)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: sScreenW, height: sScreenH), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        return collectionView
        
    }()
    
    
    @IBAction func quickTopButton(sender: UIButton) {
        UIView.animateWithDuration(0.5) { () -> Void in
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupCollectionDownReloadData()
        
        setupCollectionUpLoadMore()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
     func setupCollectionDownReloadData(){
        let refreshGifHeader = DYRefreshGifHeader(refreshingTarget: self, refreshingAction: "downReloadData")
        refreshGifHeader?.stateLabel?.hidden = true
        refreshGifHeader.setTitle("", forState: .Pulling)
        refreshGifHeader.setTitle("", forState: .Idle)
        collectionView.mj_header = refreshGifHeader
        collectionView.mj_header.automaticallyChangeAlpha = true
        collectionView.mj_header.beginRefreshing()

    }
    
     func setupCollectionUpLoadMore(){
        // MJRefreshAutoFooterIdleText
        let foot = DYRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "upLoadMore")
        collectionView.mj_footer = foot
        
    }

}

// MARK:- 网络请求
extension ShowAnchorListVC {
    
    // 下拉刷新
     func downReloadData(){
        page = 1
        roomAnchorVM.getRoomAnchorData(page, finishCallBack: { () -> () in
            self.collectionView.mj_header.endRefreshing()
            self.collectionView.reloadData()

            }) { () -> () in
                print("没有啦")
        }
    }
    
    
    // 上拉加载更多
     func upLoadMore(){
        page++
        roomAnchorVM.getRoomAnchorData(page, finishCallBack: { () -> () in
            
            self.collectionView.mj_footer.endRefreshing()
            self.collectionView.reloadData()

            
            }) { () -> () in
                
                print("没有数据了")
                SVProgressHUD.setDefaultStyle(.Dark)
                SVProgressHUD.showInfoWithStatus("没有了哦~~")
        }
    }
}

// MARK:- UI设置
extension ShowAnchorListVC {
    // 1 初始化collectionView
    private func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.registerNib(UINib(nibName: "ShowAnchorListCell", bundle: nil), forCellWithReuseIdentifier: ShowAnchorListCellInden)
        collectionView.dataSource = self
        collectionView.delegate = self

    }

}

// MARK:- UICollectionViewDataSource
extension ShowAnchorListVC : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return roomAnchorVM.roomYKModelArray.count ?? 0
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ShowAnchorListCellInden, forIndexPath: indexPath) as! ShowAnchorListCell
        
        let model = roomAnchorVM.roomYKModelArray[indexPath.item]
        cell.anchorModel = model
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension ShowAnchorListVC : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let showAnchorVC = ShowAnchorVC()
        showAnchorVC.getShowDatasAndIndexPath(roomAnchorVM.roomYKModelArray, indexPath: indexPath)
        presentViewController(showAnchorVC, animated: true, completion: nil)
    }
}
