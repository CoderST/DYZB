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
    fileprivate let sMarginLR :CGFloat = 15
    fileprivate let sMarginT :CGFloat = 30
    
    // MARK:- 定义属性
    var playerController : IJKFFMoviePlayerController?
    /// 引用父控件
    weak var parentVc : UIViewController?
    
    var isTempSelected : Bool? = false
    /// 弹幕时间
    var barrageTime : Timer?
    /// 粒子时间
    var liziTime : Timer?
    
    // MARK:- 懒加载
    /// 顶部用户信息的view(头像,名称...)
    fileprivate lazy var userInforView : ShowAnchorHeardView = {
        let aa = ShowAnchorHeardView.creatShowAnchorHeardView()
        return aa
    }()
    /// 弹幕渲染器
    fileprivate lazy var renderer : BarrageRenderer = {
        
        let renderer = BarrageRenderer.init()
        renderer.canvasMargin = UIEdgeInsetsMake(sScreenH * 0.3, 10, 10, 10)
        renderer.view!.isUserInteractionEnabled = true;
        
        return renderer
        
    }()
    // 弹幕文本
    fileprivate lazy var danMuText : [String] = {
        
        guard let text = Bundle.main.path(forResource: "danmu.plist", ofType: nil) else { return [String]()}
        guard let textArray = NSArray(contentsOfFile: text) as?[String] else { return [String]()}
        
        return textArray
    }()
    // 底部的view
    fileprivate lazy var bottomView : RoomAchorBottomView = {
        let bottomView = RoomAchorBottomView()
        bottomView.delegate = self
        return bottomView
    }()
    // 展位图(模糊背景图)
    fileprivate lazy var placeHolderImageView : UIImageView = {
        
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
        selectionStyle = .none
        
        print(danMuText)
        
        // 1 添加子控件,初始化尺寸
        setupSubView()
        
        // 2 timenderBarrage))
        barrageTime = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ShowAnchorVCCell.autoSendBarrage), userInfo: nil, repeats: true)
        liziTime = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ShowAnchorVCCell.autoliziTimeAction), userInfo: nil, repeats: true)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userInforView.frame = CGRect(x: 0, y: 30, width: contentView.frame.size.width, height: 100)
    }
    
    // MARK:- SET方法
    var roomAnchor : RoomYKModel? {
        
        didSet{
            guard let roomA = roomAnchor else { return }
            // 1 传递主播数据
            userInforView.anchorModel = roomA
            // 2 控制弹幕
            isTempSelected = false
            // 3 弹幕停止
            renderer.stop()
            
            // 1 设置占位图
            if let imageUrl = URL(string: roomA.bigpic){
                // 1 显示占位图
                placeHolderImageView.isHidden = false
                // 2 下载占位URL图并高斯模糊
                SDWebImageDownloader.shared().downloadImage(with: imageUrl, options: .useNSURLCache, progress: nil, completed: { (image , data, error, finished) -> Void in
                    // 回到主线程刷新UI
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        // 3 加载gif动画
                        if finished{
                            
                            self.parentVc?.showGifLoading(nil, inView: self.placeHolderImageView)
                            if let safeImage = image{
                                
                                self.placeHolderImageView.image = UIImage.boxBlurImage(safeImage, withBlurNumber: 0.4)
                            }
                        }
                    })
                })
            }
        }
        
    }
    
    // 传递猫耳朵
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
    
    fileprivate func setupSubView(){
        contentView.addSubview(renderer.view!)
        contentView.sendSubview(toBack: renderer.view!)
        contentView.addSubview(placeHolderImageView)
        contentView.addSubview(bottomView)
        contentView.addSubview(userInforView)
        
        
        parentVc?.showGifLoading(nil, inView: placeHolderImageView)
        placeHolderImageView.snp.makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(contentView)
        }
        
        bottomView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(50)
        }
        
    }
    
    func addTapGestureRecognizer(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ShowAnchorVCCell.tapAction(_:)))
        contentView.addGestureRecognizer(tap)
    }
    
    func tapAction(_ action: UITapGestureRecognizer){
        
        autoliziTimeAction()
        
    }
    
    /**
     主播播放相关
     */
    func playingVideo(_ roomA : RoomYKModel){
        // 4.1 获取直播URL
            guard let url = URL(string: roomA.flv ) else { return }
            // 4.2 创建直播对象
            playerController = IJKFFMoviePlayerController(contentURL: url, with: nil)
            // 不打印
            IJKFFMoviePlayerController.setLogReport(false)
            IJKFFMoviePlayerController.setLogLevel(k_IJK_LOG_INFO)
            /*
             设置不报告日志
             [IJKFFMoviePlayerController setLogReport:NO];
             //  设置日志级别为信息
             [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
             */
            
            // 4.3 根据这个我们就可以在初始化播放器时对options进行调整(Options初始化不能少[IJKFFOptions.optionsByDefault())
            let options = IJKFFOptions.byDefault()
            options?.setPlayerOptionIntValue(1, forKey: "videotoolbox")
            // 4.4 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
            options?.setPlayerOptionIntValue(Int64(29.97), forKey: "r")
            // 4.5 -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
            options?.setPlayerOptionIntValue(513, forKey: "vol")
            // 5 设置playerController对象中VIEW的尺寸
            playerController!.view.frame = contentView.bounds
            // 6 填充fill
            playerController!.scalingMode = .fill
            // 7 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
            playerController!.shouldAutoplay = false
            // 8 默认不显示
            playerController!.shouldShowHudView = false
            // 9 添加到contentView的最底层
            contentView.insertSubview(playerController!.view, at: 0)
            // 10 播放准备
            playerController!.prepareToPlay()
            // 添加通知监听
            initObserver()
            
        
    }
    
    // 弹幕
    @objc fileprivate func autoSendBarrage(){
        let number = renderer.spritesNumber(withName: nil)
        if number <= 50 {
            guard let barrageWalkSide = BarrageWalkSide(rawValue: 0) else { return }
            renderer.receive(walkTextSpriteDescriptorWithDirection(uint(BarrageWalkDirection.R2L.rawValue)))
        }
        
    }
    // 粒子
    @objc fileprivate func autoliziTimeAction(){
        let liziAnimation = ZanAnimation.shareInstance
        if playerController != nil{
            
            liziAnimation.startAnimation(playerController!.view, center_X: sScreenW - 30, center_Y: sScreenH - 30)
        }
    }
    // 退出
    fileprivate func quit(){
        // 主播停播
        shutdownAction()
        // 副播停播
        catView.removeMovieModel()
        
        barrageTimeAction()
        
        invalidateliziTimeAction()
        
        rendererStopAction()
        
        if parentVc != nil{
            parentVc!.dismiss(animated: true, completion: nil)
            
        }
        print("RoomAnchorCell - 退出了")
    }
    
    // 播放器关闭
    func shutdownAction(){
        if playerController != nil{
            
            playerController?.pause()
            playerController?.stop()
            playerController?.shutdown()
            NotificationCenter.default.removeObserver(self)
        }
        
    }
    
    // 清除粒子time
    fileprivate func invalidateliziTimeAction(){
        liziTime?.invalidate()
        liziTime = nil
    }
    
    // 清除弹幕time
    fileprivate func barrageTimeAction(){
        
        barrageTime?.invalidate()
        barrageTime = nil
    }
    
    // 弹幕停止渲染
    fileprivate func rendererStopAction (){
        
        renderer.stop()
        renderer.view?.removeFromSuperview()
        
    }
    
    // MARK:- 直播监听通知
    func initObserver(){
        /*
         IJKMPMoviePlayerLoadStateDidChangeNotification(加载状态改变通知)
         IJKMPMoviePlayerPlaybackDidFinishNotification(播放结束通知)
         IJKMPMoviePlayerPlaybackStateDidChangeNotification(播放状态改变通知)
         */
        // 播放结束,或者 用户退出 通知
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAnchorVCCell.didFinishNotification), name:NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: playerController)
        
        // 加载 状态改变 通知
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAnchorVCCell.stateDidChangeNotification), name:NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: playerController)
        
    }
    
    // MARK:- 通知事件
    func didFinishNotification(){
        print("stststststst加载状态didFinishNotification.......", self.playerController!.loadState, self.playerController!.playbackState)
        
        if (playerController!.loadState.rawValue == 3){
            parentVc?.showGifLoading(nil, inView: playerController?.view)
            return
        }
        NetworkTools.requestData(.get, URLString: roomAnchor?.flv ?? "") { (result) -> () in
            print("请求成功,等待播放",result)
        }
        
    }
    
    func stateDidChangeNotification(){
        /*
         IJKMPMovieLoadStateUnknown        = 0,
         IJKMPMovieLoadStatePlayable       = 1 << 0,
         IJKMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
         IJKMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
         
         */
        let  loadState : IJKMPMovieLoadState = playerController!.loadState
        // loadState == 3 流畅   ==4网不好
        let playthroughOK : IJKMPMovieLoadState = IJKMPMovieLoadState.playthroughOK
        let Stalled : IJKMPMovieLoadState = IJKMPMovieLoadState.stalled
        
        print("ststststststateDidChangeNotification",loadState,playthroughOK,Stalled)
        //状态为缓冲几乎完成，可以连续播放
        if (loadState.rawValue != 0) && (playthroughOK.rawValue != 0) && loadState.rawValue == 3 {
            
            if playerController?.isPlaying() == false{
                //开始播放
                playerController?.play()
                contentView.addSubview(catView)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 *  NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    
                    self.placeHolderImageView.isHidden = true
                    self.playerController?.view.addSubview(self.renderer.view!)
                    self.parentVc?.hideGifLoading()
                })
                
            }else{
                // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
                if parentVc?.gifImageView?.isAnimating == true{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 *  NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        self.parentVc?.hideGifLoading()
                    })
                }
            }
            
        } else if (loadState.rawValue == 4) {  //缓冲中
            // 网速不佳, 自动暂停状态
            
            parentVc?.showGifLoading(nil, inView: parentVc?.view)
        } else {
            print("st_loadState",loadState)
        }
        
        
    }
    
    
    
    // MARK:- 界面销毁
    deinit{
        print("deinitdeinit")
        SDWebImageManager.shared().cancelAll()
        playerController?.shutdown()
        playerController = nil
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// MARK:- RoomAchorBottomViewDelegate:底部工具栏代理方法
extension ShowAnchorVCCell : RoomAchorBottomViewDelegate{
    func bottomViewClick(_ imageType: imageViewType) {
        
        switch imageType{
        case .danmu:
            if isTempSelected == false{
                isTempSelected = true
                renderer.start()
            }else{
                isTempSelected = false
                renderer.stop()
            }
        case .liaoTian:
            print("LiaoTian")
        case .liWu:
            print("LiWu")
        case .jiangBei:
            print("JiangBei")
        case .fenXiang:
            print("FenXiang")
        case .guanBi:
            print("GuanBi")
            quit()
        }
    }
    
}

// MARK:- 弹幕相关
extension ShowAnchorVCCell{
    func walkTextSpriteDescriptorWithDirection(_ direction : uint)->BarrageDescriptor{
        let descriptor = BarrageDescriptor()
        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        
        descriptor.params["text"] = danMuText[Int(arc4random_uniform((UInt32(danMuText.count))))]
        
        let color = UIColor(r: CGFloat(arc4random_uniform((UInt32(256)))), g: CGFloat(arc4random_uniform((UInt32(256)))), b: CGFloat(arc4random_uniform((UInt32(256)))))
        descriptor.params["textColor"] = color
        
        let speed = CGFloat(arc4random_uniform(100) + 50)
        descriptor.params["speed"] = speed
        return descriptor
        
        
        //        let descriptor:BarrageDescriptor = BarrageDescriptor()
        //        descriptor.spriteName = NSStringFromClass(BarrageWalkTextSprite.self)
        //        descriptor.params["text"] = danMuText[Int(arc4random())%(self.danMuText.count)]
        //        descriptor.params["textColor"] = UIColor(red: CGFloat(arc4random()%255) / 255, green: CGFloat(arc4random()%255) / 255, blue: CGFloat(arc4random()%255) / 255, alpha: 1)
        //        descriptor.params["speed"] = Int(arc4random()%100) + 50
        //        descriptor.params["direction"] = direction
        //        return descriptor
        
    }
    
    
}

extension ShowAnchorVCCell : ShowAnchorCatViewDelegate {
    
    // 实现长按手势代理
    func ShowAnchorCatViewLongPress(_ showAnchorCatView: ShowAnchorCatView, gesture: UIGestureRecognizer) {
        let state = gesture.state
        switch state {
        case .began:
            let point = gesture.location(in: self)
            ""
        case .changed:
            let oriPoint = gesture.location(in: self)
            let translation = gesture.location(in: self)
            gesture.view?.center = CGPoint(x: oriPoint.x + translation.x, y: oriPoint.y + translation.y)
            let supViewPoint = convert(oriPoint, to: contentView)
            catView.center = supViewPoint
        default:
            "default"
        }
    }
    
}
