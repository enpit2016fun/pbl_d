//
//  AssessViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/26.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class AssessViewController: UIViewController {
    
    @IBOutlet weak var renterLabel: UILabel!
    @IBOutlet weak var goodsLabel: UILabel!
    @IBOutlet weak var assessSlider: UISlider!
    @IBOutlet weak var assessImage: UIImageView!
    
    var rentalId: String = ""
    var goodsName: String = ""
    var renterName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assessImage.image = starImage(Int(assessSlider.value))
        renterLabel.text = renterName
        goodsLabel.text = goodsName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapReturnButton(sender: AnyObject) {
        let alertController = UIAlertController(
            title: "確認",
            message: "本当にこの評価でいい？",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "はい",
            style: .Default,
            handler: { action in self.sendForDB() } ))
        
        alertController.addAction(UIAlertAction(
            title: "いいえ",
            style: .Cancel,
            handler: nil ))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func sendForDB() {
        // クラスのNCMBObjectを作成
        let object = NCMBObject(className: "RentalTable")
        // objectIdプロパティを設定
        object.objectId = rentalId
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
                // *** データベースへユーザ評価情報を送信 ***
                let goodsid = (object.objectForKey("goods") as? String)!
                let userid = object.objectForKey("renter")
                
                let goodsObj = NCMBObject(className: "GoodsTable")
                
                goodsObj.objectId = goodsid
                
                goodsObj.fetchInBackgroundWithBlock { (error: NSError!) -> Void in
                    if error != nil {
                        // 取得に失敗した場合の処理
                        let alertController = UIAlertController(
                            title: "データベース接続エラー",
                            message: "エラーコード：\(error.code)",
                            preferredStyle: .Alert)
                        
                        alertController.addAction(UIAlertAction(
                            title: "OK",
                            style: .Default,
                            handler: nil ))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        // 取得に成功した場合の処理
                        goodsObj.setObject(false, forKey: "isLend")
                        goodsObj.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
                            if error != nil {
                                // 更新に失敗した場合の処理
                                let alertController = UIAlertController(
                                    title: "データベース接続エラー",
                                    message: "エラーコード：\(error.code)",
                                    preferredStyle: .Alert)
                                
                                alertController.addAction(UIAlertAction(
                                    title: "OK",
                                    style: .Default,
                                    handler: nil ))
                                
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }else{
                                // 更新に成功した場合の処理
                            }
                        })
                    }
                }
                
                let assessVal = Int(self.assessSlider.value)
                
                // 保存先クラスを作成
                let assessObj = NCMBObject(className: "AssessTable")
                // 値を設定
                assessObj.setObject(userid, forKey: "user")
                assessObj.setObject(assessVal, forKey: "value")
                // 保存を実施
                assessObj.saveInBackgroundWithBlock{(error: NSError!) in
                    if (error != nil) {
                        // 保存に失敗した場合の処理
                        let alertController = UIAlertController(
                            title: "データベース接続エラー",
                            message: "エラーコード：\(error.code)",
                            preferredStyle: .Alert)
                        
                        alertController.addAction(UIAlertAction(
                            title: "OK",
                            style: .Default,
                            handler: nil ))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        // 保存に成功した場合の処理
                    }
                }
                
                // *** 返却情報の更新 ***
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
                    }
                }
                
                self.performSegueWithIdentifier("assessCompleted", sender: self)
            }
        }
    }
    
    @IBAction func changeSlider(sender: UISlider) {
        sender.value = Float(Int(round(sender.value)))
        assessImage.image = starImage(Int(assessSlider.value))
    }
    
    func starImage(assess: Int) -> UIImage {
        if assess == 0 {
            return UIImage(named: "zero_star")!
        } else if assess == 1 {
            return UIImage(named: "one_star")!
        } else if assess == 2 {
            return UIImage(named: "two_star")!
        } else if assess == 3 {
            return UIImage(named: "three_star")!
        } else if assess == 4 {
            return UIImage(named: "four_star")!
        } else {
            return UIImage(named: "five_star")!
        }
    }
    
}
