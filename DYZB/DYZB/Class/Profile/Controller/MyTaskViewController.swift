//
//  MyTaskViewController.swift
//  DYZB
//
//  Created by xiudou on 2017/7/3.
//  Copyright © 2017年 xiudo. All rights reserved.
//

import UIKit
import WebKit
class MyTaskViewController: UIViewController {

    fileprivate var webView = WKWebView()
    fileprivate var progressView = UIProgressView()
    var open_url:String = "http://capi.douyucdn.cn/api/v1/nc_page_usertask/1?token=\(TOKEN)&idfa=99F096BA-477A-4D0A-AB26-69B76DDB85C6&client_sys=ios"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWKWebView()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.reloadInputViews()
    }

}



extension MyTaskViewController: WKScriptMessageHandler {
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print(message.body)
        }
    }

extension MyTaskViewController {
    
    fileprivate func initWKWebView(){
        
        
        let config = WKWebViewConfiguration()
        config.userContentController = WKUserContentController()
        
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        preferences.minimumFontSize = 12
        config.preferences = preferences

        webView = WKWebView(frame: view.bounds, configuration: config)
        let url = URL(string: open_url)
        let request = URLRequest(url: url!)
        webView.load(request)
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
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
        
        let item = UIBarButtonItem(title: "<--", style: .plain, target: self, action: #selector(backItemPressed))
        navigationItem.leftBarButtonItem = item
    }
    
    func backItemPressed() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            if let nav = navigationController {
                nav.popViewController(animated: true)
            }
        }
    }
    
    
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

extension MyTaskViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void){
        
        guard let url = navigationAction.request.url else {
            print("url不存在")
            return
        }
//        print("sourceFrame = ",navigationAction.sourceFrame )
        guard let scheme = url.scheme else {
            
            print("scheme不存在")
            return
        }
        
        if scheme == "http" {
            handleCustomAction(url: url)
//            decisionHandler(.cancel)
//            return;
        }
        
        decisionHandler(.allow)
    }
    
    func handleCustomAction(url : URL){
        guard let host = url.host else {
            print("host不存在")
            return

        }
        print("host = ",host)
        if host == "capi.douyucdn.cn" {
            print("1")
            getLocation()
        }else if host == "scanClick"{
            print("2")
        }else if host == "scanClick"{
            print("3")
        }else if host == "scanClick"{
            print("4")
        }else if host == "scanClick"{
            print("5")
        }else if host == "scanClick"{
            print("6")
        }else{
            print("7")
        }
    }
    
    func getLocation(){
        
        let jsStr = "handleAction('%@'),广东省深圳市南山区学府路XXXX号"
        webView.evaluateJavaScript(jsStr) { (result, error) in
            print(result ?? "result = 失败")
        }
    }
}

extension MyTaskViewController : WKUIDelegate{
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void){
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { (action) in
            completionHandler()
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
