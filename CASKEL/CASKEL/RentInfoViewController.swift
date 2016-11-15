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
    var nameList: [String] = []
    var dateList: [String] = []
    var spentDayList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let query = NCMBQuery(className: "RentalTable")
        
        /** ここに条件 **/
        query.whereKey("renter", equalTo: NCMBUser.currentUser().userName)
        query.whereKey("isReturn", equalTo: false)
        
        // 返却日の近い順に取得
        query.addAscendingOrder("returnDate")
        
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
            
            let userid = (object.objectForKey("lender") as? String)!
            
            var family = "??"
            var first = "??"
            
            let userQuery = NCMBUser.query()
            
            /** ここに条件 **/
            userQuery.whereKey("userName", equalTo: userid)
            
            // データストアの検索を実施
            // *** バックグラウンドで行うとテーブルに反映されないので同期処理で検索 ***
            var users: [AnyObject] = []
            do {
                users = try userQuery.findObjects()
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
            if users.count <= 0 {
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
                family = (users[0].objectForKey("familyName") as? String)!
                first = (users[0].objectForKey("firstName") as? String)!
            }
            
            self.nameList.append("\(family) \(first)　さん")
            
            let rDate = (object.objectForKey("returnDate") as? NSDate)!
            
            let df = NSDateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            self.dateList.append(df.stringFromDate(rDate))
            
            let cal = NSCalendar.currentCalendar()
            
            let originalComp = cal.components([.Year, .Month, .Day], fromDate: NSDate())
            
            let novelComp = NSDateComponents()
            novelComp.year = originalComp.year
            novelComp.month = originalComp.month
            novelComp.day = originalComp.day
            novelComp.hour = 0
            novelComp.minute = 0
            novelComp.second = 0
            
            let componentsByDay = cal.components([.Day], fromDate: cal.dateFromComponents(novelComp)!, toDate: rDate, options: NSCalendarOptions())
            self.spentDayList.append(componentsByDay.day)
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
        goodsLabel.text = goodsList[indexPath.row]
        
        let personLabel = rentList.viewWithTag(2) as! UILabel
        personLabel.text = nameList[indexPath.row]
        
        let dateLabel = rentList.viewWithTag(3) as! UILabel
        
        if spentDayList[indexPath.row] < 0 {
            dateLabel.textColor = UIColor.redColor()
        } else if spentDayList[indexPath.row] < 1 {
            dateLabel.textColor = UIColor.orangeColor()
        } else if spentDayList[indexPath.row] < 4 {
            dateLabel.textColor = UIColor.greenColor()
        } else {
            dateLabel.textColor = UIColor.blackColor()
        }
        
        dateLabel.text = dateList[indexPath.row]
        
        return cell
    }

}
