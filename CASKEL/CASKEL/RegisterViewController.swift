//
//  RegisterViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextField_reenter: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapRegisterButton(sender: AnyObject) {
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
        } else if isNotPasswordMatch() {
            let alertController = UIAlertController(
                title: "パスワードが一致しません",
                message: "",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        //NCMBUserのインスタンスを作成
        let user = NCMBUser()
        //ユーザー名を設定
        user.userName = self.userNameTextField.text
        //パスワードを設定
        user.password = self.passwordTextField.text
        
        //その他項目の設定
        user.setObject(self.familyNameTextField.text, forKey: "familyName")
        user.setObject(self.firstNameTextField.text, forKey: "firstName")
        user.setObject(self.schoolNameTextField.text, forKey: "school")
        user.setObject(self.gradeTextField.text, forKey: "grade")
        
        // ユーザ情報の読み込み（検索）を有効化
        let acl = NCMBACL()
        acl.setPublicReadAccess(true)
        user.ACL = acl
        
        //会員の登録を行う
        user.signUpInBackgroundWithBlock{(error: NSError!) in
            if error != nil {
                // 新規登録失敗時の処理
                if error.code == 409001 {
                    // ユーザID重複時
                    let alertController = UIAlertController(
                        title: "すでに使用されているユーザIDです",
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
                        title: "ユーザ登録に失敗しました",
                        message: "エラーコード：\(error.code)",
                        preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: nil ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                // 新規登録成功時の処理
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.userNameTextField.text, forKey: "UserID")
                defaults.setObject(self.passwordTextField.text, forKey: "Password")
                
                self.performSegueWithIdentifier("register", sender: self)
            }
        }
    }

    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func isTextFieldEmpty() -> Bool {
        return (self.userNameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty || self.passwordTextField_reenter.text!.isEmpty || self.familyNameTextField.text!.isEmpty || self.firstNameTextField.text!.isEmpty || self.schoolNameTextField.text!.isEmpty || self.gradeTextField.text!.isEmpty)
    }
    
    func isNotPasswordMatch() -> Bool {
        return (self.passwordTextField.text! != self.passwordTextField_reenter.text!)
    }
    
}
