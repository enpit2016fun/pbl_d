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
    var goodsList: [String] = []
    var personList: [String] = []
    var dateList: [NSDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = NCMBQuery(className: "RentalTable")
        
        /** ここに条件 **/
        query.whereKey("lender", equalTo: NCMBUser.currentUser().userName)
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
            self.personList.append((object.objectForKey("renter") as? String)!)
            self.dateList.append((object.objectForKey("returnDate") as? NSDate)!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(lendList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }
    
    func tableView(lendList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = lendList.dequeueReusableCellWithIdentifier("lendListCell", forIndexPath: indexPath)
        
        let goodsLabel = lendList.viewWithTag(1) as! UILabel
        goodsLabel.text = "\(goodsList[indexPath.row])"
        
        let personLabel = lendList.viewWithTag(2) as! UILabel
        personLabel.text = "\(personList[indexPath.row])"
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        let dateLabel = lendList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(df.stringFromDate(dateList[indexPath.row]))"
        
        return cell
    }
    
    @IBAction func returnButtonAction(sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let row = lendList.indexPathForCell(cell)?.row
        
        let alertController = UIAlertController(
            title: "返してもらった？",
            message: "",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { action in self.pushOK(row!) } ))
        
        alertController.addAction(UIAlertAction(
            title: "キャンセル",
            style: .Cancel,
            handler: nil ))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pushOK(rowNum: Int) {
        // クラスのNCMBObjectを作成
        let object = NCMBObject(className: "RentalTable")
        // objectIdプロパティを設定
        object.objectId = idList[rowNum]
        // 設定されたobjectIdを元にデータストアからデータを取得
        object.fetchInBackgroundWithBlock { (error: NSError!) -> Void in
            if error != nil {
                // 取得に失敗した場合の処理
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
                // 取得に成功した場合の処理
                object.setObject(true, forKey: "isReturn")
                // データストアへの保存を実施
                object.saveInBackgroundWithBlock { (error: NSError!) -> Void in
                    if error != nil {
                        // 保存に失敗した場合の処理
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
                        // 保存に成功した場合の処理
                        self.performSegueWithIdentifier("updated", sender: self)
                    }
                }
            }
        }
    }
    
}
