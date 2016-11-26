//
//  TopViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var assessLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let family = (NCMBUser.currentUser().objectForKey("familyName") as? String)!
        let first = (NCMBUser.currentUser().objectForKey("firstName") as? String)!
        
        userNameLabel.text = "\(family) \(first)"
        
        let query = NCMBQuery(className: "AssessTable")
        
        /** ここに条件 **/
        query.whereKey("user", equalTo: NCMBUser.currentUser().userName)
        
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
                if objects.count <= 0 {
                    // 評価なし
                } else {
                    // 評価あり
                    var sum = 0
                    for object in objects {
                        sum += (object.objectForKey("value") as? Int)!
                    }
                    let mean: Double = Double(sum) / Double(objects.count)
                    // 小数第2位で四捨五入
                    let meanRound = round(mean * 10) / 10
                    self.assessLabel.text! = String(meanRound)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapLogoutButton(sender: AnyObject) {
        let alertController = UIAlertController(
            title: "ログアウトしますか？",
            message: "",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "はい",
            style: .Default,
            handler: { action in self.pushConfirm() } ))
        
        alertController.addAction(UIAlertAction(
            title: "いいえ",
            style: .Cancel,
            handler: nil ))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func returnTop(segue: UIStoryboardSegue) {
        
    }
    
    func pushConfirm() {
        NCMBUser.logOut()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "UserID")
        defaults.setObject(nil, forKey: "Password")
        
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
}

