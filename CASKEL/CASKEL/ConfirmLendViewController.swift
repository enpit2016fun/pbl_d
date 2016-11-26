//
//  ConfirmLendInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class ConfirmLendViewController: UIViewController {
    
    @IBOutlet weak var what: UILabel!
    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var when: UILabel!
    
    var goodsId: String = ""
    var goodsName: String = ""
    var personId: String = ""
    var personName: String = ""
    var date: NSDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        what.text = goodsName
        who.text = personName
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        when.text = df.stringFromDate(date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapOKButton(sender: AnyObject) {
        //*** データベースへレンタル情報を送信 ***
        let userid = NCMBUser.currentUser().userName
        // 保存先クラスを作成
        let obj = NCMBObject(className: "RentalTable")
        // 値を設定
        obj.setObject(userid, forKey: "lender")
        obj.setObject(personId, forKey: "renter")
        obj.setObject(goodsId, forKey: "goods")
        obj.setObject(date, forKey: "returnDate")
        obj.setObject(false, forKey: "isReturn")
        // 保存を実施
        obj.saveInBackgroundWithBlock{(error: NSError!) in
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
        self.performSegueWithIdentifier("rentComplete", sender: self)
    }
    
}
