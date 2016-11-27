//
//  SearchViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/27.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var familyNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var idPickerView: UIPickerView!
    
    var isIDValid = false
    
    var idList: [String] = [""]
    
    var renterId: String = ""
    var renterName: String = ""
    
    var prevRenterId: String = ""
    var prevRenterName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        
        // 編集終了時，貸した相手のIDからユーザ情報を取得
        idTextField.addTarget(self, action: #selector(researchUserForId(_:)), forControlEvents: .EditingDidEnd)
        
        familyNameTextField.addTarget(self, action: #selector(researchUserForName(_:)), forControlEvents: .EditingDidEnd)
        
        firstNameTextField.addTarget(self, action: #selector(researchUserForName(_:)), forControlEvents: .EditingDidEnd)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func tapSelectButton(sender: AnyObject) {
        // テキストフィールド編集中にボタンを押した場合にも，編集終了の処理を行う
        view.endEditing(true)
        
        if !isIDValid {
            let alertController = UIAlertController(
                title: "ユーザが選択されていません",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        if renterId == NCMBUser.currentUser().userName {
            let alertController = UIAlertController(
                title: "自分のIDが選択されています",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        renterName = nameLabel.text!
        
        performSegueWithIdentifier("renterSelected", sender: self)
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        renterId = prevRenterId
        renterName = prevRenterName
        performSegueWithIdentifier("renterSelected", sender: self)
    }
    
    @IBAction func pushReturn(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func newInputOnId(sender: AnyObject) {
        initNameField()
    }
    
    @IBAction func newInputOnName(sender: AnyObject) {
        initIdField()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "renterSelected" {
            let ilvc = segue.destinationViewController as! InputLendViewController
            ilvc.renterId = renterId
            ilvc.renterName = renterName
            ilvc.returnOrigin = "renter"
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return idList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return idList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        renterId = idList[row]
    }
    
    func researchUserForId(textField: UITextField) {
        if textField.text! == NCMBUser.currentUser().userName {
            let alertController = UIAlertController(
                title: "自分のユーザIDが入力されています",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.initIdField() } ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        renterId = textField.text!
        
        let query = NCMBUser.query()
        
        /** ここに条件 **/
        query.whereKey("userName", equalTo: renterId)
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                let alertController = UIAlertController(
                    title: "データベース接続エラー",
                    message: "",
                    preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: { action in self.initIdField() } ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 検索成功時の処理
                if objects.count <= 0 {
                    // ユーザ該当なし
                    let alertController = UIAlertController(
                        title: "入力されたIDのユーザは存在しません",
                        message: "",
                        preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: { action in self.initIdField() } ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // 該当ユーザがいる場合
                    let family = objects[0].objectForKey("familyName") as? String
                    let first = objects[0].objectForKey("firstName") as? String
                    self.nameLabel.text = "\(family!) \(first!)"
                    
                    self.isIDValid = true
                }
            }
        })
    }
    
    func researchUserForName(textField: UITextField) {
        let query = NCMBUser.query()
        
        /** ここに条件 **/
        if !familyNameTextField.text!.isEmpty {
            query.whereKey("familyName", equalTo: familyNameTextField.text)
        }
        if !firstNameTextField.text!.isEmpty {
            query.whereKey("firstName", equalTo: firstNameTextField.text)
        }
        
        // データストアの検索を実施
        query.findObjectsInBackgroundWithBlock({(objects, error) in
            if (error != nil){
                // 検索失敗時の処理
                let alertController = UIAlertController(
                    title: "データベース接続エラー",
                    message: "",
                    preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: { action in self.initNameField() } ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 検索成功時の処理
                if objects.count <= 0 {
                    // ユーザ該当なし
                    let alertController = UIAlertController(
                        title: "入力された名前のユーザは存在しません",
                        message: "",
                        preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(
                        title: "OK",
                        style: .Default,
                        handler: { action in self.initNameField() } ))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    // 該当ユーザがいる場合
                    self.idList = []
                    for object in objects {
                        self.idList.append(object.userName)
                        self.idPickerView.reloadComponent(0)
                    }
                    self.renterId = self.idList[0]
                    self.isIDValid = true
                }
            }
        })
    }
    
    func initIdField() {
        idTextField.text = ""
        nameLabel.text = ""
        isIDValid = false
    }
    
    func initNameField() {
        familyNameTextField.text = ""
        firstNameTextField.text = ""
        idList = [""]
        isIDValid = false
        idPickerView.reloadComponent(0)
    }
    
}
