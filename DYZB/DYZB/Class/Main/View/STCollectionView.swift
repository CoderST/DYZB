//
//  STCollectionView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/13.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

fileprivate let STCollectionViewCellIdentifier = "STCollectionViewCellIdentifier"
@objc protocol  STCollectionViewDataSource : class {
    /*********必须实现***********/
    /// 多少行
    @objc func numberOfRowsInSTCollectionView(_ stCollectionView : STCollectionView)->NSInteger
    
    /// 每行的标题
    @objc func collectionViewTitleInRow(_ stCollectionView : STCollectionView, _ indexPath : IndexPath)->String
    
    /*********选择实现***********/
    /// 普通图片
//     @objc optional func imageName(_ collectionView : STCollectionView, _ indexPath : IndexPath)->String
    
    /// 高亮图片
//    @objc optional func highImageName(_ collectionView : STCollectionView, _ indexPath : IndexPath)->String
    
    /// 是否有箭头
    @objc optional func isHiddenArrowImageView(_ stCollectionView : STCollectionView, _ indexPath : IndexPath)->Bool
}

@objc protocol STCollectionViewDelegate : class{

    /// 点击事件
    @objc optional func stCollection(_ stCollectionView : STCollectionView, didSelectItemAt indexPath: IndexPath)
    

}

class STCollectionView: UIView {
    

    weak var dataSource : STCollectionViewDataSource?
    weak var delegate : STCollectionViewDelegate?
    
    // MARK:- 懒加载
    fileprivate lazy var collectionView : UICollectionView = {
        // 设置layout属性
        let layout = UICollectionViewFlowLayout()
        
        let width = sScreenW
        // 默认值(如果改动可以添加代理方法)
        layout.itemSize = CGSize(width: width, height: 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 创建UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 0, y:0 , width: 0 , height: 0), collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        
        // 注册cell
        collectionView.register(STCollectionViewCell.self, forCellWithReuseIdentifier: STCollectionViewCellIdentifier)
        
        return collectionView;
        
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension STCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        guard let itemsCount = dataSource?.numberOfRowsInSTCollectionView(self) else { return 0 }
        
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: STCollectionViewCellIdentifier, for: indexPath) as! STCollectionViewCell
        cell.contentView.backgroundColor = UIColor.randomColor()
        // title
         let text = dataSource?.collectionViewTitleInRow(self, indexPath) ?? ""
        cell.titleLabel.text = text
        
        // 是否右箭头
        if let isHidden = dataSource?.isHiddenArrowImageView?(self, indexPath){
            cell.arrowImageView.isHidden = isHidden
        }else{
            cell.arrowImageView.isHidden = true
        }
        
        // 必须添加下面这句话,不然系统不知道什么时候刷新cell(参考:http://www.jianshu.com/writer#/notebooks/8510661/notes/14529933/preview)
        cell.setNeedsLayout()
        
        return cell
        
    }


}

extension STCollectionView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.stCollection?(self, didSelectItemAt: indexPath)
    }
}

