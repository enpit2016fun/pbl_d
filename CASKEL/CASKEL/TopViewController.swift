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
        
        let family = (NCMBUser.currentUser().objectForKey("familyName") as? String)!
        let first = (NCMBUser.currentUser().objectForKey("firstName") as? String)!
        
        userNameLabel.text = "\(family) \(first)"
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

