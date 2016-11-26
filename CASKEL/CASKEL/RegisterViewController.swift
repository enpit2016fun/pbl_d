//
//  RegisterViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordTextField_reenter: UITextField!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var schoolNameTextField: UITextField!
    @IBOutlet weak var schoolAndGradePicker: UIPickerView!
    
    let schoolList = ["小学校", "中学校"]
    let eSchoolGradeList = ["1年生", "2年生", "3年生", "4年生", "5年生", "6年生"]
    let jhSchoolGradeList = ["1年生", "2年生", "3年生"]
    
    var school: String = ""
    var grade: String = ""
    
    // ID・パスワードの最低文字数
    let minId = 4
    let minPass = 8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.placeholder = "半角英数\(minId)文字以上"
        passwordTextField.placeholder = "半角英数\(minPass)文字以上"
        passwordTextField_reenter.placeholder = "半角英数\(minPass)文字以上"
        
        school = schoolList[0]
        grade = eSchoolGradeList[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return schoolList.count
        } else if component == 1 {
            if school == schoolList[0] {
                return eSchoolGradeList.count
            } else if school == schoolList[1] {
                return jhSchoolGradeList.count
            }
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return schoolList[row]
        } else if component == 1 {
            if school == schoolList[0] {
                return eSchoolGradeList[row]
            } else if school == schoolList[1] {
                return jhSchoolGradeList[row]
            }
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            school = schoolList[row]
            schoolAndGradePicker.reloadComponent(1)
        } else if component == 1 {
            if school == schoolList[0] {
                grade = eSchoolGradeList[row]
            } else if school == schoolList[1] {
                grade = jhSchoolGradeList[row]
            }
        }
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
        }
        if isInvalidUserId() {
            let alertController = UIAlertController(
                title: "ユーザIDは半角英数\(minId)文字以上で入力してください",
                message: "",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.cleanUserIdTextField() } ))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        if isNotPasswordMatch() {
            let alertController = UIAlertController(
                title: "パスワードが一致しません",
                message: "",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.cleanPasswordTextField() } ))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        if isInvalidPassword() {
            let alertController = UIAlertController(
                title: "パスワードは半角英数\(minPass)文字以上で入力してください",
                message: "",
                preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.cleanPasswordTextField() } ))
            
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
        user.setObject(self.schoolNameTextField.text! + school, forKey: "school")
        user.setObject(grade, forKey: "grade")
        
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
            }
        }
        self.performSegueWithIdentifier("register", sender: self)
    }

    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func pushReturn(textField: UITextField) {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        
        if textField.tag < 3 {
            if !isAllHalfCharacters(textField.text!) {
                let alertController = UIAlertController(
                    title: "ユーザID・パスワードには半角英数字を使用してください",
                    message: "",
                    preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: { action in textField.text = "" } ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
            }
        }
        
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
    }
    
    func cleanUserIdTextField() {
        userNameTextField.text = ""
    }
    
    func cleanPasswordTextField() {
        passwordTextField.text = ""
        passwordTextField_reenter.text = ""
    }
    
    func isTextFieldEmpty() -> Bool {
        return (self.userNameTextField.text!.isEmpty || self.passwordTextField.text!.isEmpty || self.passwordTextField_reenter.text!.isEmpty || self.familyNameTextField.text!.isEmpty || self.firstNameTextField.text!.isEmpty || self.schoolNameTextField.text!.isEmpty)
    }
    
    func isNotPasswordMatch() -> Bool {
        return (self.passwordTextField.text! != self.passwordTextField_reenter.text!)
    }
    
    // 文字数とバイト数の比較によって，半角・全角の判定を行う
    func isAllHalfCharacters(text: String) -> Bool {
        return text.characters.count == text.lengthOfBytesUsingEncoding(NSShiftJISStringEncoding)
    }
    
    func isInvalidUserId() -> Bool {
        return userNameTextField.text!.characters.count < minId
    }
    
    func isInvalidPassword() -> Bool {
        return passwordTextField.text!.characters.count < minPass
    }
    
}
