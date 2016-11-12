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
    
    var object:String?
    var person:String?
    var date:NSDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        what.text = object
        who.text = person
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        when.text = df.stringFromDate(date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapOKButton(sender: AnyObject) {
        //*** データベースへレンタル情報を送信 ***
        // 保存先クラスを作成
        let obj = NCMBObject(className: "Test_RentalTable")
        // 値を設定
        obj.setObject("admin", forKey: "lender")
        obj.setObject(person, forKey: "renter")
        obj.setObject(object, forKey: "object")
        obj.setObject(date, forKey: "returnDate")
        // 保存を実施
        obj.saveInBackgroundWithBlock{(error: NSError!) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print("エラーが発生しました。エラーコード:\(error.code)")
            }else{
                // 保存に成功した場合の処理
                print("保存に成功しました。objectId:\(obj.objectId)")
            }
        }
    }
    
}
