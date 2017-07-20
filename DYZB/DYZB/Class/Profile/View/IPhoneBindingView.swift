//
//  IPhoneBindingView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/18.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 10
fileprivate let normalHeight : CGFloat = 150
class IPhoneBindingView: UIView {

    /// 国家
    fileprivate  lazy var CountryView: UIView = {
        let CountryView = UIView()
        CountryView.isUserInteractionEnabled = true
        CountryView.backgroundColor = UIColor.red
        return CountryView
    }()
    
    /// >
    fileprivate lazy var arrowView : UIImageView = {
        
        let arrowView = UIImageView()
        arrowView.contentMode = .center
        arrowView.image = UIImage(named: "Image_arrow_right")
        return arrowView
    }()
    
    /// 中国
    fileprivate  lazy var iPhoneLabel: UILabel = {
        let iPhoneLabel = UILabel()
        iPhoneLabel.text = "中国"
        iPhoneLabel.textAlignment = .center
        iPhoneLabel.font = UIFont.systemFont(ofSize: 14)
        iPhoneLabel.textColor = .gray
        return iPhoneLabel
    }()
    /// 有个bug 点击AreaCodeTextField输入后不会居中显示,demo也没有解决
    /// 86
    fileprivate  lazy var AreaCodeTextField: UITextField = {
        let AreaCodeTextField = UITextField()
        AreaCodeTextField.textAlignment = .center
        AreaCodeTextField.backgroundColor = UIColor.yellow
        return AreaCodeTextField
    }()

    
    
    /// 手机号
    fileprivate  lazy var IPhoneNumberTextField: UITextField = {
        let IPhoneNumberTextField = UITextField()
        IPhoneNumberTextField.textAlignment = .center
        IPhoneNumberTextField.backgroundColor = UIColor.blue
        return IPhoneNumberTextField
    }()
    
    /// 验证码
    fileprivate  lazy var VerificationCodeTextField: UITextField = {
        let VerificationCodeTextField = UITextField()
        VerificationCodeTextField.textAlignment = .center
        VerificationCodeTextField.backgroundColor = UIColor.green
        return VerificationCodeTextField
    }()
    
    /// 验证码图片
    fileprivate  lazy var VerificationCodeImageView: UIImageView = {
        let VerificationCodeImageView = UIImageView()
        VerificationCodeImageView.backgroundColor = UIColor.orange
        return VerificationCodeImageView
    }()
    
    /// 语音吗
    fileprivate  lazy var VoiceTextField: UITextField = {
        let VoiceTextField = UITextField()
        VoiceTextField.textAlignment = .center

        VoiceTextField.backgroundColor = UIColor.purple
        return VoiceTextField
    }()
    
    /// 语音按钮
    fileprivate  lazy var VoiceButton: UIButton = {
        let VoiceButton = UIButton()
        VoiceButton.backgroundColor = UIColor.black
        return VoiceButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        addSubview(CountryView)
        CountryView.addSubview(arrowView)
        CountryView.addSubview(iPhoneLabel)
        addSubview(AreaCodeTextField)
        addSubview(IPhoneNumberTextField)
        addSubview(VerificationCodeTextField)
        addSubview(VerificationCodeImageView)
        addSubview(VoiceTextField)
        addSubview(VoiceButton)
        
        setupFrame()
        addTapGesture()
        
        // 设置tag标记UITextField
        AreaCodeTextField.tag = AreaCodeTextFieldTag
        IPhoneNumberTextField.tag = IPhoneNumberTextFieldTag
        VerificationCodeTextField.tag = VerificationCodeTextFieldTag
        VoiceTextField.tag = VoiceTextFieldTag
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- Frame设置
extension IPhoneBindingView {
    
    fileprivate func setupFrame() {
        CountryView.frame = CGRect(x: margin, y: margin + 64, width: sScreenW - 2 * margin, height: normalHeight)

        /// 箭头
        arrowView.sizeToFit()
        arrowView.frame = CGRect(x: CountryView.frame.width - arrowView.frame.width - margin, y: 0, width: arrowView.frame.width, height: CountryView.frame.height)
        /// 中国
        let text = iPhoneLabel.text!
        let iPhoneLabelSize = text.sizeWithFont(iPhoneLabel.font)
        iPhoneLabel.frame = CGRect(x: arrowView.frame.origin.x - iPhoneLabelSize.width - margin , y: 0, width: iPhoneLabelSize.width, height: CountryView.frame.height)
        
        
        AreaCodeTextField.frame = CGRect(x: margin, y: CountryView.frame.maxY + margin, width: 100, height: normalHeight)
//        leftLabelView.frame = CGRect(x: 0, y: 0, width: 10, height: AreaCodeTextField.frame.height)
        
        IPhoneNumberTextField.frame = CGRect(x: AreaCodeTextField.frame.maxX + margin, y: AreaCodeTextField.frame.origin.y, width: sScreenW - AreaCodeTextField.frame.maxX - margin - margin, height: normalHeight)
        
        VerificationCodeTextField.frame = CGRect(x: CountryView.frame.origin.x, y: IPhoneNumberTextField.frame.maxY + margin, width: 180, height: normalHeight)
        
        VerificationCodeImageView.frame = CGRect(x: VerificationCodeTextField.frame.maxX, y: VerificationCodeTextField.frame.origin.y, width: sScreenW - VerificationCodeTextField.frame.maxX - margin, height: normalHeight)
        
        VoiceTextField.frame = CGRect(x: CountryView.frame.origin.x, y: VerificationCodeTextField.frame.maxY + margin, width: 180, height: normalHeight)
        
        VoiceButton.frame = CGRect(x: VoiceTextField.frame.maxX, y: VoiceTextField.frame.origin.y, width: sScreenW - VoiceTextField.frame.maxX - margin, height: normalHeight)
        debugLog( VoiceButton.frame.maxY)
        frame = CGRect(x: 0, y: 0, width: sScreenW, height: 800)
    }
}

// MARK:- 国家点击事件
extension IPhoneBindingView {
    @objc fileprivate func addTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CountryViewClick))
        CountryView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func CountryViewClick(){
        endEditing(false)
        let countyrVC = CountryViewController()
        countyrVC.delegate = self
        let nav = getNavigation()
        nav.pushViewController(countyrVC, animated: true)
    }
}

// MARK:- +86
extension IPhoneBindingView {
    
}

// MARK:- 手机号
extension IPhoneBindingView {
    
}

// MARK:- 验证码
extension IPhoneBindingView {
    
}

// MARK:- 验证码图片
extension IPhoneBindingView {
    
}

// MARK:- 语音吗
extension IPhoneBindingView {
    
}

// MARK:- 语音按钮
extension IPhoneBindingView {
    
}

// MARK:- UITextFieldDelegate
extension IPhoneBindingView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        // 如果是+则返回false
        if string == "" {
            if range.location == 0 && range.length == 1{
                return false
            }
        }
        
        if range.location == 5 && range.length == 0 {
            return false
        }
        print("ppppppppp",range.location,range.length,string)

//        guard let text = textField.text else { return false }
//        
//        let saveText = text as NSString
//        
//        let newText = saveText.replacingCharacters(in: range, with: string)
//
//        
//        let tag = textField.tag
//        
//        
//        
//        if tag == AreaCodeFieldTextTag {
// 
//            debugLog(newText)
//            
//            return true
//        }
        
        
        return true
    }
}

// MARK:- CountryViewControllerDelegate
extension IPhoneBindingView : CountryViewControllerDelegate{
    
    func countryViewController(_ countryViewController: CountryViewController, didSelectModel countryModel: CountryModel) {
        // 跟新区号
//        AreaCodeTextField.text = "+\(countryModel.mobile_prefix)"
        // 更新中国>
        iPhoneLabel.text = countryModel.country
    }
}
