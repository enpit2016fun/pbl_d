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
    @IBOutlet weak var assessImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let family = (NCMBUser.currentUser().objectForKey("familyName") as? String)!
        let first = (NCMBUser.currentUser().objectForKey("firstName") as? String)!
        
        userNameLabel.text = "\(family) \(first)"
        assessLabel.text = ""
        assessImage.image = starImage(0.0)
        
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
                    self.assessLabel.text! = "まだ評価はありません"
                    self.assessImage.image = self.starImage(0.0)
                } else {
                    // 評価あり
                    var sum = 0
                    for object in objects {
                        sum += (object.objectForKey("value") as? Int)!
                    }
                    let mean = Double(sum) / Double(objects.count)
                    self.assessLabel.text! = ""
                    self.assessImage.image = self.starImage(self.exRoundUp(mean))
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
    
    // 0.5刻みで切り上げを行う
    func exRoundUp(num: Double) -> Double {
        let intPart = Double(Int(num))
        if num - intPart == 0.0 {
            return intPart
        } else if num - intPart <= 0.5 {
            return intPart + 0.5
        } else {
            return intPart + 1.0
        }
    }
    
    func starImage(assess: Double) -> UIImage {
        if assess == 0.0 {
            return UIImage(named: "zero_star")!
        } else if assess == 0.5 {
            return UIImage(named: "half_star")!
        } else if assess == 1.0 {
            return UIImage(named: "one_star")!
        } else if assess == 1.5 {
            return UIImage(named: "one_half")!
        } else if assess == 2.0 {
            return UIImage(named: "two_star")!
        } else if assess == 2.5 {
            return UIImage(named: "two_half")!
        } else if assess == 3.0 {
            return UIImage(named: "three_star")!
        } else if assess == 3.5 {
            return UIImage(named: "three_half")!
        } else if assess == 4.0 {
            return UIImage(named: "four_star")!
        } else if assess == 4.5 {
            return UIImage(named: "four_half")!
        } else {
            return UIImage(named: "five_star")!
        }
    }
    
}

