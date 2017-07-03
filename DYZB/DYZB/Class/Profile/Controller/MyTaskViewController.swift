//
//  MyTaskViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/3.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import WebKit
class MyTaskViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {

    fileprivate var webView = WKWebView()
    fileprivate var progressView = UIProgressView()
    var open_url:String = "http://capi.douyucdn.cn/api/v1/nc_page_usertask/1?token=\(TOKEN)&idfa=99F096BA-477A-4D0A-AB26-69B76DDB85C6&client_sys=ios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }

}

extension MyTaskViewController {
    
    fileprivate func setupUI(){
        
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height))
        webView.navigationDelegate = self
        webView.uiDelegate = self;
        let url = URL(string: open_url)
        let request = URLRequest(url: url!)
        webView.load(request)
        /**
         增加的属性：
         1.webView.estimatedProgress加载进度
         2.backForwardList 表示historyList
         3.WKWebViewConfiguration *configuration; 初始化webview的配置
         */
        view.addSubview(webView)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        progressView = UIProgressView(frame: CGRect(x: 0, y: 44-2, width: UIScreen.main.bounds.size.width, height: 2))
        progressView.trackTintColor = UIColor.white
        progressView.progressTintColor = UIColor.orange
        navigationController?.navigationBar.addSubview(progressView)
        
//        let item = UIBarButtonItem(title: "<--", style: .plain, target: self, action: #selector(backItemPressed))
//        navigationItem.leftBarButtonItem = item
    }
    
//    func backItemPressed() {
//        if webView.canGoBack {
//            webView.goBack()
//        }else{
//            if let nav = self.navigationController {
//                nav.popViewController(animated: true)
//            }
//        }
//    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
//            print(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        self.navigationItem.title = webView.title
    }
}
