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

    override func viewDidLoad() {
        super.viewDidLoad()
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
            clvc.goods = lendWhat.text!
            clvc.person = lendWho.text!
            clvc.date = returnWhen.date
        }
    }
    
    @IBAction func tapView(sender: AnyObject) {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    @IBAction func returnInputLend(segue: UIStoryboardSegue) {
        
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

}
