//
//  TitleViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapStartButton(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let userid = defaults.objectForKey("UserID") as? String
        let password = defaults.objectForKey("Password") as? String
        
        if userid != nil && password != nil {
            // オートログイン
            NCMBUser.logInWithUsernameInBackground(userid, password: password, block:{(user: NCMBUser?, error: NSError!) in
                if error != nil {
                    // ログイン失敗時の処理
                    let alertController = UIAlertController(
                        title: "ログインに失敗しました",
                        message: "エラーコード：\(error.code)",
                        preferredStyle: .Alert)
                        
                    alertController.addAction(UIAlertAction(
                        title: "確認",
                        style: .Default,
                        handler: { action in self.pushConfirm() } ))
                        
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // ログイン成功時の処理
                    self.performSegueWithIdentifier("toTop", sender: self)
                }
                
            })
        } else {
            self.performSegueWithIdentifier("toLogin", sender: self)
        }
    }
    
    func pushConfirm() {
        self.performSegueWithIdentifier("toLogin", sender: self)
    }

}
