//
//  SearchHeadVM.swift
//  DYZB
//
//  Created by xiudou on 2017/6/23.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit

//class SearchHeadVM: NSObject {
//    lazy var searchHeadArray : [SearchHeadModel] = [SearchHeadModel]()
//    
//    func loadSearchHeadDatas(_ finishCallBack : ()->()) {
//        
//        guard let path = Bundle.main.path(forResource: "searchViewTitles.plist", ofType: nil) else {
//            print("path不存在")
//            return }
//        guard let dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
//            print("dict不存在")
//            return }
//        guard let dictArray = dict["titleArray"] as? [[String : Any]] else { return }
//        
//        for dict in dictArray{
////            let model = SearchHeadModel(dict: dict)
////            searchHeadArray.append(model)
//        }
//        
//        finishCallBack()
//    }
//}
