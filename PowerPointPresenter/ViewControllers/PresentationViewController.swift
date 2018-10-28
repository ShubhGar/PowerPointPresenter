//
//  PresentationViewController.swift
//  PowerPointPresenter
//
//  Created by Shubham Garg on 22/10/18.
//  Copyright © 2018 Shubham Garg. All rights reserved.
//

import UIKit
import WebKit
import Firebase
class PresentationViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    @IBOutlet var webView:WKWebView?
    var url : URL?
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.navigationDelegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        webView!.load(URLRequest(url: url!))
        webView!.isUserInteractionEnabled = false
    }
    
    // MARK: Actions
    @IBAction func moveBackword(){
        if webView!.scrollView.contentOffset.y > webViewHeight.constant{
            let y = self.webView!.scrollView.contentOffset.y - self.webViewHeight.constant
            self.webView!.scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(y)), animated: true)
            let ms = 1000
            usleep(useconds_t(300 * ms))
        }
        else{
            webView!.scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        }
    }
    
    @IBAction func moveForword(){
        let y = self.webView!.scrollView.contentOffset.y + self.webViewHeight.constant
        if (self.webView!.scrollView.contentSize.height - self.webViewHeight.constant > y) {
            self.webView!.scrollView.setContentOffset(CGPoint(x: 0, y: CGFloat(y)), animated: true)
        }
        let ms = 1000
        usleep(useconds_t(300 * ms))
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
}

extension PresentationViewController: WKNavigationDelegate {
    
    // MARK: WKWebView Delegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (any, error) in
            let slideCount = (any as? String ?? "").replacingOccurrences(of: " ", with: "").components(separatedBy: "<divclass=\"slide\"").count
            self.webViewHeight.constant = (webView.scrollView.contentSize.height / CGFloat(slideCount - 1))
        })
    }
    
}
