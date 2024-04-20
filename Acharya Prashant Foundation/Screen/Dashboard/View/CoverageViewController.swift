//
//  CoverageViewController.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 16/04/24.
//

import UIKit
import WebKit

class CoverageViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var coverageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        navigationItem.title = "Coverage"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ProgressLoader.shared.startLoading()

        if let coverageUrl {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in

                guard let self else {return}
                self.webView.load(URLRequest.init(url: coverageUrl))
            }
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ProgressLoader.shared.stopLoading()
    }
    
}

extension CoverageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("URL loaded successfully")
        ProgressLoader.shared.stopLoading()
    }

}
