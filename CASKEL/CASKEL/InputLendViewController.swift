//
//  InputLendViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class InputLendViewController: UIViewController {
    
    @IBOutlet weak var lendWhat: UITextField!
    @IBOutlet weak var lendWho: UITextField!
    @IBOutlet weak var returnWhen: UIDatePicker!
    @IBOutlet weak var nameLabel: UILabel!
    
    var goodsId: String = ""
    var goodsName: String = ""
    
    var renterId: String = ""
    var renterName: String = ""
    
    var returnOrigin: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        
        setupDatePicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapDecisionButton(sender: AnyObject) {
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
        
        self.performSegueWithIdentifier("toConfirm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toConfirm" {
            let clvc = segue.destinationViewController as! ConfirmLendViewController
            clvc.goodsId = goodsId
            clvc.goodsName = goodsName
            clvc.personId = renterId
            clvc.personName = renterName
            
            let cal = NSCalendar.currentCalendar()
            
            let originalComp = cal.components([.Year, .Month, .Day], fromDate: returnWhen.date)
            
            let novelComp = NSDateComponents()
            novelComp.year = originalComp.year
            novelComp.month = originalComp.month
            novelComp.day = originalComp.day
            novelComp.hour = 0
            novelComp.minute = 0
            novelComp.second = 0
            
            clvc.date = cal.dateFromComponents(novelComp)!
        } else if segue.identifier == "goodsSelect" {
            let givc = segue.destinationViewController as! GoodsInfoViewController
            givc.selectEnable = true
            givc.prevSelectedId = goodsId
            givc.prevSelectedName = goodsName
        } else if segue.identifier == "userSearch" {
            let svc = segue.destinationViewController as! SearchViewController
            svc.prevRenterId = renterId
            svc.prevRenterName = renterName
        }
    }
    
    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func pushReturnOnGoods(textField: UITextField) {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func pushReturnOnPerson(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func returnInputLend(segue: UIStoryboardSegue) {
        if returnOrigin == "goods" {
            lendWhat.text = goodsName
        } else if returnOrigin == "renter" {
            lendWho.text = renterId
            nameLabel.text = ""
        
            if !renterName.isEmpty {
                nameLabel.text = renterName
            } else if !renterId.isEmpty {
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
                            handler: { action in self.initNameField() } ))
                    
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        // 検索成功時の処理
                        if objects.count <= 0 {
                            // ユーザ該当なし
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
                            // 該当ユーザがいる場合
                            let family = objects[0].objectForKey("familyName") as? String
                            let first = objects[0].objectForKey("firstName") as? String
                        
                            self.renterName = "\(family!) \(first!)"
                            self.nameLabel.text = self.renterName
                        }
                    }
                })
            }
        }
    }
    
    func isTextFieldEmpty() -> Bool {
        return (lendWhat.text!.isEmpty || lendWho.text!.isEmpty || nameLabel.text!.isEmpty)
    }
    
    func setupDatePicker() {
        let day: Double = 60*60*24
        let week: Double = day * 7
        
        let defaultDate = NSDate(timeIntervalSinceNow: day)
        let minDate = NSDate(timeIntervalSinceNow: day)
        let maxDate = NSDate(timeIntervalSinceNow: week * 4)
        
        returnWhen.date = defaultDate
        returnWhen.minimumDate = minDate
        returnWhen.maximumDate = maxDate
    }
    
    func initNameField() {
        lendWho.text = ""
        nameLabel.text = ""
        renterId = ""
        renterName = ""
    }
    
}
