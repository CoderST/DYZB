//
//  ShowBaseSanFangViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import SnapKit
import LFLiveKit
class ShowBaseSanFangViewController: UIViewController {

    // MARK:- 常量
    private let sEdiMargin : CGFloat = 15
    private let sTopMargin : CGFloat = 30
    private let startLiveingBtnH : CGFloat = 50
    private let sStatusLabelFontSize : CGFloat = 12
    // MARK:- 自定义属性
    var rtmpUrl : String = ""
    
    // MARK:- 懒加载
    private lazy var livingPreView : UIView = {
       
        let livingPreView = UIView()
//        livingPreView.frame = self.view.bounds
//        livingPreView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.view.insertSubview(livingPreView, atIndex: 0)
        return livingPreView
        
    }()
    /// 关闭直播
    private lazy var closeLiveingBtn : UIButton = {
        
        let closeLiveingBtn = UIButton ()
        closeLiveingBtn.setTitle("关闭直播", forState: .Normal)
        closeLiveingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeLiveingBtn.addTarget(self, action: "closeLiveingBtnClick", forControlEvents: .TouchUpInside)
        return closeLiveingBtn
        
    }()
    /// 状态label
    private lazy var statusLabel : UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFontOfSize(self.sStatusLabelFontSize)
        statusLabel.text = "状态:未知"
        statusLabel.textAlignment = .Center
        statusLabel.textColor = UIColor.whiteColor()
        return statusLabel
    }()
    /// 美颜
    private lazy var beautifulBtn : UIButton = {
        let beautifulBtn = UIButton ()
        beautifulBtn.setTitle("开启美颜", forState: .Selected)
        beautifulBtn.setTitle("关闭美颜", forState: .Normal)
        beautifulBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        beautifulBtn.addTarget(self, action: "beautifulFaceClick:", forControlEvents: .TouchUpInside)
        return beautifulBtn
        
    }()
    /// 开始直播
    private lazy var startLiveingBtn : UIButton = {
        let startLiveingBtn = UIButton ()
        startLiveingBtn.backgroundColor = UIColor.redColor()
        startLiveingBtn.setTitle("开始直播", forState: .Normal)
        startLiveingBtn.setTitle("结束直播", forState: .Selected)
        startLiveingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startLiveingBtn.layer.cornerRadius = self.startLiveingBtnH * 0.5
        startLiveingBtn.addTarget(self, action: "startLiveingBtnClick:", forControlEvents: .TouchUpInside)
        startLiveingBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return startLiveingBtn
        
    }()
    /// 调换摄像头方向
    private lazy var switchCameraDirectionBtn : UIButton = {
        let switchCameraDirectionBtn = UIButton()
        switchCameraDirectionBtn.setTitle("前摄像头", forState: .Normal)
        switchCameraDirectionBtn.setTitle("后摄像头", forState: .Selected)
        switchCameraDirectionBtn.addTarget(self, action: "switchCameraDirectionBtnClick:", forControlEvents: .TouchUpInside)
        return switchCameraDirectionBtn
        
    }()
    /// session
    private lazy var session : LFLiveSession = {
       
        let session = LFLiveSession(audioConfiguration: LFLiveAudioConfiguration.defaultConfiguration(), videoConfiguration: LFLiveVideoConfiguration.defaultConfigurationForQuality(.Medium2))
//        
//        let session = LFLiveSession(audioConfiguration: LFLiveAudioConfiguration.defaultConfiguration(), videoConfiguration: LFLiveVideoConfiguration.defaultConfigurationForQuality(.Medium2), captureType: LFLiveCaptureTypeMask.CaptureMaskAll)
        
//        LFLiveSession.init(audioConfiguration: <#T##LFLiveAudioConfiguration?#>, videoConfiguration: <#T##LFLiveVideoConfiguration?#>)
        
        session?.delegate = self
        session?.running = true
        session?.preView = self.livingPreView
        
        return session!
        
    }()
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
        session.captureDevicePosition = .Front
        
        print("pppp",closeLiveingBtn)
    }
    
    // MARK:- 按钮点击
    // 关闭直播
    @objc private func closeLiveingBtnClick(){

        if session.state == .Pending || session.state == .Start{
            session.stopLive()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 开始直播
    @objc private func startLiveingBtnClick(button:UIButton){
        button.selected = !button.selected
        
        if button.selected{
            // 开始直播
            let stream = LFLiveStreamInfo()
            stream.url = "rtmp://192.168.1.101:1935/rtmplive/room"
            rtmpUrl = stream.url
            session.startLive(stream)
        }else{
            // 关闭直播
            session.stopLive()
            statusLabel.text = "直播关闭"
        }
        
        
        
    }
    
    // 美颜
    @objc private func beautifulFaceClick(button: UIButton){
        button.selected = !button.selected;
        // 默认是开启了美颜功能的
        session.beautyFace = !self.session.beautyFace;
    }
    
    // 调换摄像头方向
    @objc private func switchCameraDirectionBtnClick(button : UIButton){
        
        let direction = session.captureDevicePosition
        session.captureDevicePosition = (direction == AVCaptureDevicePosition.Front ? AVCaptureDevicePosition.Back : AVCaptureDevicePosition.Front)
        
    }

}

// MARK:- 设置UI界面
extension ShowBaseSanFangViewController {
    
    func setupUI(){
        view.addSubview(closeLiveingBtn)
        view.addSubview(statusLabel)
        view.addSubview(beautifulBtn)
        view.addSubview(startLiveingBtn)
        view.addSubview(switchCameraDirectionBtn)
        
        // 关闭
        closeLiveingBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-sEdiMargin)
            make.top.equalTo(sTopMargin)
        }
        
        // 美颜
        beautifulBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(sEdiMargin)
            make.top.equalTo(sTopMargin)
        }
        
        // session
        livingPreView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        // 状态Label
        statusLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(150)
            make.top.equalTo(100)
        }
        
        startLiveingBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(sEdiMargin)
            make.right.equalTo(-sEdiMargin)
            make.bottom.equalTo(-sTopMargin)
            make.height.equalTo(startLiveingBtnH)
        }
        
        switchCameraDirectionBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(beautifulBtn)
            make.top.equalTo(beautifulBtn.snp_bottom).offset(sTopMargin)
        }
        
    }
}

extension ShowBaseSanFangViewController:LFLiveSessionDelegate {
    
    /** live status changed will callback */
    func liveSession(session: LFLiveSession?, liveStateDidChange state: LFLiveState){

        var tempState = ""
        switch state{
        case .Ready:
            tempState = "准备中"
        case .Pending:
            tempState = "链接中"
        case .Start:
            tempState = "已链接"
        case .Stop:
            tempState = "已断开"
        case .Error:
            tempState = "连接出错"
            
        default: break
        }
        statusLabel.text = "状态:"+tempState
        
    }
    /** live debug info callback */
    func liveSession(session: LFLiveSession?, debugInfo: LFLiveDebug?){
        print("live debug")
    }
    /** callback socket errorcode */
    func liveSession(session: LFLiveSession?, errorCode: LFLiveSocketErrorCode){
        print("callback socket")
    }
}
