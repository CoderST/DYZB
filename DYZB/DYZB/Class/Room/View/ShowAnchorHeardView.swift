//
//  ShowAnchorHeardView.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//  左上角主播信息

import UIKit

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
    private lazy var followPersonArray : [RoomFollowPerson] = [RoomFollowPerson]()
    
    var anchorModel : RoomYKModel?{
        didSet{
            
            guard let model = anchorModel else { return }
            userIconImageView.sd_setImageWithURL(NSURL(string: model.smallpic), placeholderImage: nil)
            userNameLabel.text = model.myname
            userNumberLabel.text = String(model.allnum)
            
            // 这里是固定值了,更具需要,可以自己改动
            userFishBtn.setTitle("14351", forState: .Normal)
            userBabyNunberLabel.text = "宝宝:1233242"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userInteractionEnabled = true
        backgroundColor = UIColor.clearColor()
        userInforMainView.backgroundColor = UIColor.clearColor()
        userFellowButton.backgroundColor = UIColor.yellowColor()
        setupCollectionView()
        getDatas()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSize(width: followPersonItemWH, height: followPersonItemWH)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.registerClass(ShowAnchorHeadFollowPersonCell.self, forCellWithReuseIdentifier: ShowAnchorHeadFollowPersonCellIdentifier)
    }
    
    private func getDatas(){
        guard let path = NSBundle.mainBundle().pathForResource("user.plist", ofType: nil) else { return }
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
    
    class func creatShowAnchorHeardView()->ShowAnchorHeardView{
        
        return NSBundle.mainBundle().loadNibNamed("ShowAnchorHeardView", owner: nil, options: nil).first as! ShowAnchorHeardView
    
    }
}

extension ShowAnchorHeardView : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
            
        return followPersonArray.count ?? 0
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ShowAnchorHeadFollowPersonCellIdentifier, forIndexPath: indexPath) as! ShowAnchorHeadFollowPersonCell
        cell.roomFollowPerson = followPersonArray[indexPath.item]
        return cell
    }
}

extension ShowAnchorHeardView : UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1 取出对象
        let user = followPersonArray[indexPath.item]
        // 2 发出通知
        NSNotificationCenter.defaultCenter().postNotificationName(sNotificationName_ClickUser, object: nil, userInfo: ["user" : user])
    }
    
}
