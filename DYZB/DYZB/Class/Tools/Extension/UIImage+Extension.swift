//
//  UIImage+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/11/1.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit
import Accelerate
extension UIImage{

    /**
     *  根据图片返回一张高斯模糊的图片
     *
     *  @param blur 模糊系数
     *
     *  @return 新的图片
     */
    class func boxBlurImage(image: UIImage, withBlurNumber blur: CGFloat) -> UIImage {
        var blur = blur
        if blur < 0.0 || blur > 1.0 {
            blur = 0.5
        }
        var boxSize = Int(blur * 40)
        boxSize = boxSize - (boxSize % 2) + 1
        
        let img = image.CGImage
        
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error: vImage_Error!
        var pixelBuffer: UnsafeMutablePointer<Void>!
        
        // 从CGImage中获取数据
        let inProvider = CGImageGetDataProvider(img)
        let inBitmapData = CGDataProviderCopyData(inProvider)
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(CGImageGetWidth(img))
        inBuffer.height = UInt(CGImageGetHeight(img))
        inBuffer.rowBytes = CGImageGetBytesPerRow(img)
        inBuffer.data = UnsafeMutablePointer<Void>(CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img))
        if pixelBuffer == nil {
            NSLog("No pixel buffer!")
        }
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(CGImageGetWidth(img))
        outBuffer.height = UInt(CGImageGetHeight(img))
        outBuffer.rowBytes = CGImageGetBytesPerRow(img)
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != nil && error != 0 {
            NSLog("error from convolution %ld", error)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGBitmapContextCreate(outBuffer.data, Int(outBuffer.width), Int(outBuffer.height), 8, outBuffer.rowBytes, colorSpace, CGImageAlphaInfo.NoneSkipLast.rawValue)
        
        let imageRef = CGBitmapContextCreateImage(ctx)!
        let returnImage = UIImage(CGImage: imageRef)
        
        free(pixelBuffer)
        
        return returnImage
    }
    
}
