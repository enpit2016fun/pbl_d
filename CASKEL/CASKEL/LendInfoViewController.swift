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
    
    var idList: [String] = []
    // idをキーとした連想配列で管理する
    var goodsList: [String: String] = [:]
    var nameList: [String: String] = [:]
    var dateList: [String: String] = [:]
    var spentDayList: [String: Int] = [:]
    var imageList: [String: UIImage] = [:]
    
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = NCMBQuery(className: "RentalTable")
        
        /** ここに条件 **/
        query.whereKey("lender", equalTo: NCMBUser.currentUser().userName)
        query.whereKey("isReturn", equalTo: false)
        
        // 返却日の近い順に取得
        query.addAscendingOrder("returnDate")
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
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
            } else {
                // 検索成功時の処理
                for object in objects {
                    let id = object.objectId
                    
                    self.idList.append(id)
                    
                    // グッズ情報検索
                    let goodsid = (object.objectForKey("goods") as? String)!
                    
                    let goodsObj = NCMBObject(className: "GoodsTable")
                    
                    /** ここに条件 **/
                    goodsObj.objectId = goodsid
                    
                    // データストアの検索を実施
                    goodsObj.fetchInBackgroundWithBlock { (error: NSError!) -> Void in
                        if (error != nil){
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
                        } else {
                            // 検索成功時の処理
                            self.goodsList[id] = (goodsObj.objectForKey("title") as? String)!
                            
                            let file: NCMBFile = NCMBFile.fileWithName(goodsid + ".jpg" ,data: nil) as! NCMBFile
                            
                            file.getDataInBackgroundWithBlock { (image: NSData!, error: NSError!) -> Void in
                                if error != nil {
                                    // ファイル取得失敗時の処理
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
                                    // ファイル取得成功時の処理
                                    if image != nil {
                                        self.imageList[id] = (UIImage(data: image!)!)
                                    } else {
                                        self.imageList[id] = (UIImage(named: "NoImage.png")!)
                                    }
                                    
                                    self.lendList.reloadData()
                                }
                            }
                        }
                    }
                    
                    let userid = (object.objectForKey("renter") as? String)!
                    
                    // ユーザ情報検索
                    let userQuery = NCMBUser.query()
                    
                    /** ここに条件 **/
                    userQuery.whereKey("userName", equalTo: userid)
                    
                    // データストアの検索を実施
                    userQuery.findObjectsInBackgroundWithBlock({(users, error) in
                        if (error != nil){
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
                        } else {
                            // 検索成功時の処理
                            var family = "??"
                            var first = "??"
                            
                            if users.count <= 0 {
                                // ユーザ該当なし
                            } else {
                                // 該当ユーザがいる場合
                                family = (users[0].objectForKey("familyName") as? String)!
                                first = (users[0].objectForKey("firstName") as? String)!
                            }
                            
                            self.nameList[id] = "\(family) \(first)"
                            
                            self.lendList.reloadData()
                        }
                    })
                    
                    let rDate = (object.objectForKey("returnDate") as? NSDate)!
                    
                    let df = NSDateFormatter()
                    df.dateFormat = "yyyy/MM/dd"
                    self.dateList[id] = df.stringFromDate(rDate)
                    
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
                    self.spentDayList[id] = componentsByDay.day
                    
                    self.lendList.reloadData()
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "assess" {
            let avc = segue.destinationViewController as! AssessViewController
            let id = idList[selectedRow]
            avc.rentalId = id
            avc.goodsName = goodsList[id]!
            avc.renterName = nameList[id]!
        }
    }
    
    func tableView(lendList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(nameList.count, b: imageList.count, c: spentDayList.count)
    }
    
    func tableView(lendList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lendList.dequeueReusableCellWithIdentifier("lendListCell", forIndexPath: indexPath)
        
        let id = idList[indexPath.row]
        
        let goodsLabel = lendList.viewWithTag(1) as! UILabel
        goodsLabel.text = goodsList[id]
        
        let personLabel = lendList.viewWithTag(2) as! UILabel
        personLabel.text = nameList[id]
        
        let dateLabel = lendList.viewWithTag(3) as! UILabel
        
        if spentDayList[id] < 0 {
            dateLabel.textColor = UIColor.redColor()
        } else if spentDayList[id] < 1 {
            dateLabel.textColor = UIColor.orangeColor()
        } else if spentDayList[id] < 4 {
            dateLabel.textColor = UIColor.greenColor()
        } else {
            dateLabel.textColor = UIColor.blackColor()
        }
        
        dateLabel.text = dateList[id]
        
        let imageView = lendList.viewWithTag(4) as! UIImageView
        imageView.image = imageList[id]
        
        return cell
    }
    
    func min(a: Int, b: Int, c: Int) -> Int {
        if a < b {
            if a < c {
                return a
            }
            return c
        }
        if b < c {
            return b
        }
        return c
    }
    
    @IBAction func returnLendInfo(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func returnButtonAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        selectedRow = (lendList.indexPathForCell(cell)?.row)!
        
        self.performSegueWithIdentifier("assess", sender: self)
    }
    
}
