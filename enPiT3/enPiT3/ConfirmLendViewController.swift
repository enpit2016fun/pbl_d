//
//  ConfirmLendInfoViewController.swift
//  enPiT3
//
//  Created by nishimura on 2016/11/09.
//  Copyright © 2016年 TeamD. All rights reserved.
//

import UIKit

class ConfirmLendViewController: UIViewController {
    @IBOutlet weak var what: UILabel!
    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var when: UILabel!
    
    var object:String?
    var person:String?
    var date:Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        what.text = object
        who.text = person
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        when.text = df.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
