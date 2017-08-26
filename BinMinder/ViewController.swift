//
//  ViewController.swift
//  BinMinder
//
//  Created by Yousef on 26/08/2017.
//  Copyright © 2017 Yousef. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webView = WKWebView()

    @IBOutlet weak var postCodeTF: UITextField!
    @IBOutlet weak var houseNoTF: UITextField!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://www.bromley.gov.uk/info/524/household_waste_and_recycling/961/bin_collection_days")!
        let request = URLRequest(url: url)
        
        webView.frame = CGRect(x: 0, y: 300, width: 340, height: 200)
        webView.load(request)
        view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of xany resources that can be recreated.
    }

    @IBAction func onRemindMePressed() {
//        ID498503047
        webView.evaluateJavaScript(
//            "document.getElementById(\"ID498503047\").value = '\(postCodeTF.text!)'"
            "document.getElementsByClassName(\"auroraAddressBox\")[0].value = '\(postCodeTF.text!)';",
            completionHandler: { (value, error) in
                print(value!)
                print("Error: \(String(describing: error))")}
        )
    }

}

