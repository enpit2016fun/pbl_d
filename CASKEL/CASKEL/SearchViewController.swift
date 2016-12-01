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
    @IBOutlet weak var assessLabel: UILabel!
    @IBOutlet weak var assessImage: UIImageView!
    
    var isIDValid = false
    
    var idList: [String] = [""]
    var assessList: [String: Double] = [:]
    
    var renterId: String = ""
    var renterName: String = ""
    
    var prevRenterId: String = ""
    var prevRenterName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        assessLabel.text = ""
        assessImage.image = starImage(0.0)
        
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
        
        if !nameLabel.text!.isEmpty {
            renterName = nameLabel.text!
        } else if !familyNameTextField.text!.isEmpty && !firstNameTextField.text!.isEmpty {
            renterName = "\(familyNameTextField.text!) \(firstNameTextField.text!)"
        } else {
            renterName = ""
        }
        
        performSegueWithIdentifier("renterSelected", sender: self)
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        renterId = prevRenterId
        renterName = prevRenterName
        performSegueWithIdentifier("renterSelected", sender: self)
    }
    
    @IBAction func pushReturnOnId(sender: AnyObject) {
        initNameField()
        view.endEditing(true)
    }
    
    @IBAction func pushReturnOnName(sender: AnyObject) {
        initIdField()
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
        if assessList[renterId] != nil {
            if assessList[renterId] < 0.0 {
                assessLabel.text = "まだ評価はありません"
                assessImage.image = starImage(0.0)
            } else {
                assessLabel.text = ""
                assessImage.image = starImage(exRoundUp(assessList[renterId]!))
            }
        } else {
            getUserAssess(renterId)
        }
    }
    
    func researchUserForId(textField: UITextField) {
        if isIdTextFieldEmpty() {
            return
        }
        
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
                    
                    if self.assessList[self.renterId] != nil {
                        if self.assessList[self.renterId] < 0.0 {
                            self.assessLabel.text = "まだ評価はありません"
                            self.assessImage.image = self.starImage(0.0)
                        } else {
                            self.assessLabel.text = ""
                            self.assessImage.image = self.starImage(self.exRoundUp(self.assessList[self.renterId]!))
                        }
                    } else {
                        self.getUserAssess(self.renterId)
                    }
                    
                    self.isIDValid = true
                }
            }
        })
    }
    
    func researchUserForName(textField: UITextField) {
        if isNameTextFieldEmpty() {
            return
        }
        
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
                    
                    if self.assessList[self.renterId] != nil {
                        if self.assessList[self.renterId] < 0.0 {
                            self.assessLabel.text = "まだ評価はありません"
                            self.assessImage.image = self.starImage(0.0)
                        } else {
                            self.assessLabel.text = ""
                            self.assessImage.image = self.starImage(self.exRoundUp(self.assessList[self.renterId]!))
                        }
                    } else {
                        self.getUserAssess(self.renterId)
                    }
                    
                    self.isIDValid = true
                }
            }
        })
    }
    
    func getUserAssess(userid: String) {
        let query = NCMBQuery(className: "AssessTable")
        
        /** ここに条件 **/
        query.whereKey("user", equalTo: userid)
        
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
                    handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 検索成功時の処理
                if objects.count <= 0 {
                    // 評価なし
                    self.assessList[userid] = -1.0
                    self.assessLabel.text = "まだ評価はありません"
                    self.assessImage.image = self.starImage(0.0)
                } else {
                    // 評価あり
                    var sum = 0
                    for object in objects {
                        sum += (object.objectForKey("value") as? Int)!
                    }
                    let mean = Double(sum) / Double(objects.count)
                    self.assessList[userid] = mean
                    self.assessLabel.text = ""
                    self.assessImage.image = self.starImage(self.exRoundUp(mean))
                }
            }
        })
    }
    
    func initIdField() {
        idTextField.text = ""
        nameLabel.text = ""
        idList = [""]
        idPickerView.reloadComponent(0)
        assessLabel.text = ""
        assessImage.image = starImage(0.0)
        isIDValid = false
    }
    
    func initNameField() {
        familyNameTextField.text = ""
        firstNameTextField.text = ""
        idList = [""]
        idPickerView.reloadComponent(0)
        assessLabel.text = ""
        assessImage.image = starImage(0.0)
        isIDValid = false
    }
    
    func isIdTextFieldEmpty() -> Bool {
        return idTextField.text!.isEmpty
    }
    
    func isNameTextFieldEmpty() -> Bool {
        return familyNameTextField.text!.isEmpty && firstNameTextField.text!.isEmpty
    }
    
    // 0.5刻みで切り上げを行う
    func exRoundUp(num: Double) -> Double {
        let intPart = Double(Int(num))
        if num - intPart == 0.0 {
            return intPart
        } else if num - intPart <= 0.5 {
            return intPart + 0.5
        } else {
            return intPart + 1.0
        }
    }
    
    func starImage(assess: Double) -> UIImage {
        if assess == 0.0 {
            return UIImage(named: "zero_star")!
        } else if assess == 0.5 {
            return UIImage(named: "half_star")!
        } else if assess == 1.0 {
            return UIImage(named: "one_star")!
        } else if assess == 1.5 {
            return UIImage(named: "one_half")!
        } else if assess == 2.0 {
            return UIImage(named: "two_star")!
        } else if assess == 2.5 {
            return UIImage(named: "two_half")!
        } else if assess == 3.0 {
            return UIImage(named: "three_star")!
        } else if assess == 3.5 {
            return UIImage(named: "three_half")!
        } else if assess == 4.0 {
            return UIImage(named: "four_star")!
        } else if assess == 4.5 {
            return UIImage(named: "four_half")!
        } else {
            return UIImage(named: "five_star")!
        }
    }
    
}
