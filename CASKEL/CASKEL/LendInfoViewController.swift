//
//  LendInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class LendInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lendList: UITableView!
    
    let objectList: NSArray = ["モンスターハンター", "ゼルダの伝説", "スマブラ"]
    let personList: NSArray = ["山田", "高橋", "田中"]
    let dateList: NSArray = ["2016/11/15", "2016/11/22", "2016/12/01"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(lendList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    func tableView(lendList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lendList.dequeueReusableCellWithIdentifier("lendListCell", forIndexPath: indexPath)
        
        let objectLabel = lendList.viewWithTag(1) as! UILabel
        objectLabel.text = "\(objectList[indexPath.row])"
        
        let personLabel = lendList.viewWithTag(2) as! UILabel
        personLabel.text = "\(personList[indexPath.row])"
        
        let dateLabel = lendList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(dateList[indexPath.row])"
        
        return cell
    }
    
    @IBAction func returnButtonAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let row = lendList.indexPathForCell(cell)?.row
        
        let alertController = UIAlertController(
            title: "返してもらった？",
            message: "行番号：\(row!)",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { action in self.pushOK() } ))
        
        alertController.addAction(UIAlertAction(
            title: "キャンセル",
            style: .Cancel,
            handler: { action in self.pushCancel() } ))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pushOK() {
        
    }
    
    func pushCancel() {
        
    }
    
}
