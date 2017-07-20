//
//  CountryViewModel.swift
//  DYZB
//
//  Created by xiudou on 2017/7/17.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class CountryViewModel: NSObject {
    
    lazy var groups : [CountryGroupModel] = [CountryGroupModel]()
    
    //单例
    static let shareCountryVM = CountryViewModel()
    
    
    /// 排好序的模型数组
//    fileprivate lazy var countryModelArray : [CountryModel] = [CountryModel]()
    /// 排好序的首字母
//    lazy var countryLetterlArray : [String] = [String]()
}

extension CountryViewModel {
    
    
    
    func loadCountryDatas(_ finishCallBack:@escaping ()->(), _ messageCallBack :@escaping (_ message : String)->(), _ failCallBack :@escaping ()->()){
        guard let path = Bundle.main.path(forResource: "country.plist", ofType: nil) else {
            print("path不存在")
            return }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            print("dict不存在")
            return }
        guard let dictArray = dict["data"] as? [[String : Any]] else { return }
        
        
        
        // 对数组字典进行A-Z排序
        let dictSortArray = dictArray.sorted { (dict1, dict2) -> Bool in
            
            guard let countryOne = dict1["country_letter"] as? String else { return false }
            
            guard let countryTwo = dict2["country_letter"] as? String else { return false }
            
            if countryOne < countryTwo{
                return true
            }else {
                
                return false
            }
            
        }
        
        // 临时数组没有字母
        var tempCountryLetterArray : [String] = [String]()
        var group : CountryGroupModel?
        for dict in dictSortArray{
            // 字典转模型
            
            let model = CountryModel(dict: dict)
            // 取出每组的字母
            let country_letter = model.country_letter
 
            if tempCountryLetterArray.contains(country_letter) == false {
                tempCountryLetterArray.append(country_letter)
                group = nil
                group  = CountryGroupModel()
                group?.sectionTitle = country_letter
                groups.append(group!)
            }

            group?.group.append(model)
            
        }
        
        
        finishCallBack()
    }
}
