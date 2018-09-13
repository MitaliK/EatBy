//
//  WebViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 12/08/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var webView: WKWebView!
    var target = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Never show LargeTitleBar
        navigationItem.largeTitleDisplayMode = .never
        
        if let url = URL(string: target) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
