//
//  DatePackerView.swift
//  DYZB
//
//  Created by xiudou on 2017/7/12.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

fileprivate let DatePackerViewHeight : CGFloat = 250
fileprivate let buttonViewHeight : CGFloat = 50
fileprivate let buttonWH : CGFloat = 50
fileprivate let timeInterval : TimeInterval = 0.3
fileprivate let backGroundColor : UIColor = UIColor(white: 0.2, alpha: 0.3)
protocol DatePackerViewDelegate : class{
    func datePackerView(_ datePackerView : DatePackerView, indexItem : String)
}
class DatePackerView: UIView {
    
    weak var delegate : DatePackerViewDelegate?
    
    fileprivate var dataString : String = ""
    
    fileprivate lazy var bottomView : UIView = {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: sScreenH , width: sScreenW, height: DatePackerViewHeight + buttonViewHeight))
        bottomView.backgroundColor = .white
        return bottomView
        
    }()
    
    fileprivate lazy var cancleButton : UIButton = {
       
        let cancleButton = UIButton(frame: CGRect(x: 10, y: 0, width: buttonViewHeight, height: buttonViewHeight))
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor.gray, for: .normal)
        cancleButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        return cancleButton
        
    }()
    
    fileprivate lazy var completeButton : UIButton = {
        
        let completeButton = UIButton(frame: CGRect(x: sScreenW - 10 - buttonViewHeight, y: 0, width: buttonViewHeight, height: buttonViewHeight))
        completeButton.setTitle("完成", for: .normal)
        completeButton.setTitleColor(UIColor.orange, for: .normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        completeButton.addTarget(self, action: #selector(completeButtonClick), for: .touchUpInside)
        return completeButton
        
    }()
    
    fileprivate lazy var datePickView : UIDatePicker = {
        
        let dateP = UIDatePicker(frame: CGRect(x: 0, y: buttonViewHeight, width: sScreenW, height: DatePackerViewHeight))
//        dateP.backgroundColor = UIColor(r: 248, g: 248, b: 248)
        //设置样式，当前设为同时显示日期和时间
        dateP.datePickerMode = UIDatePickerMode.date
        // 设置日期范围（超过日期范围，会回滚到最近的有效日期）
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var minDate = dateFormatter.date(from: "1900-01-01")
        dateP.maximumDate = Date()
        dateP.minimumDate = minDate
        // 设置默认时间
        dateP.date = NSDate() as Date
        // 响应事件（只要滚轮变化就会触发）
        dateP.addTarget(self, action:#selector(datePickerValueChange(sender:)), for: UIControlEvents.valueChanged)
        return dateP
        
    }()
    
     init(frame: CGRect, _ date : Date) {
        super.init(frame: frame)
        backgroundColor = backGroundColor
        datePickView.date = date
        addSubview(bottomView)
        bottomView.addSubview(datePickView)
        bottomView.addSubview(cancleButton)
        bottomView.addSubview(completeButton)
    }
    
    // 显示DatePicker
    func showDatePicker(_ view : UIView){
        frame = view.bounds
        view.addSubview(self)
        UIView.animate(withDuration: timeInterval) {
           self.bottomView.frame.origin.y = sScreenH - (DatePackerViewHeight + buttonViewHeight)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DatePackerView {
    
    /// 响应 datePicker 事件
    @objc fileprivate func datePickerValueChange(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let sourceTimeZone = NSTimeZone.system
        dateFormatter.timeZone = sourceTimeZone
        dataString = dateFormatter.string(from: sender.date)
        
    }

}

extension DatePackerView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       disMiss()
    }
    
    fileprivate func disMiss(){
        UIView.animate(withDuration: timeInterval, animations: {
            self.bottomView.frame.origin.y = sScreenH
        }) { (boll) in
            
            self.removeFromSuperview()
        }
    }
}

extension DatePackerView {
    
    // 取消
    @objc fileprivate func cancleButtonClick() {
        disMiss()
    }
    
    // 完成
    @objc fileprivate func completeButtonClick() {
        if dataString == "" {
            return
        }
        disMiss()
        delegate?.datePackerView(self, indexItem: dataString)
    }
}
