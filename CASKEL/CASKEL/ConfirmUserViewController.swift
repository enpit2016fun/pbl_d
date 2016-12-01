//
//  ConfirmUserViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/12/01.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class ConfirmUserViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolGradeLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    var userid: String = ""
    var password: String = ""
    var familyName: String = ""
    var firstName: String = ""
    var schoolName: String = ""
    var grade: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = "\(familyName) \(firstName)"
        schoolGradeLabel.text = "\(schoolName) \(grade)"
        idLabel.text = userid
        
        passwordLabel.text = ""
        for _ in 0 ..< password.characters.count {
            passwordLabel.text = passwordLabel.text! + "*"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapConfirmButton(sender: AnyObject) {
        //NCMBUserのインスタンスを作成
        let user = NCMBUser()
        //ユーザー名を設定
        user.userName = userid
        //パスワードを設定
        user.password = password
        
        //その他項目の設定
        user.setObject(familyName, forKey: "familyName")
        user.setObject(firstName, forKey: "firstName")
        user.setObject(schoolName, forKey: "school")
        user.setObject(grade, forKey: "grade")
        
        // ユーザ情報の読み込み（検索）を有効化
        let acl = NCMBACL()
        acl.setPublicReadAccess(true)
        user.ACL = acl
        
        //会員の登録を行う
        user.signUpInBackgroundWithBlock{(error: NSError!) in
            if error != nil {
                // 新規登録失敗時の処理
                let alertController = UIAlertController(
                    title: "ユーザ登録に失敗しました",
                    message: "エラーコード：\(error.code)",
                    preferredStyle: .Alert)
                    
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil ))
                    
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 新規登録成功時の処理
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.userid, forKey: "UserID")
                defaults.setObject(self.password, forKey: "Password")
                
                self.performSegueWithIdentifier("register", sender: self)
            }
        }
    }
    
}
