//
//  QrcodeViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/15.
//  Copyright © 2017年 xiudo. All rights reserved.
//  二维码

import UIKit
import AVFoundation
fileprivate let margin : CGFloat = 20
fileprivate let backGroundImageViewHW : CGFloat = 200
class QrcodeViewController: UIViewController {

    // MARK:- 懒加载
    fileprivate lazy var backGroundImageView : UIImageView = {
       
        let backGroundImageView = UIImageView()
        backGroundImageView.frame = CGRect(x: 0, y: 0, width: backGroundImageViewHW, height: backGroundImageViewHW)
        backGroundImageView.image = UIImage(named: "pick_bg")
        return backGroundImageView
        
    }()
    
    fileprivate lazy var lineImageView : UIImageView = {
        
        let lineImageView = UIImageView()
        lineImageView.image = UIImage(named: "line.png")
        return lineImageView
        
    }()
    
    fileprivate lazy var session: AVCaptureSession = {
        
        let session = AVCaptureSession()
        return session
        
    }()
    
    fileprivate lazy var preLayer: AVCaptureVideoPreviewLayer = {
        
        return AVCaptureVideoPreviewLayer(session: self.session)
        
    }()
    
    // MARK:- 常量
    fileprivate var time : Timer?
    fileprivate let timeInterval : TimeInterval = 1.0
    // MARK:- 变量
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        
        beginAnimation()
        beginScan()

    }

    func beginAnimation(){
        self.lineImageView.frame.origin.y = 0
        UIView.animate(withDuration: 2, animations: { () -> Void in
            
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.lineImageView.frame.origin.y = self.backGroundImageView.frame.height
            
        }) 
        
    }
    
    func beginScan(){
        
        // 1 判断是否有摄像头
        if ( !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            debugLog("您的设备没有摄像头或者相关的驱动, 不能进行")
            return
        }
        
        // 2. 获取摄像头设备, 并作为输入设备
        let device: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        var input: AVCaptureDeviceInput?
        do
        {
            input = try AVCaptureDeviceInput(device: device)
        }catch
        {
            debugLog(error)
        }
        
        // 3. 设置元数据输出处理
        let output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 4. 创建会话, 连接输入和输出
        if session.canAddInput(input) && session.canAddOutput(output)
        {
            session.addInput(input)
            session.addOutput(output)
        }
        // 4.1 设置元数据处理类型 output.availableMetadataObjectTypes
        // 必须在添加元数据输出之后, 才可以设置, 否则无效
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        // 4.2 添加预览图层
        preLayer.frame = view.layer.bounds
        view.layer.insertSublayer(preLayer, at: 0)
        
        // 4.3 设置兴趣区域
        // 注意, 此处需要填的rect, 是以右上角为(0, 0), 也就是横屏状态
        // 值域范围: 0->1
        let bounds = UIScreen.main.bounds
        let x = backGroundImageView.frame.origin.x / bounds.size.width
        let y = backGroundImageView.frame.origin.y / bounds.size.height
        let w = backGroundImageView.frame.size.width / bounds.size.width
        let h = backGroundImageView.frame.size.height / bounds.size.height
        
        output.rectOfInterest = CGRect(x: y, y: x, width: h, height: w)
        
        
        
        // 5. 启动会话
        session.startRunning()
        
        
        
    }
    
}


extension QrcodeViewController{
    
    fileprivate func setupUI(){
    
    
        view.addSubview(backGroundImageView)
        backGroundImageView.addSubview(lineImageView)
        
        backGroundImageView.frame = CGRect(x: (sScreenW - backGroundImageViewHW) * 0.5, y: (sScreenW - backGroundImageViewHW) * 0.5 + 100, width: backGroundImageViewHW, height: backGroundImageViewHW)
        
        lineImageView.frame = CGRect(x: 0, y: 0, width: backGroundImageView.frame.width, height: 1)
    
    }
}

extension QrcodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        removeQRCodeFrame()
        
        for obj in metadataObjects
        {
            if (obj as AnyObject).isKind(of: AVMetadataMachineReadableCodeObject.self)
            {
                var codeObj = obj as! AVMetadataMachineReadableCodeObject
                debugLog(codeObj.stringValue)
                self.title = codeObj.stringValue

                // 使用预览图层转换坐标系
                codeObj = preLayer.transformedMetadataObject(for: codeObj) as! AVMetadataMachineReadableCodeObject
                //                 print(codeObj.corners)
                
                drawQRCodeFrame(codeObj)
            }
        }
        
        
    }
    
    
    func drawQRCodeFrame(_ codeObj: AVMetadataMachineReadableCodeObject) {
        
        let layer: CAShapeLayer = CAShapeLayer()
        layer.lineWidth = 6
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        
        let path: UIBezierPath = UIBezierPath()
        
        
        let count = codeObj.corners.count
        
        for i in 0..<count
        {
            let pointDic = codeObj.corners[i] as! CFDictionary
            // 根据字典创建一个point
//            var point = CGPoint.zero
//             CGPointMakeWithDictionaryRepresentation(pointDic, &point)
            
            guard let point = CGPoint(dictionaryRepresentation: pointDic) else { continue }
            
            if i == 0
            {
                path.move(to: point)
            }else
            {
                path.addLine(to: point)
            }
            
        }
        
        path.close()
        
        
        layer.path = path.cgPath
        
        preLayer.addSublayer(layer)
        
        
        
    }
    
    func removeQRCodeFrame()
    {
        guard let subLayers = preLayer.sublayers else { return }
        for layer in subLayers
        {
            if layer.isKind(of: CAShapeLayer.self)
            {
                layer.removeFromSuperlayer()
            }
        }
    }
    
}
