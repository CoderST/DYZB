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
    fileprivate let ShowAnchorListCellInden = "ShowAnchorListCellInden"
    // MARK:- 变量
    fileprivate var page : Int = 1
    
    // MARK:- 懒加载
    fileprivate let roomAnchorVM : RoomAnchorVM = RoomAnchorVM()
    
    fileprivate let collectionView : UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: sScreenW, height: sScreenH - sNavatationBarH - sStatusBarH)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: sScreenW, height: sScreenH), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        return collectionView
        
    }()
    
    
    @IBAction func quickTopButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }) 
    }
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupCollectionDownReloadData()
        
        setupCollectionUpLoadMore()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
     func setupCollectionDownReloadData(){
        let refreshGifHeader = DYRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(ShowAnchorListVC.downReloadData))
        refreshGifHeader?.stateLabel?.isHidden = true
        refreshGifHeader?.setTitle("", for: .pulling)
        refreshGifHeader?.setTitle("", for: .idle)
        collectionView.mj_header = refreshGifHeader
        collectionView.mj_header.isAutomaticallyChangeAlpha = true
        collectionView.mj_header.beginRefreshing()

    }
    
     func setupCollectionUpLoadMore(){
        // MJRefreshAutoFooterIdleText
        let foot = DYRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ShowAnchorListVC.upLoadMore))
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
        page += 1
        roomAnchorVM.getRoomAnchorData(page, finishCallBack: { () -> () in
            
            self.collectionView.mj_footer.endRefreshing()
            self.collectionView.reloadData()

            
            }) { () -> () in
                
                print("没有数据了")
                SVProgressHUD.setDefaultStyle(.dark)
                SVProgressHUD.showInfo(withStatus: "没有了哦~~")
        }
    }
}

// MARK:- UI设置
extension ShowAnchorListVC {
    // 1 初始化collectionView
    fileprivate func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UINib(nibName: "ShowAnchorListCell", bundle: nil), forCellWithReuseIdentifier: ShowAnchorListCellInden)
        collectionView.dataSource = self
        collectionView.delegate = self

    }

}

// MARK:- UICollectionViewDataSource
extension ShowAnchorListVC : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return roomAnchorVM.roomYKModelArray.count 
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowAnchorListCellInden, for: indexPath) as! ShowAnchorListCell
        
        let model = roomAnchorVM.roomYKModelArray[indexPath.item]
        cell.anchorModel = model
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension ShowAnchorListVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1 创建主播界面
        let showAnchorVC = ShowAnchorVC()
        // 2 传递主播数组
        showAnchorVC.getShowDatasAndIndexPath(roomAnchorVM.roomYKModelArray, indexPath: indexPath)
        // 3 弹出主播界面
        present(showAnchorVC, animated: true, completion: nil)
    }
}
