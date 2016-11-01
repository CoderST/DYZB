//
//  BaseShowViewController.swift
//  DYZB
//
//  Created by xiudou on 16/10/30.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import AVFoundation

// 判断是否为真机
struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class BaseShowViewController: UIViewController {
    
    // MARK:- 常量
    private let sButtonY : CGFloat = 80
    private let sButtonW : CGFloat = 150
    private let sButtonH : CGFloat = 30
    
    // MARK:- 属性
    /// The AVCaptureConnection from which the audio was received
    var videoConnect : AVCaptureConnection?
    /// 要显示的layer
    var previewLayer : CALayer?
    /// 当前设备摄像头方向
    var currentDeviceInput : AVCaptureDeviceInput?
    
    // MARK:- 懒加载
    private lazy var switchCameraButton : UIButton = {
        let button = UIButton()
        button.setTitle("前后摄像头转换", forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.addTarget(self, action: "switchCameraButtonClick", forControlEvents: .TouchUpInside)
        return button
    }()
    private lazy var captureSession : AVCaptureSession = AVCaptureSession()
    private lazy var movieFileOutput : AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()

    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()

                view.backgroundColor = UIColor.whiteColor()
                view.addSubview(switchCameraButton)
                switchCameraButton.frame = CGRect(x: sScreenW - sButtonW, y: sButtonY, width: sButtonW, height: sButtonH)
        //        let captureSession = AVCaptureSession()
        
                deviceTest()
        
                        //        setupMovieFileOutput()
    }


}

// MARK:- 按钮点击事件
extension BaseShowViewController {
    @objc private func switchCameraButtonClick() {
        // 1 当前的videoInput
        guard let videoInput = currentDeviceInput else { return }
        // 2 需要获得的方向
        let position  = videoInput.device.position == AVCaptureDevicePosition.Front ? AVCaptureDevicePosition.Back : AVCaptureDevicePosition.Front
        // 3 获取AVCaptureDevice数组
        guard let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as? [AVCaptureDevice] else { return }

        // 4 获得新的设备
        var newDevice : AVCaptureDevice?
        for devi in devices{
            if devi.position == position{
                newDevice = devi
            }
        }

        // 5 创建新的input
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newDevice) else { return }

        // 6 配置
        captureSession.beginConfiguration()
        captureSession.removeInput(videoInput)
        captureSession.addInput(newVideoInput)
        captureSession.commitConfiguration()

        // 7 赋值
        currentDeviceInput = newVideoInput


    }
}


// 设备验证
extension BaseShowViewController {
    
//    func setup() {
    
        func deviceTest() {
            
            if Platform.isSimulator {
                // Do one thing
                print("请用真机进行测试, 此模块不支持模拟器测试")
            }
            else {
                
                
                // 2 判断是否有摄像头
                if ( !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                    print("您的设备没有摄像头或者相关的驱动, 不能进行直播")
                    return
                }
                
                // 3 判断是否有摄像头权限
                // 3.1 获取状态
                let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
                // 3.2 判断各种状态
                if (authorizationStatus == .Restricted || authorizationStatus == .Denied){
                    print("APP需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头")
                    return
                }
                
                // 4 判断是否开启麦克风
                let audioSession = AVAudioSession.sharedInstance()
                let selector = Selector("requestRecordPermission:")
                if (audioSession .respondsToSelector(selector)){
//                    audioSession.performSelector(selector)
                    
                }else{
                    print("APP需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风")
                    
                    return
                }

                shouQuan()
                setupVideo()
                setupAudio()
                addShowAnimation()
                captureSession.startRunning()

            
            }
            
     
            
        }

//    }
}

// 授权
extension BaseShowViewController {
    
    func shouQuan(){
        let authorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authorizationStatus {
        case .NotDetermined:
            // 许可对话没有出现，发起授权许可
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo,
                completionHandler: { (granted:Bool) -> Void in
                    if granted {
                        // 继续
                        print("继续")
                    }
                    else {
                        print("用户拒绝，无法继续")
                    }
            })
        case .Authorized: break
            // 继续
        case .Denied, .Restricted: break
            // 用户明确地拒绝授权，或者相机设备无法访问
        }
    }

}

// 初始化视频
extension BaseShowViewController {
    
    func setupVideo(){
        
        // 1 获取设备
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        var device : AVCaptureDevice?
        for devi in devices{
            if devi.position == .Front{
                device = devi
            }
        }
        
        // 2 获取输入源
        guard let videoInput = try? AVCaptureDeviceInput(device: device) else { return }
        currentDeviceInput = videoInput
        
        // 3 获得输出源
        let videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
        }
        
        videoConnect = videoOutput.connectionWithMediaType(AVMediaTypeVideo)
    }

}

// 初始化音频
extension BaseShowViewController {
    
    func setupAudio(){
        
        // 1 获取设备
        guard let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio) else { return }
        
        // 2 获取输入源
        guard let audioInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        // 3 获取输出源
        let audioOutput =  AVCaptureAudioDataOutput()
        // dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
        let audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL)
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        
        
        // 4 将输入添加到捕捉对象中
        if captureSession.canAddInput(audioInput){
            captureSession.addInput(audioInput)
        }
        
        // 5 将输出添加到捕捉对象中
        if captureSession.canAddOutput(audioOutput){
            captureSession.addOutput(audioOutput)
        }
        
    }
    

}

// 添加图层
extension BaseShowViewController {
    
    func addShowAnimation(){
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, atIndex: 0)
    }
}

// 初始化输出
extension BaseShowViewController {
    
    func setupMovieFileOutput(){
        // 1 添加输出到会话中
        if captureSession.canAddOutput(movieFileOutput){
            captureSession.addOutput(movieFileOutput)
        }
        // 2 获取视频的connection
        let connection = movieFileOutput.connectionWithMediaType(AVMediaTypeVideo)
        // 3 设置视频稳定模式
        connection.preferredVideoStabilizationMode = .Auto
        // 4 开始写入视频
        //        movieFileOutput.startRecordingToOutputFileURL(movieFileOutput.outputFileURL, recordingDelegate: self)
        // 5 停止写入
        movieFileOutput.stopRecording()
        
    }

}

// MARK:- 关闭播放
extension BaseShowViewController {
    
    func stopSeccion(){
        previewLayer?.removeFromSuperlayer()
        captureSession.stopRunning()
        //        captureSession = nil
    }
}

// MARK:-AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate
extension BaseShowViewController : AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!){
        if videoConnect == connection{
            
            //            guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            //            CVPixelBufferLockBaseAddress(imageBuffer, 0)
            //
            //            let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
            //
            //            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
            //
            //            let width = CVPixelBufferGetWidth(imageBuffer)
            //
            //            let height = CVPixelBufferGetHeight(imageBuffer)
            //
            //            guard let colorSpace = CGColorSpaceCreateDeviceRGB() else { return }
            //
            //            let context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, 0)
            //
            //            guard let quartzImage = CGBitmapContextCreateImage(context) else { return }
            //
            //            CVPixelBufferUnlockBaseAddress(imageBuffer, 0)
            //
            ////            CGContextRestoreGState(context)
            ////            CGColorSpaceRelease(colorSpace)
            //
            //            let frontCameraImageOrientation = UIImageOrientation.LeftMirrored
            //            let image = UIImage.init(CGImage: quartzImage, scale: 1.0, orientation: frontCameraImageOrientation)
            //            print("iamge ==",image)
            
            
        }else{
            
            //            react(sampleBuffer)
            
            
        }
    }
    
}

extension BaseShowViewController {
    
    func react(sampleBuffer: CMSampleBuffer){
        var buffer: CMBlockBuffer? = nil
        
        // Needs to be initialized somehow, even if we take only the address
        var audioBufferList = AudioBufferList(mNumberBuffers: 1,
            mBuffers: AudioBuffer(mNumberChannels: 1, mDataByteSize: 0, mData: nil))
        
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            nil,
            &audioBufferList,
            sizeof(audioBufferList.dynamicType),
            nil,
            nil,
            UInt32(kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment),
            &buffer
        )
        
        let abl = UnsafeMutableAudioBufferListPointer(&audioBufferList)
        
        for buffer in abl {
            let samples = UnsafeMutableBufferPointer<Int16>(start: UnsafeMutablePointer(buffer.mData),
                count: Int(buffer.mDataByteSize)/sizeof(Int16))
            
            var sum:Int64 = 0
            
            for sample in samples {
                let s = Int64(sample)
                sum = (sum + s*s)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                //                    print(sum)
                print( String(sqrt(Float(sum/Int64(samples.count)))))
            }
        }
    }
}

// MARK:- AVCaptureFileOutputRecordingDelegate
extension BaseShowViewController : AVCaptureFileOutputRecordingDelegate{
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!){
        print("1111")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!){
        print("2222")
    }
}



