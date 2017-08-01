//
//  BindQQViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift
// 声明闭包
typealias completeButtonCallBack = (_ isOK : Bool)->Void


class BindQQViewController: UIViewController {
    
    fileprivate lazy var qqTextField : QQTextField = {
        let qqTextField = QQTextField()
        qqTextField.keyboardType = .numberPad
        qqTextField.backgroundColor = .white
        qqTextField.placeholder = "QQ号码"
        return qqTextField
    }()
    
    fileprivate lazy var completeButton : UIButton = {
        let completeButton = UIButton()
        completeButton.setTitle("完成", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .orange
        return completeButton
    }()
    
    // 把声明的闭包设置成属性
    var callBack : completeButtonCallBack?
    // 为闭包设置调用函数
    func completeButtonValue(completeButtoncallBack : @escaping completeButtonCallBack){
        callBack = completeButtoncallBack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "绑定QQ"
        view.backgroundColor = UIColor(r: 239, g: 239, b: 239)
        view.addSubview(qqTextField)
        view.addSubview(completeButton)
        
        qqTextField.delegate = self
        qqTextField.frame = CGRect(x: 10, y: 74, width: sScreenW - 20, height: 40)
        completeButton.frame = CGRect(x: qqTextField.frame.origin.x, y: qqTextField.frame.maxY + 20, width: qqTextField.frame.width, height: qqTextField.frame.height)
        
        completeButton.addTarget(self, action: #selector(BindQQViewController.completeButtonClick), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    func completeButtonClick() {
        // 请求数据
        if let qq = qqTextField.text{
            let parameters = ["token" : TOKEN, "key" : "qq", "val" : qq]
            let URLString = "http://capi.douyucdn.cn/api/v1/set_userinfo?aid=ios&client_sys=ios&time=\(Date.getNowDate())&auth=\(AUTH)"
            NetworkTools.requestData(.post, URLString: URLString, parameters: parameters) { (result) in
                debugLog(result)
                guard let resultDict = result as? [String : Any] else { return }
                guard let error = resultDict["error"] as? Int else{
                    return }
                guard let data = resultDict["data"] as? String else { return }
                
                if error != 0 {
                    debugLog(error)
                    SVProgressHUD.showError(withStatus: data)
                    return
                }
                
                if self.callBack != nil{
                    
                    self.callBack!(true)
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }else{
            
            SVProgressHUD.showInfo(withStatus: "号码不能为空")
        }
    }
    
    
    func sendData() {
        
        
        
    }
}

extension BindQQViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//        debugLog(string)
        if string == "" {  // 删除不做效验
            return true
        }
        
        guard let text = textField.text else { return false }
        
        let saveText = text as NSString
        
        let newText = saveText.replacingCharacters(in: range, with: string)
        
        return checkQQ(newText)
        
    }
}

extension BindQQViewController {
    
    fileprivate func checkQQ(_ qq : String)->Bool{
        
        let tool = CheckDataTool()
        
        if tool.checkForQQ(qq) == false {
            
            SVProgressHUD.showError(withStatus: "号码不正确,请重新输入")
            
            return false
            
        }
        
        return true
        
    }
}
