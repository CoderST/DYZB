//
//  String+Extension.swift
//  DYZB
//
//  Created by xiudou on 16/11/8.
//  Copyright © 2016年 xiudo. All rights reserved.
//

import UIKit

/// 文本宽高
extension String{
    
     func sizeWithFont(_ font:UIFont,size : CGSize) -> CGSize {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = self.boundingRect(with: size, options: option, attributes: attributes, context: nil).size
        return size;
    }
    
    func sizeWithFont(_ font : UIFont) -> CGSize {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        let resultSize = self.boundingRect(with: size, options: option, attributes: attributes, context: nil).size
        return resultSize;
    }
    
}

/// 改变字段字体
extension String{
    func dy_changeFontWithTextFont(textFont : UIFont)->NSMutableAttributedString{
        let attributedString = dy_changeFontWithTextFont(textFont: textFont, changeText: self)
        
        return attributedString
    }
    
    func dy_changeFontWithTextFont(textFont : UIFont, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .caseInsensitive)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSFontAttributeName : textFont], range: textRange)
        }
        
        return attributedString
    }
}

/// 改变字段左右间距
extension String{
    func dy_changeSpaceWithTextSpace(textSpace : CGFloat)->NSMutableAttributedString{
        let attributedString = dy_changeSpaceWithTextSpace(textSpace: textSpace, changeText: self)
        return attributedString
    }
    
    func dy_changeSpaceWithTextSpace(textSpace : CGFloat, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .caseInsensitive)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([kCTKernAttributeName as String : textSpace], range: textRange)
        }
        return attributedString
    }
}

/// 改变字间距
extension String{
    func dy_changeKernWithTextKern(textKern : NSNumber)->NSMutableAttributedString{
        let attributedString =  dy_changeKernWithTextKern(textKern: textKern, changeText: self)
        return attributedString
    }
    
    func dy_changeKernWithTextKern(textKern : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSKernAttributeName : textKern], range: textRange)
        }
        return attributedString
    }
}

/// 改变字段改变行间距
extension String{
    func dy_changeLineSpaceWithTextLineSpace(textLineSpace : CGFloat)->NSMutableAttributedString{
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textLineSpace
        let attributedString = dy_changeParagraphStyleWithTextParagraphStyle(paragraphStyle: paragraphStyle)
        return attributedString
        
    }
}

/// 段落样式
extension String{
    func dy_changeParagraphStyleWithTextParagraphStyle(paragraphStyle : NSParagraphStyle)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        
        let range = NSMakeRange(0, self.characters.count)
        attributedString.addAttributes([NSParagraphStyleAttributeName : paragraphStyle], range: range)
        return attributedString
    }
}

/// 改变字段颜色
extension String{
    func dy_changeColorWithTextColor(textColor : UIColor)->NSMutableAttributedString{
        let attributedString = dy_changeColorWithTextColor(textColor: textColor, changeText: self)
        
        return attributedString
    }
    
    func dy_changeColorWithTextColor(textColor : UIColor, changeText : String)->NSMutableAttributedString{
        let attributedString = dy_changeColorWithTextColor(textColor: textColor, changeTexts: [changeText])
        
        return attributedString
    }
    
    func dy_changeColorWithTextColor(textColor : UIColor, changeTexts : [String])->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        for text in changeTexts{
            let ocString = self as NSString
            let textRange = ocString.range(of: text, options: .backwards)
            if textRange.location != NSNotFound {
                attributedString.addAttributes([NSForegroundColorAttributeName : textColor], range: textRange)
            }
        }
        
        return attributedString
    }
}

/// 改变字段背景颜色
extension String{
    func dy_changeBgColorWithBgTextColor(bgTextColor : UIColor)->NSMutableAttributedString{
        let attributedString = dy_changeBgColorWithBgTextColor(bgTextColor: bgTextColor, changeText: self)
        return attributedString
    }
    
    func dy_changeBgColorWithBgTextColor(bgTextColor : UIColor, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSBackgroundColorAttributeName : bgTextColor], range: textRange)
        }

        return attributedString
    }
}

/// 改变字段连笔字 value值为1或者0
extension String{
    func dy_changeLigatureWithTextLigature(textLigature : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeLigatureWithTextLigature(textLigature: textLigature, changeText: self)
        
        return attributedString
    }
    
    func dy_changeLigatureWithTextLigature(textLigature : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSLigatureAttributeName : textLigature], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的删除线 textStrikethroughStyle 为NSUnderlineStyle
extension String{
    func dy_changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle: textStrikethroughStyle, changeText: self)
        
        return attributedString
    }
    
    func dy_changeStrikethroughStyleWithTextStrikethroughStyle(textStrikethroughStyle : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSStrikethroughStyleAttributeName : textStrikethroughStyle], range: textRange)
        }
        return attributedString
    }

}

/// 改变字的删除线颜色
extension String{
    func dy_changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor : UIColor)->NSMutableAttributedString{
        let attributedString = dy_changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor: textStrikethroughColor, changeText: self)
        
        return attributedString

    }
    func dy_changeStrikethroughColorWithTextStrikethroughColor(textStrikethroughColor : UIColor, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSStrikethroughColorAttributeName : textStrikethroughColor], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的下划线 textUnderlineStyle 为NSUnderlineStyle
extension String{
    func dy_changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle: textUnderlineStyle, changeText: self)
        
        return attributedString
        
    }
    func dy_changeUnderlineStyleWithTextStrikethroughStyle(textUnderlineStyle : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSUnderlineStyleAttributeName : textUnderlineStyle], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的下划线颜色
extension String{
    func dy_changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor : UIColor)->NSMutableAttributedString{
        let attributedString = dy_changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor: textUnderlineColor, changeText: self)
        
        return attributedString
        
    }
    func dy_changeUnderlineColorWithTextStrikethroughColor(textUnderlineColor : UIColor, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSUnderlineColorAttributeName : textUnderlineColor], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的颜色
extension String{
    func dy_changeStrokeColorWithTextStrikethroughColor(textStrokeColor : UIColor)->NSMutableAttributedString{
        let attributedString = dy_changeStrokeColorWithTextStrikethroughColor(textStrokeColor: textStrokeColor, changeText: self)
        
        return attributedString
        
    }
    func dy_changeStrokeColorWithTextStrikethroughColor(textStrokeColor : UIColor, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSStrokeColorAttributeName : textStrokeColor], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的描边
extension String{
    func dy_changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth: textStrokeWidth, changeText: self)
        
        return attributedString
        
    }
    func dy_changeStrokeWidthWithTextStrikethroughWidth(textStrokeWidth : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSStrokeWidthAttributeName : textStrokeWidth], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的阴影
extension String{
    func dy_changeShadowWithTextShadow(textShadow : NSShadow)->NSMutableAttributedString{
        let attributedString = dy_changeShadowWithTextShadow(textShadow: textShadow, changeText: self)
        
        return attributedString
        
    }
    func dy_changeShadowWithTextShadow(textShadow : NSShadow, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSShadowAttributeName : textShadow], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的特殊效果
extension String{
    func dy_changeTextEffectWithTextEffect(textEffect : NSString)->NSMutableAttributedString{
        let attributedString = dy_changeTextEffectWithTextEffect(textEffect: textEffect, changeText: self)
        
        return attributedString
        
    }
    func dy_changeTextEffectWithTextEffect(textEffect : NSString, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSTextEffectAttributeName : textEffect], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的文本附件
extension String{
    func dy_changeAttachmentWithTextAttachment(textAttachment : NSTextAttachment)->NSMutableAttributedString{
        let attributedString = dy_changeAttachmentWithTextAttachment(textAttachment: textAttachment, changeText: self)
        
        return attributedString
        
    }
    func dy_changeAttachmentWithTextAttachment(textAttachment : NSTextAttachment, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSAttachmentAttributeName : textAttachment], range: textRange)
        }
        return attributedString
    }
}

/// 改变字的链接
extension String{
    func dy_changeLinkWithTextLink(textLink : NSString)->NSMutableAttributedString{
        let attributedString = dy_changeLinkWithTextLink(textLink: textLink, changeText: self)
        
        return attributedString
        
    }
    func dy_changeLinkWithTextLink(textLink : NSString, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSLinkAttributeName : textLink], range: textRange)
        }
        return attributedString
    }

}

/// 改变字的基准线偏移 value>0坐标往上偏移 value<0坐标往下偏移
extension String{
    func dy_changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset: textBaselineOffset, changeText: self)
        
        return attributedString
        
    }
    func dy_changeBaselineOffsetWithTextBaselineOffset(textBaselineOffset : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSBaselineOffsetAttributeName : textBaselineOffset], range: textRange)
        }
        return attributedString
    }
    
}

/// 改变字的倾斜 value>0向右倾斜 value<0向左倾斜
extension String{
    func dy_changeObliquenessWithTextObliqueness(textObliqueness : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeObliquenessWithTextObliqueness(textObliqueness: textObliqueness, changeText: self)
        
        return attributedString
        
    }
    func dy_changeObliquenessWithTextObliqueness(textObliqueness : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSObliquenessAttributeName : textObliqueness], range: textRange)
        }
        return attributedString
    }
    
}

/// 改变字粗细 0就是不变 >0加粗 <0加细
extension String{
    func dy_changeExpansionsWithTextExpansion(textExpansion : NSNumber)->NSMutableAttributedString{
        let attributedString = dy_changeExpansionsWithTextExpansion(textExpansion: textExpansion, changeText: self)
        
        return attributedString
        
    }
    func dy_changeExpansionsWithTextExpansion(textExpansion : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSExpansionAttributeName : textExpansion], range: textRange)
        }
        return attributedString
    }
    
}

/// 改变字方向 NSWritingDirection
extension String{

    func dy_changeWritingDirectionWithTextExpansion(textWritingDirection : NSArray, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSWritingDirectionAttributeName : textWritingDirection], range: textRange)
        }
        return attributedString
    }
    
}

/// 改变字的水平或者竖直 1竖直 0水平
extension String{

    func dy_changeVerticalGlyphFormWithTextVerticalGlyphForm(textVerticalGlyphForm : NSNumber, changeText : String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let ocString = self as NSString
        let textRange = ocString.range(of: changeText, options: .backwards)
        if textRange.location != NSNotFound {
            attributedString.addAttributes([NSVerticalGlyphFormAttributeName : textVerticalGlyphForm], range: textRange)
        }
        return attributedString
    }
    
}

/// 改变字的两端对齐
extension String{
    
    func dy_changeCTKernWithTextCTKern(textCTKern : NSNumber)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: self)
        let textRange = NSMakeRange(0, self.characters.count - 1)
            attributedString.addAttributes([kCTKernAttributeName as String : textCTKern], range: textRange)
        return attributedString
    }
    
}

/// 缓存
extension String{
    
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到document目录后面
     */
    func documentDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到temp目录后面
     */
    func tempDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func isAllNum() -> Bool{
        
        do {
            //1、创建规则
            let pattern = "^\\+?[1-9][0-9]*$"
            
            //2、创建对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、开始匹配
            let range = regex.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
            if range.location == 0 && range.length > 0 {
                return true
            }
        } catch{
            print(error)
        }
        
        return false
    }
    
    
    func isFloatValue() -> Bool{
        do {
            //1、创建规则
            let pattern = "^[+]?[0-9]*\\.?[0-9]+$"
            
            //2、创建对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            //3、开始匹配
            let range = regex.rangeOfFirstMatch(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
            if range.location == 0 && range.length > 0 {
                return true
            }
        } catch{
            print(error)
        }
        
        return false
    }
    
    func intValue() -> Int{
        return Int((self as NSString).intValue)
    }
    
    func floatValue() -> Float{
        return (self as NSString).floatValue
    }
    
    func doubleValue() -> Double{
        return (self as NSString).doubleValue
    }

}
