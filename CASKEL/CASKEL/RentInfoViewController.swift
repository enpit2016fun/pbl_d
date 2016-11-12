//
//  RentInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class RentInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rentList: UITableView!
    
    let objectList: NSArray = ["マリオカート", "ポケモン ムーン"]
    let personList: NSArray = ["山本", "佐藤"]
    let dateList: NSArray = ["2016/11/15", "2016/11/22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(rentList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    func tableView(rentList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = rentList.dequeueReusableCellWithIdentifier("rentListCell", forIndexPath: indexPath)
        
        let objectLabel = rentList.viewWithTag(1) as! UILabel
        objectLabel.text = "\(objectList[indexPath.row])"
        
        let personLabel = rentList.viewWithTag(2) as! UILabel
        personLabel.text = "\(personList[indexPath.row])"
        
        let dateLabel = rentList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(dateList[indexPath.row])"
        
        return cell
    }

}
