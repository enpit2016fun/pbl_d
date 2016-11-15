//
//  LoginViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/12.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapLoginButton(sender: AnyObject) {
        loginAction()
    }
    
    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func pushReturnOnId(textField: UITextField) {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func pushReturnOnPass(sender: AnyObject) {
        loginAction()
    }
    
    @IBAction func returnLogin(segue: UIStoryboardSegue) {
        cleanTextField()
    }
    
    func loginAction() {
        if isTextFieldEmpty() {
            let alertController = UIAlertController(
                title: "未入力の項目があります",
                message: "",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        // ユーザー名とパスワードでログイン
        NCMBUser.logInWithUsernameInBackground(self.userNameTextField.text, password: self.passwordTextField.text, block:{(user: NCMBUser?, error: NSError!) in
            if error != nil {
                // ログイン失敗時の処理
                if error.code == 401002 {
                    // ID/Pass認証エラー
                    let alertController = UIAlertController(
                        title: "IDもしくはパスワードが間違っています",
                        message: "",
                        preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: nil ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // その他のエラー
                    let alertController = UIAlertController(
                        title: "ログインに失敗しました",
                        message: "エラーコード：\(error.code)",
                        preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: nil ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                // ログイン成功時の処理
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.userNameTextField.text, forKey: "UserID")
                defaults.setObject(self.passwordTextField.text, forKey: "Password")
                
                self.performSegueWithIdentifier("login", sender: self)
            }
            
        })
    }
    
    func isTextFieldEmpty() -> Bool {
        return (self.userNameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty)
    }
    
    func cleanTextField() {
        userNameTextField.text = ""
        passwordTextField.text = ""
    }

}
