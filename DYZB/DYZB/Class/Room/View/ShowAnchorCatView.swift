//
//  ShowAnchorCatView.swift
//  DYZB
//
//  Created by xiudou on 16/11/10.
//  Copyright © 2016年 xiudo. All rights reserved.
//  直播界面小猫头

import UIKit
import SnapKit
import IJKMediaFramework

protocol ShowAnchorCatViewDelegate : NSObjectProtocol{
    
    /**
     长按手势代理
     */
    func ShowAnchorCatViewLongPress(showAnchorCatView : ShowAnchorCatView, gesture : UIGestureRecognizer)
}

class ShowAnchorCatView: UIView {
    
    var movieModel : IJKFFMoviePlayerController?
    var delegate : ShowAnchorCatViewDelegate?
    
    // MARK:- 懒加载
    private lazy var catImageView : UIImageView = {
        
        let catImageView =  UIImageView()
        catImageView.image = UIImage(named: "public_catEar_98x25")
        return catImageView
        
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.purpleColor()
        
        setupUI()
        addGestureAction()
        
        
    }
    
    func addGestureAction(){
        // 长按手势
        let longGress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        addGestureRecognizer(longGress)
        
        // 点击手势
        
        let tapGress = UITapGestureRecognizer(target: self, action: "tapPress:")
        addGestureRecognizer(tapGress)
    }
    
    @objc private func longPress(gesture : UILongPressGestureRecognizer){
        
        delegate?.ShowAnchorCatViewLongPress(self, gesture: gesture)
    }
    
    @objc private func tapPress(gesture : UITapGestureRecognizer){
        
        NSNotificationCenter.defaultCenter().postNotificationName(sNotificationName_TapCatClick, object: nil, userInfo: nil)
    }
    
    // MARK:- SET
    var anchor : RoomYKModel?{
        
        didSet{
            
            guard let model = anchor else { return }
            let ffoptions = IJKFFOptions.optionsByDefault()
            ffoptions.setPlayerOptionValue("1", forKey: "an")
            // 硬解码
            ffoptions.setPlayerOptionValue("1", forKey: "videotoolbox")
            movieModel = IJKFFMoviePlayerController(contentURLString: model.flv ?? "", withOptions: ffoptions)
            movieModel!.view.frame = bounds
            movieModel!.view.layer.cornerRadius = frame.size.height * 0.5
            movieModel!.view.clipsToBounds = true
            movieModel!.scalingMode = .Fill
            movieModel!.shouldAutoplay = true
            addSubview(movieModel!.view)
            movieModel!.prepareToPlay()
        }
    }
    
    
    deinit{
        removeMovieModel()
    }
    
    override func removeFromSuperview() {
        
        removeMovieModel()
        
        super.removeFromSuperview()
    }
    
    func removeMovieModel(){
        if movieModel != nil{
            movieModel!.shutdown()
            movieModel!.view.removeFromSuperview()
            movieModel = nil
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- UI布局
extension ShowAnchorCatView {
    
    private func setupUI(){
        
        addSubview(catImageView)
        
        catImageView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self)
            make.height.equalTo(30)
        }
        
    }
}
