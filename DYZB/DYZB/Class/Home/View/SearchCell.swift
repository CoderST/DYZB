//
//  SearchCell.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let rankWH : CGFloat = 15
class SearchCell: UICollectionViewCell {
    
    fileprivate let rankLabel : UILabel = {
        
        let rankLabel = UILabel()
        rankLabel.font = UIFont.systemFont(ofSize: 12)
        rankLabel.textAlignment = .center
        return rankLabel
        
    }()

    
    fileprivate let titleLabel : UILabel = {
        
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        return titleLabel
        
    }()
    
    fileprivate let lineView : UIView = {
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        return lineView
        
    }()
    
    var searchModel : SearchModel?{
        
        didSet{
            
            guard let searchModel = searchModel else { return }
            let rank = searchModel.rank
            switch rank {
            case "0":
                print("")
                
            case "1":
                print("")
                rankLabel.backgroundColor = UIColor.red
            case "2":
                print("")
                rankLabel.backgroundColor = UIColor.purple
            case "3":
                print("")
                rankLabel.backgroundColor = UIColor.orange
            default:
                print("")
                rankLabel.backgroundColor = UIColor.gray
            }
            
            rankLabel.text = searchModel.rank
            titleLabel.text = searchModel.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(rankLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if searchModel?.rank == "0" {
            rankLabel.isHidden = true
            rankLabel.frame = CGRect(x: 10, y: (frame.height - rankWH) * 0.5, width: 0, height: rankWH)
        }else{
            rankLabel.isHidden = false
            rankLabel.frame = CGRect(x: 10, y: (frame.height - rankWH) * 0.5, width: rankWH, height: rankWH)
        }
        
        titleLabel.frame = CGRect(x: rankLabel.frame.maxX + 10, y: 0, width: sScreenW, height: frame.height)
        
        lineView.frame = CGRect(x: 0, y: frame.height - 1, width: sScreenW, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
