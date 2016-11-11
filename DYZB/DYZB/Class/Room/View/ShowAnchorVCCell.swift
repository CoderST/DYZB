//
//  RoomAnchorCell.swift
//  DYZB
//
//  Created by xiudou on 16/10/31.
//  Copyright © 2016年 xiudo. All rights reserved.
//  直播显示的cell(可以上下滚动)

// MARK:- 92行添加手势后会与ShowAnchorHeardView里的代理点击事件冲突,待解决

import UIKit
import SDWebImage
import BarrageRenderer
import IJKMediaFramework
class ShowAnchorVCCell: UITableViewCell {
    
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
    /// 顶部用户信息的view
    private lazy var userInforView : ShowAnchorHeardView = {
        let aa = ShowAnchorHeardView.creatShowAnchorHeardView()
        return aa
    }()
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
     // 🐱👂
     lazy var catView : ShowAnchorCatView = {[weak self] in
        let catView = ShowAnchorCatView()
        catView.frame = CGRect(x: sScreenW - 100, y: 250, width: 100, height: 100)
        catView.center = CGPoint(x: sScreenW - 100 * 0.6, y: 250)
        catView.layer.cornerRadius = catView.frame.size.height * 0.5
        catView.delegate = self
        return catView
        
    }()
    
       
    
        // MARK:- 系统回调
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 去除选中状态
        selectionStyle = .None

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
        
        // 0 添加用户信息的view
        contentView.addSubview(userInforView)
        
       }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userInforView.frame = CGRect(x: 0, y: 30, width: contentView.frame.size.width, height: 100)
    }
    
    // MARK:- SET方法
    var roomAnchor : RoomYKModel? {
        
        didSet{
            guard let roomA = roomAnchor else { return }
            userInforView.anchorModel = roomA
            isSelected = false
            renderer.stop()
            if playerVC != nil{
                contentView.insertSubview(placeHolderImageView, aboveSubview: playerVC!.view)
                playerVC!.shutdown()
                playerVC!.view.removeFromSuperview()
                playerVC = nil;
                
            }
            // 1 设置占位图
            if let imageUrl = NSURL(string: roomA.bigpic){
                // 1 显示占位图
                placeHolderImageView.hidden = false
                // 2 下载占位URL图并高斯模糊
                SDWebImageDownloader.sharedDownloader().downloadImageWithURL(imageUrl, options: .UseNSURLCache, progress: nil, completed: { (image , data, error, finished) -> Void in
                    // 回到主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // 3 加载gif动画
                        if finished{
                            
                            self.parentVc?.showGifLoading(nil, inView: self.placeHolderImageView)
                            self.placeHolderImageView.image = UIImage.boxBlurImage(image, withBlurNumber: 0.4)
                        }
                    })
                })
            }
        }
        
    }
    
    var subAnchorModel : RoomYKModel?{
        didSet{
            
            guard let model = subAnchorModel else { return }
   
            // 复原位置
             catView.center = CGPoint(x: sScreenW - 100 * 0.6, y: 250)
//            catView.setNeedsLayout()
            catView.anchor = model
        }
    }
    
    // MARK:- 自定义方法
    
    func addTapGestureRecognizer(){
        
        let tap = UITapGestureRecognizer(target: self, action: "tapAction:")
        contentView.addGestureRecognizer(tap)
    }
    
    func tapAction(action: UITapGestureRecognizer){
        
            autoliziTimeAction()
        
    }
    
    
     func playingWithPlaceHoldImageView(roomA : RoomYKModel){
        
        if playerVC != nil{
            shutdownAction()
            playerVCQuit()
            playerVC?.view.removeFromSuperview()
            playerVC = nil
        }
       
        
               // 4.1 获取直播URL
        guard let url = NSURL(string: roomA.flv ?? "") else { return }
        // 4.2 创建直播对象
         playerVC = IJKFFMoviePlayerController(contentURL: url, withOptions: nil)
        // 不打印
        IJKFFMoviePlayerController.setLogReport(false)
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
        // 添加通知
        initObserver()
        
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
        if playerVC != nil{
            
            liziAnimation.startAnimation(playerVC!.view, center_X: sScreenW - 30, center_Y: sScreenH - 30)
        }
    }
    
    func quit(){
        
        shutdownAction()
        
        barrageTimeAction()
        
        invalidateliziTimeAction()
        
        rendererAction()
        
        playerVCQuit()
        
        parentVc!.dismissViewControllerAnimated(true, completion: nil)
        
        
        print("RoomAnchorCell - 退出了")
    }
    
    func shutdownAction(){
        if playerVC != nil{
            playerVC?.shutdown()
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
    }
    
    func invalidateliziTimeAction(){
        liziTime?.invalidate()
        liziTime = nil
    }
    
    func barrageTimeAction(){
        
        barrageTime?.invalidate()
        barrageTime = nil
    }
    
    // 弹幕渲染器
    func rendererAction (){
        
        renderer.stop()
        renderer.view?.removeFromSuperview()
        
    }
    
    // MARK:- 监听通知
    func initObserver(){
        // 播放结束通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishNotification", name:IJKMPMoviePlayerPlaybackDidFinishNotification, object: playerVC)
        
        // 加载状态改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stateDidChangeNotification", name:IJKMPMoviePlayerLoadStateDidChangeNotification, object: playerVC)
              
    }
    
    // MARK:- 通知事件
    func didFinishNotification(){
        //加载状态....... IJKMPMovieLoadState(rawValue: 3) IJKMPMoviePlaybackState
        print("加载状态didFinishNotification.......", self.playerVC!.loadState, self.playerVC!.playbackState)
        // IJKMPMovieLoadStateStalled
        if (playerVC!.loadState.rawValue == 4){
            parentVc?.showGifLoading(nil, inView: playerVC?.view)
            
            return
        }
        NetworkTools.requestData(.GET, URLString: roomAnchor?.flv ?? "") { (result) -> () in
            print("请求成功,等待播放",result)
        }
        
    }
    
    func stateDidChangeNotification(){
        print("加载状态stateDidChangeNotification.......", self.playerVC!.loadState)
        print(IJKMPMovieLoadState.Playable.rawValue,IJKMPMovieLoadState.PlaythroughOK.rawValue)
//        let type = IJKMPMovieLoadState.Playable.rawValue
        if (playerVC?.loadState.rawValue != IJKMPMovieLoadState.Stalled.rawValue){
            if playerVC?.isPlaying() == false{
                playerVC?.play()
                 contentView.addSubview(catView)
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 *  NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    
                    self.placeHolderImageView.hidden = true
                    self.playerVC?.view.addSubview(self.renderer.view!)
                    //
                })
                if let imageView = parentVc?.gifImageView {
                    
                    if imageView.isAnimating() == true{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 *  NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            
                            self.parentVc?.hideGifLoading()
                        })
                    }
                    
                }
                
            }else{
                if let imageView = parentVc?.gifImageView{
                    
                    if imageView.isAnimating() == true{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 *  NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                            
                            self.parentVc?.hideGifLoading()
                        })
                    }
                }
            }
        }else if(playerVC?.loadState.rawValue == 4){
            parentVc?.showGifLoading(nil, inView: playerVC?.view)
        }
        
    }
    
       
    
    // MARK:- 界面销毁
    deinit{
        SDWebImageManager.sharedManager().cancelAll()
        playerVCQuit()
        
    }
    
    func playerVCQuit(){
        playerVC?.pause()
        playerVC?.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK:- RoomAchorBottomViewDelegate:底部工具栏代理方法
extension ShowAnchorVCCell : RoomAchorBottomViewDelegate{
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
extension ShowAnchorVCCell{
    /// 过场文字弹幕(⚠️这里的类型一定要写BarrageWalkSide,之前写Uint,怎么都出不来,没搞好,如果你用Uint能出来,请联系我QQ:694468528,非常谢谢~~)
    func walkTextSpriteDescriptorWithDirection(direction : BarrageWalkSide)->BarrageDescriptor{
        let descriptor = BarrageDescriptor()
        descriptor.spriteName = String(BarrageWalkTextSprite)
        
        descriptor.params["text"] = danMuText[Int(arc4random_uniform((UInt32(danMuText.count))))]
        
        let color = UIColor(r: CGFloat(arc4random_uniform((UInt32(256)))), g: CGFloat(arc4random_uniform((UInt32(256)))), b: CGFloat(arc4random_uniform((UInt32(256)))))
        descriptor.params["textColor"] = color
        
        let speed = CGFloat(arc4random_uniform(100) + 50)
        descriptor.params["speed"] = speed
        return descriptor
    }
    
    
}

extension ShowAnchorVCCell : ShowAnchorCatViewDelegate {
    
    // 实现长按手势代理
    func ShowAnchorCatViewLongPress(showAnchorCatView: ShowAnchorCatView, gesture: UIGestureRecognizer) {
                let state = gesture.state
                switch state {
                case .Began:
                    let point = gesture.locationInView(self)
                    ""
                case .Changed:
                    let oriPoint = gesture.locationInView(self)
                    let translation = gesture.locationInView(self)
                    gesture.view?.center = CGPoint(x: oriPoint.x + translation.x, y: oriPoint.y + translation.y)
                    let supViewPoint = convertPoint(oriPoint, toView: contentView)
                    catView.center = supViewPoint
                default:
                    "default"
                }
    }
    
}