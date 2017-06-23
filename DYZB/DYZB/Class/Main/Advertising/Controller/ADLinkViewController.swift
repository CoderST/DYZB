//
//  ADLinkViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/6/21.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import SVProgressHUD
class ADLinkViewController: UIViewController {

    var openURLString : String = ""
    
    fileprivate var webView : UIWebView = {
       
        let webView = UIWebView()
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(webView)
        webView.delegate = self
        webView.frame = view.bounds

        guard let url = URL(string: openURLString) else { return }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

    deinit {
        SVProgressHUD.dismiss()
    }
}

extension ADLinkViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
}

