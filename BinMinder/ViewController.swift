	//
//  ViewController.swift
//  BinMinder
//
//  Created by Yousef on 26/08/2017.
//  Copyright © 2017 Yousef. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import CoreData
    
//extension Address: Equatable {}

func ==(lhs: Address, rhs: Address) -> Bool {
    let areEqual = lhs.desc == rhs.desc &&
        lhs.postCode == rhs.postCode &&
        lhs.houseNumber == rhs.houseNumber
    return areEqual
}

class ViewController: UIViewController, WKNavigationDelegate {

    let webView = WKWebView()
    
    var addressSet = false

    @IBOutlet weak var postCodeTF: UITextField!
    @IBOutlet weak var houseNoTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://maps.bromley.gov.uk/map/Cluster.svc/getpage?script=/Aurora/Bromley.AuroraScript$&taskId=binsv2")!
        
        let request = URLRequest(url: url)
        
        webView.frame = CGRect(x: 0, y: 300, width: 340, height: 200)
        webView.load(request)
//        view.addSubview(webView)
        
        let defAd: Address? = getData();
        
        if let defAdVal = defAd {
            addressSet = true
            postCodeTF.text = defAdVal.postCode
            houseNoTF.text = defAdVal.houseNumber
        }else{
            print("noaddressSTORED")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let bDates = sender as AnyObject as? [BinDate],
        let bdatesVC = segue.destination as? BinViewController
            else{return}
        bdatesVC.binDatesData = bDates
        bdatesVC.userHouseNo = houseNoTF.text!
        bdatesVC.userPostCode = postCodeTF.text!
        
        bdatesVC.title = houseNoTF.text! + " " + postCodeTF.text!
    }

    @IBAction func onRemindMePressed() {
        var postcodeandnumber = postCodeTF.text! + " "  + houseNoTF.text!
        var httpreq = "http://igor.gold.ac.uk/~ma301ye/binapp?address="
        postcodeandnumber =  postcodeandnumber.replacingOccurrences(of: " ", with: "%20")
        httpreq += postcodeandnumber
        print ("the request" + httpreq)
        let url2 = URL(string: httpreq)!
        let urlReq = URLRequest(url: url2)
        webView.load(urlReq)
        webView.navigationDelegate = self

//      once the webview is loaded the webView did finish navigation function is called
        if (addressSet == false) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let addressFromText = Address(context: context)
            addressFromText.desc = "Default"
            addressFromText.postCode = postCodeTF.text!
            addressFromText.houseNumber = houseNoTF.text!
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Address")
            do {
                let results = try context.fetch(request)
                if results.count > 0
                {
                     let resultsAsObjects = results as! [NSManagedObject]
                    
                    resultsAsObjects[0].setValue("Default", forKey: "desc")
                    resultsAsObjects[0].setValue(postCodeTF.text!, forKey: "postCode")
                    resultsAsObjects[0].setValue(houseNoTF.text!, forKey: "houseNumber")
                }
            } catch {
                print("fetch failed")
            }

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
    }
    
    func getData() -> Address? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            var addy : [Address?]? = []
            addy = try context.fetch((Address.fetchRequest()))
            if (addy?.count == 0){
                return nil
            } else{
                return addy?[0]
            }
        }
        catch {
            print("fetching failed")
        }
        
        return nil
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        sleep(1)
        webView.evaluateJavaScript("document.getElementsByTagName('body')[0].innerHTML",
                                   completionHandler:{
                (value, error) in
         do{
            let response = try BinResponse(value)
            self.performSegue(withIdentifier: "showDates", sender: response.binDatesData)
         }catch{
         }
        })
    }
    
    func parseData() {
        var postcodeandnumber = postCodeTF.text! + " "  + houseNoTF.text!
        postcodeandnumber =  postcodeandnumber.replacingOccurrences(of: " ", with: "%20")
        var url = "http://igor.gold.ac.uk/~ma301ye/binapp?address="
        url += postcodeandnumber
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("error")
            }
            else {
                do {
                    print(data!)
                }
                catch{
                    print("error 2")
                }
            }
        }
    task.resume()
    }

}

