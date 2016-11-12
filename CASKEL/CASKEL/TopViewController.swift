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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = NCMBUser.currentUser().userName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapLogoutButton(sender: AnyObject) {
        NCMBUser.logOut()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(nil, forKey: "UserID")
        defaults.setObject(nil, forKey: "Password")
        let alertController = UIAlertController(
            title: "ログアウトしました",
            message: "",
            preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(
            title: "確認",
            style: .Default,
            handler: { action in self.pushConfirm() } ))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func returnTop(segue: UIStoryboardSegue) {
        
    }
    
    func pushConfirm() {
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
}

