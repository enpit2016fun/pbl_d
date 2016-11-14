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
    
    var idList: [String] = []
    var goodsList: [String] = []
    var personList: [String] = []
    var dateList: [NSDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let query = NCMBQuery(className: "RentalTable")
        
        /** ここに条件 **/
        query.whereKey("renter", equalTo: NCMBUser.currentUser().userName)
        query.whereKey("isReturn", equalTo: false)
        
        // データストアの検索を実施
        // *** バックグラウンドで行うとテーブルに反映されないので同期処理で検索 ***
        var objects: [AnyObject] = []
        do {
            objects = try query.findObjects()
        } catch {
            // 検索失敗時の処理
            let alertController = UIAlertController(
                title: "データベース接続エラー",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        for object in objects {
            self.idList.append(object.objectId)
            self.goodsList.append((object.objectForKey("goods") as? String)!)
            self.personList.append((object.objectForKey("lender") as? String)!)
            self.dateList.append((object.objectForKey("returnDate") as? NSDate)!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(rentList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }
    
    func tableView(rentList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = rentList.dequeueReusableCellWithIdentifier("rentListCell", forIndexPath: indexPath)
        
        let goodsLabel = rentList.viewWithTag(1) as! UILabel
        goodsLabel.text = "\(goodsList[indexPath.row])"
        
        let userid = personList[indexPath.row]
        let personLabel = rentList.viewWithTag(2) as! UILabel
        
        var family = "??"
        var first = "??"
        
        let query = NCMBUser.query()
        
        /** ここに条件 **/
        query.whereKey("userName", equalTo: userid)
        
        // データストアの検索を実施
        // *** バックグラウンドで行うとテーブルに反映されないので同期処理で検索 ***
        var objects: [AnyObject] = []
        do {
            objects = try query.findObjects()
        } catch {
            // 検索失敗時の処理
            let alertController = UIAlertController(
                title: "データベース接続エラー",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        // 検索成功時の処理
        if objects.count <= 0 {
            // ユーザ該当なし
            let alertController = UIAlertController(
                title: "データベース接続エラー",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // 該当ユーザがいる場合
            family = (objects[0].objectForKey("familyName") as? String)!
            first = (objects[0].objectForKey("firstName") as? String)!
        }
        
        personLabel.text = "\(family) \(first)　さん"
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        let dateLabel = rentList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(df.stringFromDate(dateList[indexPath.row]))"
        
        return cell
    }

}
