//
//  InputLendViewController.swift
//  enPiT3
//
//  Created by nishimura on 2016/11/09.
//  Copyright © 2016年 TeamD. All rights reserved.
//

import UIKit

class InputLendViewController: UIViewController {
    @IBOutlet weak var lendWhat: UITextField!
    @IBOutlet weak var lendWho: UITextField!
    @IBOutlet weak var returnWhen: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConfirmLend" {
            let clvc = (segue.destination as? ConfirmLendViewController)!
            clvc.object = lendWhat.text!
            clvc.person = lendWho.text!
            clvc.date = returnWhen.date
        }
    }
    
    @IBAction func tapView(_ sender: Any) {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    @IBAction func returnInputLend(segue: UIStoryboardSegue) {
        
    }

}
