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
    fileprivate let sEdiMargin : CGFloat = 15
    fileprivate let sTopMargin : CGFloat = 30
    fileprivate let startLiveingBtnH : CGFloat = 50
    fileprivate let sStatusLabelFontSize : CGFloat = 12
    // MARK:- 自定义属性
    var rtmpUrl : String = ""
    
    // MARK:- 懒加载
    fileprivate lazy var livingPreView : UIView = {
       
        let livingPreView = UIView()
//        livingPreView.frame = self.view.bounds
//        livingPreView.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.view.insertSubview(livingPreView, at: 0)
        return livingPreView
        
    }()
    /// 关闭直播
    fileprivate lazy var closeLiveingBtn : UIButton = {
        
        let closeLiveingBtn = UIButton ()
        closeLiveingBtn.setTitle("关闭直播", for: UIControlState())
        closeLiveingBtn.setTitleColor(UIColor.white, for: UIControlState())
        closeLiveingBtn.addTarget(self, action: #selector(ShowBaseSanFangViewController.closeLiveingBtnClick), for: .touchUpInside)
        return closeLiveingBtn
        
    }()
    /// 状态label
    fileprivate lazy var statusLabel : UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: self.sStatusLabelFontSize)
        statusLabel.text = "状态:未知"
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.white
        return statusLabel
    }()
    /// 美颜
    fileprivate lazy var beautifulBtn : UIButton = {
        let beautifulBtn = UIButton ()
        beautifulBtn.setTitle("开启美颜", for: .selected)
        beautifulBtn.setTitle("关闭美颜", for: UIControlState())
        beautifulBtn.setTitleColor(UIColor.white, for: UIControlState())
        beautifulBtn.addTarget(self, action: #selector(ShowBaseSanFangViewController.beautifulFaceClick(_:)), for: .touchUpInside)
        return beautifulBtn
        
    }()
    /// 开始直播
    fileprivate lazy var startLiveingBtn : UIButton = {
        let startLiveingBtn = UIButton ()
        startLiveingBtn.backgroundColor = UIColor.red
        startLiveingBtn.setTitle("开始直播", for: UIControlState())
        startLiveingBtn.setTitle("结束直播", for: .selected)
        startLiveingBtn.setTitleColor(UIColor.white, for: UIControlState())
        startLiveingBtn.layer.cornerRadius = self.startLiveingBtnH * 0.5
        startLiveingBtn.addTarget(self, action: #selector(ShowBaseSanFangViewController.startLiveingBtnClick(_:)), for: .touchUpInside)
        startLiveingBtn.setTitleColor(UIColor.black, for: UIControlState())
        return startLiveingBtn
        
    }()
    /// 调换摄像头方向
    fileprivate lazy var switchCameraDirectionBtn : UIButton = {
        let switchCameraDirectionBtn = UIButton()
        switchCameraDirectionBtn.setTitle("前摄像头", for: UIControlState())
        switchCameraDirectionBtn.setTitle("后摄像头", for: .selected)
        switchCameraDirectionBtn.addTarget(self, action: #selector(ShowBaseSanFangViewController.switchCameraDirectionBtnClick(_:)), for: .touchUpInside)
        return switchCameraDirectionBtn
        
    }()
    /// session
    fileprivate lazy var session : LFLiveSession = {
       
        let session = LFLiveSession(audioConfiguration: LFLiveAudioConfiguration.default(), videoConfiguration: LFLiveVideoConfiguration.defaultConfiguration(for: .medium2))
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
        view.backgroundColor = UIColor.white
        setupUI()
        session.captureDevicePosition = .front
        
        print("pppp",closeLiveingBtn)
    }
    
    // MARK:- 按钮点击
    // 关闭直播
    @objc fileprivate func closeLiveingBtnClick(){

        if session.state == .pending || session.state == .start{
            session.stopLive()
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 开始直播
    @objc fileprivate func startLiveingBtnClick(_ button:UIButton){
        button.isSelected = !button.isSelected
        
        if button.isSelected{
            // 开始直播
            let stream = LFLiveStreamInfo() // 192.168.31.173
            stream.url = "rtmp://192.168.31.173:1935/rtmplive/room"
            rtmpUrl = stream.url
            session.startLive(stream)
        }else{
            // 关闭直播
            session.stopLive()
            statusLabel.text = "直播关闭"
        }
        
        
        
    }
    
    // 美颜
    @objc fileprivate func beautifulFaceClick(_ button: UIButton){
        button.isSelected = !button.isSelected;
        // 默认是开启了美颜功能的
        session.beautyFace = !self.session.beautyFace;
    }
    
    // 调换摄像头方向
    @objc fileprivate func switchCameraDirectionBtnClick(_ button : UIButton){
        
        let direction = session.captureDevicePosition
        session.captureDevicePosition = (direction == AVCaptureDevicePosition.front ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front)
        
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
        closeLiveingBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(-sEdiMargin)
            make.top.equalTo(sTopMargin)
        }
        
        // 美颜
        beautifulBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(sEdiMargin)
            make.top.equalTo(sTopMargin)
        }
        
        // session
        livingPreView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        // 状态Label
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(150)
            make.top.equalTo(100)
        }
        
        startLiveingBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(sEdiMargin)
            make.right.equalTo(-sEdiMargin)
            make.bottom.equalTo(-sTopMargin)
            make.height.equalTo(startLiveingBtnH)
        }
        
        switchCameraDirectionBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(beautifulBtn)
            make.top.equalTo(beautifulBtn.snp.bottom).offset(sTopMargin)
        }
        
    }
}

extension ShowBaseSanFangViewController:LFLiveSessionDelegate {
    
    /** live status changed will callback */
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState){

        var tempState = ""
        switch state{
        case .ready:
            tempState = "准备中"
        case .pending:
            tempState = "链接中"
        case .start:
            tempState = "已链接"
        case .stop:
            tempState = "已断开"
        case .error:
            tempState = "连接出错"
            
        default: break
        }
        statusLabel.text = "状态:"+tempState
        
    }
    /** live debug info callback */
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?){
        print("sssssssslive debug",debugInfo!)
    }
    /** callback socket errorcode */
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode){
        print("sssssssscallback socket",errorCode)
    }
}
