//
//  RoomAnchorCell.swift
//  DYZB
//
//  Created by xiudou on 16/10/31.
//  Copyright © 2016年 xiudo. All rights reserved.
//  直播显示的cell

import UIKit
import SDWebImage
import BarrageRenderer
import IJKMediaFramework
class RoomAnchorCell: UITableViewCell {
    
    // MARK:- 常量
    private let sMarginLR :CGFloat = 15
    private let sMarginT :CGFloat = 30
    
    // MARK:- 定义属性
    var playerVC : IJKFFMoviePlayerController?
    
    weak var parentVc : UIViewController?
    
    var isSelected : Bool? = false
    /// 弹幕时间
    var barrageTime : NSTimer?
    /// 粒子时间
    var liziTime : NSTimer?
    
    // MARK:- 懒加载
    /// 弹幕渲染器
    private lazy var renderer : BarrageRenderer = {
       
        let renderer = BarrageRenderer()
        
        return renderer
        
    }()
    // 弹幕文本
    private lazy var danMuText : [String] = {
        
        guard let text = NSBundle.mainBundle().pathForResource("danmu.plist", ofType: nil) else { return [String]()}
        guard let textArray = NSArray(contentsOfFile: text) as?[String] else { return [String]()}
        
        return textArray
    }()

    
    // 底部的view
    private lazy var bottomView : RoomAchorBottomView = RoomAchorBottomView()
    // 展位图
    private lazy var placeHolderImageView : UIImageView = {
        
        let placeHolderImageView = UIImageView()
        return placeHolderImageView
    }()
    
    // MARK:- 系统回调
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 1 danmu
        
        contentView.addSubview(renderer.view!)
        renderer.canvasMargin = UIEdgeInsetsMake(sScreenH * 0.3, 10, 10, 10)
        renderer.view!.userInteractionEnabled = true;
        contentView.sendSubviewToBack(renderer.view!)
        
        // 2 time
         barrageTime = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "autoSendBarrage", userInfo: nil, repeats: true)
        liziTime = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "autoliziTimeAction", userInfo: nil, repeats: true)
        
        parentVc?.showGifLoading(nil, inView: placeHolderImageView)
        contentView.addSubview(placeHolderImageView)
        contentView.addSubview(bottomView)
        bottomView.delegate = self
        placeHolderImageView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(contentView)
        }
        
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        
    }
    
    // MARK:- SET方法
    var roomAnchor : RoomYKModel? {
        
        didSet{
            guard let roomA = roomAnchor else { return }
            isSelected = false
            renderer.stop()
            if playerVC != nil{
                contentView.insertSubview(placeHolderImageView, aboveSubview: playerVC!.view)
                playerVC!.shutdown()
                playerVC!.view.removeFromSuperview()
                playerVC = nil;
                NSNotificationCenter.defaultCenter().removeObserver(self)
                
            }
            
            
            playingWithPlaceHoldImageView(roomA)
            // 设置监听
            initObserver()
        }
        
    }
    
    // MARK:- 自定义方法
    
    
    private func playingWithPlaceHoldImageView(roomA : RoomYKModel){
        // 1 设置占位图
        if let imageUrl = NSURL(string: roomA.bigpic){
            // 1 显示占位图
            placeHolderImageView.hidden = false
            // 2 下载占位URL图并高斯模糊
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(imageUrl, options: .UseNSURLCache, progress: nil, completed: { (image , data, error, finished) -> Void in
                // 回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // 3 加载gif动画
                    self.parentVc?.showGifLoading(nil, inView: self.placeHolderImageView)
                    self.placeHolderImageView.image = UIImage.boxBlurImage(image, withBlurNumber: 0.4)
                })
            })
        }
        // 4.1 获取直播URL
        guard let url = NSURL(string: roomA.flv ?? "") else { return }
        // 4.2 创建直播对象
        playerVC = IJKFFMoviePlayerController(contentURL: url, withOptions: nil)
        // 4.3 根据这个我们就可以在初始化播放器时对options进行调整(Options初始化不能少[IJKFFOptions.optionsByDefault())
        let options = IJKFFOptions.optionsByDefault()
        options.setPlayerOptionIntValue(1, forKey: "videotoolbox")
        // 4.4 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
        options.setPlayerOptionIntValue(Int64(29.97), forKey: "r")
        // 4.5 -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
        options.setPlayerOptionIntValue(513, forKey: "vol")
        // 5 设置playerVC对象中VIEW的尺寸
        playerVC?.view.frame = contentView.bounds
        // 6 填充fill
        playerVC?.scalingMode = .Fill
        // 7 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
        playerVC?.shouldAutoplay = false
        // 8 默认不显示
        playerVC?.shouldShowHudView = false
        // 9 添加到contentView的最底层
        contentView.insertSubview(playerVC!.view, atIndex: 0)
        // 10 播放准备
        playerVC!.prepareToPlay()
        
    }
    
     func autoSendBarrage(){
        let number = renderer.spritesNumberWithName(nil)
        if number <= 50 {
            guard let barrageWalkSide = BarrageWalkSide(rawValue: 0) else { return }
            renderer.receive(walkTextSpriteDescriptorWithDirection(barrageWalkSide))
        }
        
    }
    
    func autoliziTimeAction(){
        let liziAnimation = ZanAnimation.shareInstance
        liziAnimation.startAnimation(playerVC!.view, center_X: sScreenW - 30, center_Y: sScreenH - 30)
    }
    
    func quit(){
        if playerVC != nil{
            playerVC?.shutdown()
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        barrageTime?.invalidate()
        barrageTime = nil
        
        liziTime?.invalidate()
        liziTime = nil
        
        renderer.stop()
        renderer.view?.removeFromSuperview()
        
        parentVc!.dismissViewControllerAnimated(true, completion: nil)


    }
    
    // MARK:- 监听通知
    func initObserver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishNotification", name:IJKMPMoviePlayerPlaybackDidFinishNotification, object: playerVC)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateDidChangeNotification", name:IJKMPMoviePlayerLoadStateDidChangeNotification, object: playerVC)
        
        
    }
    // MARK:- 通知事件
    func didFinishNotification(){
        //加载状态....... IJKMPMovieLoadState(rawValue: 3) IJKMPMoviePlaybackState
        print("加载状态.......", self.playerVC!.loadState, self.playerVC!.playbackState)
        // IJKMPMovieLoadStateStalled
        if (playerVC?.loadState != nil && parentVc?.getGifImageView() == nil ){
            parentVc?.showGifLoading(nil, inView: playerVC?.view)
            
            return
        }
        NetworkTools.requestData(.GET, URLString: roomAnchor?.flv ?? "") { (result) -> () in
            print("请求成功,等待播放",result)
        }
 
    }
    
    func stateDidChangeNotification(){
        if (playerVC?.loadState != nil &&  IJKMPMovieLoadState.PlaythroughOK != .Unknown){
            if playerVC?.isPlaying() == false{
                playerVC?.play()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 *  NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    
                    self.placeHolderImageView.hidden = true
                    self.playerVC?.view.addSubview(self.renderer.view!)
                    
                })

                
            }else{
                let imageView = parentVc?.getGifImageView() as? UIImageView
                if imageView?.isAnimating() == true{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 *  NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                        
                        self.parentVc?.hideGifLoading()
                    })
                }
            }
        }else if(playerVC?.loadState != nil){
            parentVc?.showGifLoading(nil, inView: playerVC?.view)
            print("网络不好")
        }
        
    }
    
    
    // MARK:- 界面销毁
    deinit{
        playerVC?.pause()
        playerVC?.stop()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK:- RoomAchorBottomViewDelegate:底部工具栏代理方法
extension RoomAnchorCell : RoomAchorBottomViewDelegate{
    func bottomViewClick(imageType: imageViewType) {
        
        switch imageType{
        case .Danmu:
            if isSelected == false{
                isSelected = true
                renderer.start()
            }else{
                isSelected = false
                renderer.stop()
            }
        case .LiaoTian:
            print("LiaoTian")
        case .LiWu:
            print("LiWu")
        case .JiangBei:
            print("JiangBei")
        case .FenXiang:
            print("FenXiang")
        case .GuanBi:
            print("GuanBi")
            quit()
        }
    }
    
}

// MARK:- 弹幕相关
extension RoomAnchorCell{
    /// 过场文字弹幕(⚠️这里的类型一定要写BarrageWalkSide,之前写Uint,怎么都出不来,没搞好,如果你用Uint能出来,请联系我QQ:694468528,非常谢谢~~)
    func walkTextSpriteDescriptorWithDirection(direction : BarrageWalkSide)->BarrageDescriptor{
        let descriptor = BarrageDescriptor()
        descriptor.spriteName = String(BarrageWalkTextSprite)
        
        descriptor.params["text"] = danMuText[Int(arc4random_uniform((UInt32(danMuText.count))))]

        let color = UIColor(r: CGFloat(arc4random_uniform((UInt32(256)))), g: CGFloat(arc4random_uniform((UInt32(256)))), b: CGFloat(arc4random_uniform((UInt32(256)))))
        descriptor.params["textColor"] = color
        
        let speed = CGFloat(arc4random_uniform(100) + 50)
        descriptor.params["speed"] = speed
        
//        descriptor.params["direction"] = direction
        return descriptor
    }
    

}




