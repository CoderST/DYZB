//
//  BindQQViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/20.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
// 声明闭包
typealias completeButtonCallBack = (_ isOK : Bool)->Void


class BindQQViewController: UIViewController {
    @IBOutlet weak var qqTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    // 把声明的闭包设置成属性
    var callBack : completeButtonCallBack?
    // 为闭包设置调用函数
    func completeButtonValue(completeButtoncallBack : @escaping completeButtonCallBack){
        callBack = completeButtoncallBack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "绑定QQ"
       
        qqTextField.delegate = self
        
        completeButton.addTarget(self, action: #selector(BindQQViewController.completeButtonClick), for: .touchUpInside)
 
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
