//
//  RentInfoViewController.swift
//  enPiT3
//
//  Created by nishimura on 2016/11/09.
//  Copyright © 2016年 TeamD. All rights reserved.
//

import UIKit

class RentInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rentList: UITableView!
    
    let objectList: NSArray = ["aaa", "sss"]
    let personList: NSArray = ["ppp", "qqq"]
    let dateList: NSArray = ["2016/11/15", "2016/11/22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ rentList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    func tableView(_ rentList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rentList.dequeueReusableCell(withIdentifier: "rentListCell", for: indexPath)
        
        let objectLabel = rentList.viewWithTag(1) as! UILabel
        objectLabel.text = "\(objectList[indexPath.row])"
        
        let personLabel = rentList.viewWithTag(2) as! UILabel
        personLabel.text = "\(personList[indexPath.row])"
        
        let dateLabel = rentList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(dateList[indexPath.row])"
        
        return cell
    }

}
