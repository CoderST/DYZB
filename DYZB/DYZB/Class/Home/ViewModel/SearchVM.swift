//
//  SearchVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

class SearchVM: NSObject {

    lazy var searchArray : [SearchModel] = [SearchModel]()
    
    func loadSearchDatas(_ finishCallBack : ()->()) {
        
        guard let path = Bundle.main.path(forResource: "SearchVC.plist", ofType: nil) else {
            print("path不存在")
            return }
        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            print("dict不存在")
            return }
        guard let dictArray = dict["searchArray"] as? [[String : Any]] else { return }
        
        for dict in dictArray{
            let model = SearchModel(dict: dict)
            searchArray.append(model)
        }
                
        finishCallBack()
    }
}
