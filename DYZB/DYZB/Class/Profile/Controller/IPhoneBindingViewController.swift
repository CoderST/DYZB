//
//  IPhoneBindingViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
fileprivate let margin : CGFloat = 10
fileprivate let normalHeight : CGFloat = 150
class IPhoneBindingViewController: UIViewController {

    
    var scrollView : UIScrollView!
    
    /// 国家
    fileprivate  lazy var CountryView: UIView = {
       let CountryView = UIView()
        CountryView.isUserInteractionEnabled = true
        CountryView.backgroundColor = UIColor.red
        return CountryView
    }()

    /// +86
    fileprivate  lazy var AreaCodeFieldText: UITextField = {
        let AreaCodeFieldText = UITextField()
        AreaCodeFieldText.backgroundColor = UIColor.yellow
        return AreaCodeFieldText
    }()

    /// 手机号
    fileprivate  lazy var IPhoneNumberTextField: UITextField = {
        let IPhoneNumberTextField = UITextField()
        IPhoneNumberTextField.backgroundColor = UIColor.blue
        return IPhoneNumberTextField
    }()

    /// 验证码
    fileprivate  lazy var VerificationCodeTextField: UITextField = {
        let VerificationCodeTextField = UITextField()
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
        VoiceTextField.backgroundColor = UIColor.purple
        return VoiceTextField
    }()

    /// 语音按钮
    fileprivate  lazy var VoiceButton: UIButton = {
        let VoiceButton = UIButton()
        VoiceButton.backgroundColor = UIColor.black
        return VoiceButton
    }()
    
    /*
     -(void)loadView
     {
     UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.view = scrollView;
     }
*/
    override func loadView() {
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        
        view = scrollView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        setupUI()
        setupFrame()
        
        addTapGesture()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
    }
    
    deinit {
        view.endEditing(false)
    }
}
// MARK:- 添加UI 设置Frame
extension IPhoneBindingViewController {
    fileprivate func setupUI() {
        scrollView.isScrollEnabled = true
        scrollView.addSubview(CountryView)
        scrollView.addSubview(AreaCodeFieldText)
        scrollView.addSubview(IPhoneNumberTextField)
        scrollView.addSubview(VerificationCodeTextField)
        scrollView.addSubview(VerificationCodeImageView)
        scrollView.addSubview(VoiceTextField)
        scrollView.addSubview(VoiceButton)
    }
    
    fileprivate func setupFrame() {
        CountryView.frame = CGRect(x: margin, y: margin + 64, width: sScreenW - 2 * margin, height: normalHeight)
        
        AreaCodeFieldText.frame = CGRect(x: CountryView.frame.origin.x, y: CountryView.frame.maxY + margin, width: 50, height: normalHeight)
        
        IPhoneNumberTextField.frame = CGRect(x: AreaCodeFieldText.frame.maxX, y: AreaCodeFieldText.frame.origin.y, width: sScreenW - AreaCodeFieldText.frame.maxX - margin, height: normalHeight)
        
        VerificationCodeTextField.frame = CGRect(x: CountryView.frame.origin.x, y: IPhoneNumberTextField.frame.maxY + margin, width: 180, height: normalHeight)
        
        VerificationCodeImageView.frame = CGRect(x: VerificationCodeTextField.frame.maxX, y: VerificationCodeTextField.frame.origin.y, width: sScreenW - VerificationCodeTextField.frame.maxX - margin, height: normalHeight)
        
        VoiceTextField.frame = CGRect(x: CountryView.frame.origin.x, y: VerificationCodeTextField.frame.maxY + margin, width: 180, height: normalHeight)
        
        VoiceButton.frame = CGRect(x: VoiceTextField.frame.maxX, y: VoiceTextField.frame.origin.y, width: sScreenW - VoiceTextField.frame.maxX - margin, height: normalHeight)
        debugLog( VoiceButton.frame.maxY)
        scrollView.contentSize = CGSize(width: sScreenW, height: VoiceButton.frame.maxY)
    }
}
// MARK:- 国家
extension IPhoneBindingViewController {
    @objc fileprivate func addTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CountryViewClick))
        CountryView.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func CountryViewClick(){
        view.endEditing(false)
        debugLog("-------")
    }
}

// MARK:- +86
extension IPhoneBindingViewController {
    
}

// MARK:- 手机号
extension IPhoneBindingViewController {
    
}

// MARK:- 验证码
extension IPhoneBindingViewController {
    
}

// MARK:- 验证码图片
extension IPhoneBindingViewController {
    
}

// MARK:- 语音吗
extension IPhoneBindingViewController {
    
}

// MARK:- 语音按钮
extension IPhoneBindingViewController {
    
}
