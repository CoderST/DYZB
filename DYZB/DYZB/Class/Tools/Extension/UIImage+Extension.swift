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
     *  @param blur 模糊系数(0 ~ 1)
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

    
    /**
     方法一:(适用在一张图片没有循环利用的问题)
     返回一张带有边框的图片(请用方法二)
     
     - parameter originImage: 原始图片
     - parameter borderColor: 边框颜色
     - parameter borderWidth: 边框宽度
     
     - returns: 图片
     */
    class func circleImage(originImage : UIImage, borderColor : UIColor, borderWidth : CGFloat) ->UIImage{
        
        //设置边框宽度
        let imageWH = originImage.size.width
        
        //计算外圆的尺寸
        let outWH = imageWH + 2 * borderWidth;
        
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(originImage.size, false, 0);
        
        //画一个大的圆形
        let path = UIBezierPath.init(ovalInRect: CGRect(x: 0, y: 0, width: outWH, height: outWH))
        borderColor.set()
        path.fill()

        //设置裁剪区域
        let clipPath = UIBezierPath.init(ovalInRect: CGRect(x: borderWidth, y: borderWidth, width: imageWH, height: imageWH))
        clipPath.addClip()
        
        //绘制图片
        originImage.drawAtPoint(CGPoint(x: borderWidth, y: borderWidth))
        
        //从上下文中获取图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage

        
    }
    
    /**
     返回一张有或者无边框的图片
     
     - parameter originalImage: (must)原始图片
     - parameter borderWidth:   (optional)边宽
     - parameter borderColor:   (optional)变宽颜色
     
     - returns: 图片
     */
    class func circleBorderWidth(originalImage: UIImage, borderWidth: CGFloat?, borderColor : UIColor?) -> UIImage {
        // 获取最大外圆宽
        let bigW = originalImage.size.width + 2 * (borderWidth ?? 0)
        // 获取最大外圆高
        let bigH = originalImage.size.height + 2 * (borderWidth ?? 0)
        // 取出最小值
        let resultWH = bigW < bigH ? bigW : bigH
        // 最终画圆的大小
        let bigSize = CGSize(width: resultWH, height: resultWH)
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(bigSize, false, 0.0)
        // 获取当前的上下文
        let context = UIGraphicsGetCurrentContext()
        // 设置颜色
        if let color = borderColor{
            
            color.set()
        }
        // 设置半径和中心点
        let bigRadius = resultWH * 0.5
        let centerX = bigRadius
        let centerY = bigRadius
        //
        CGContextAddArc(context, centerX, centerY, bigRadius, 0, CGFloat(M_PI * 2), 0)
        // 填充当前上下文
        CGContextFillPath(context)
        // 中间图片半径
        let centerimageRadius = bigRadius - (borderWidth ?? 0)
        // 画小圆
        CGContextAddArc(context, centerX, centerY, centerimageRadius, 0, CGFloat(M_PI * 2), 0)
        CGContextClip(context)
        
        originalImage.drawInRect(CGRect(x: (borderWidth ?? 0), y: (borderWidth ?? 0), width: originalImage.size.width, height: originalImage.size.height))
        
        // 获得图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}
