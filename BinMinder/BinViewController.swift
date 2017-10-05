//
//  BinViewController.swift
//  BinMinder
//
//  Created by Yousef on 21/09/2017.
//  Copyright © 2017 Yousef. All rights reserved.
//

import UIKit

class BinViewController: UITableViewController {
    
    var binDatesData: [BinDate]!

    var userPostCode: String!
    var userHouseNo: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return binDatesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = binDatesData[indexPath.row].type
        cell.detailTextLabel?.text = binDatesData[indexPath.row].date
        return cell
    }

}

//extension BinViewController: UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return binDatesData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//        cell.textLabel?.text = binDatesData[indexPath.row].type
//        cell.detailTextLabel?.text = binDatesData[indexPath.row].date
//        return cell
//    }
//
//
//}

