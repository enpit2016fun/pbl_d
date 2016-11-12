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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toConfirmLend" {
            let clvc = segue.destinationViewController as! ConfirmLendViewController
            clvc.object = lendWhat.text!
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

}
