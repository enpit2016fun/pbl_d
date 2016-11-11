//
//  RegisterViewController.swift
//  enPiT3
//
//  Created by nishimura on 2016/11/10.
//  Copyright © 2016年 TeamD. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapView(_ sender: Any) {
        //キーボードを閉じる
        view.endEditing(true)
    }
}
