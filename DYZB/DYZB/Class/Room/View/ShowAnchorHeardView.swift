//
//  ShowAnchorHeardView.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//  左上角主播信息

import UIKit
import SDWebImage
// MARK:- 常量
private let ShowAnchorHeadFollowPersonCellIdentifier = "ShowAnchorHeadFollowPersonCellIdentifier"

// 用户头像的宽高
private let userIconWH :CGFloat = 30
private let userFollowButtonWidth : CGFloat = 30
private let userFollowButtonHeight : CGFloat = 20

private let followPersonItemWH : CGFloat = 30

private let userNameLabelFontSize : CGFloat = 12
private let userNumberLabelFontSize : CGFloat = 12

class ShowAnchorHeardView: UIView {
    // MARK:- 控件
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userFishBtn: UIButton!
    @IBOutlet weak var userBabyNunberLabel: UILabel!
    @IBOutlet weak var userNumberLabel: UILabel!
    @IBOutlet weak var userFellowButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userInforMainView: UIView!
    
    // MARK:- 懒加载
    fileprivate lazy var followPersonArray : [RoomFollowPerson] = [RoomFollowPerson]()
    
    var anchorModel : RoomYKModel?{
        didSet{
            
            guard let model = anchorModel else { return }
//            SDWebImageDownloader.shared().downloadImage(with: URL(string: model.smallpic), options: .useNSURLCache, progress: nil) {[weak self] (image : UIImage!, _, error : NSError!, finished : Bool) -> Void in
//                if finished{
//                    let circleImage = UIImage.circleImage(image, borderColor: UIColor.white, borderWidth: 2)
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        
//                        self?.userIconImageView.image = circleImage
//                    })
//                }
//            }
            
            SDWebImageDownloader.shared().downloadImage(with: URL(string: model.smallpic), options: .useNSURLCache, progress: nil) {[weak self] (image, data, error, finished) in
//                                if finished{
                guard let image = image else { return }
                                    let circleImage = UIImage.circleImage(image, borderColor: UIColor.white, borderWidth: 2)
                                    DispatchQueue.main.async(execute: { () -> Void in
                
                                        self?.userIconImageView.image = circleImage
                                    })

            }
            
            userNameLabel.text = model.myname
            userNumberLabel.text = String(model.allnum)
            
            // 这里是固定值了,更具需要,可以自己改动
            userFishBtn.setTitle("猫粮:14351", for: UIControlState())
            userBabyNunberLabel.text = "宝宝:1233242"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        setupCollectionView()
        getDatas()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: followPersonItemWH, height: followPersonItemWH)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.register(ShowAnchorHeadFollowPersonCell.self, forCellWithReuseIdentifier: ShowAnchorHeadFollowPersonCellIdentifier)
    }
    
    fileprivate func getDatas(){
        guard let path = Bundle.main.path(forResource: "user.plist", ofType: nil) else { return }
        guard let dicArray = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else { return }
        for dic in dicArray{
            let person = RoomFollowPerson(dic: dic)
            followPersonArray.append(person)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if followPersonArray.count > 0{
            collectionView.reloadData()
        }
    }
    
//    class func creatShowAnchorHeardView()->ShowAnchorHeardView{
//        
//        return Bundle.main.loadNibNamed("ShowAnchorHeardView", owner: nil, options: nil)!.first as! ShowAnchorHeardView
//    
//        
//    }
    
    
    class func creatShowAnchorHeardView()->ShowAnchorHeardView{
        
        return Bundle.main.loadNibNamed("ShowAnchorHeardView", owner: nil, options: nil)?.first as! ShowAnchorHeardView
    }
}

extension ShowAnchorHeardView : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
            
        return followPersonArray.count 
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowAnchorHeadFollowPersonCellIdentifier, for: indexPath) as! ShowAnchorHeadFollowPersonCell
        cell.roomFollowPerson = followPersonArray[indexPath.item]
        return cell
    }
}

extension ShowAnchorHeardView : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1 取出对象
        let user = followPersonArray[indexPath.item]
        // 2 发出通知
        notificationCenter.post(name: Notification.Name(rawValue: sNotificationName_ClickUser), object: nil, userInfo: ["user" : user])
    }
    
}
