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
    
    var isIDValid = false
    
    var goodsId: String = ""
    var goodsName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lendWhat.enabled = false
        
        nameLabel.text = ""
        setupDatePicker()
        
        // 編集終了時，貸した相手のIDからユーザ情報を取得
        lendWho.addTarget(self, action: #selector(researchUser(_:)), forControlEvents: .EditingDidEnd)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapDecisionButton(sender: AnyObject) {
        // テキストフィールド編集中にボタンを押した場合にも，編集終了の処理を行う
        view.endEditing(true)
        
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
        
        if !isIDValid {
            let alertController = UIAlertController(
                title: "存在しないユーザIDが指定されています",
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
            clvc.personId = lendWho.text!
            clvc.personName = nameLabel.text!
            
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
        lendWhat.text = goodsName
    }
    
    func isTextFieldEmpty() -> Bool {
        return (self.lendWhat.text!.isEmpty || self.lendWho.text!.isEmpty)
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
    
    func researchUser(textField: UITextField) {
        if textField.text! == NCMBUser.currentUser().userName {
            let alertController = UIAlertController(
                title: "自分のユーザIDが入力されています",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.pushOK() } ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        let query = NCMBUser.query()
        
        /** ここに条件 **/
        query.whereKey("userName", equalTo: textField.text!)
        
        // データストアの検索を実施
        // *** バックグラウンドで行うと反映されない可能性があるので同期処理で検索 ***
        var objects: [AnyObject] = []
        do {
            objects = try query.findObjects()
        } catch {
            // 検索失敗時の処理
            let alertController = UIAlertController(
                title: "データベース接続エラー",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: { action in self.pushOK() } ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
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
                handler: { action in self.pushOK() } ))
                    
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // 該当ユーザがいる場合
            let family = objects[0].objectForKey("familyName") as? String
            let first = objects[0].objectForKey("firstName") as? String
            self.nameLabel.text = "\(family!) \(first!)"
                    
            self.isIDValid = true
        }
    }
    
    func pushOK() {
        lendWho.text = ""
        nameLabel.text = ""
        isIDValid = false
    }

}
