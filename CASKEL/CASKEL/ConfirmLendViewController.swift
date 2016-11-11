//
//  ConfirmLendInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class ConfirmLendViewController: UIViewController {
    @IBOutlet weak var what: UILabel!
    @IBOutlet weak var who: UILabel!
    @IBOutlet weak var when: UILabel!
    
    var object:String?
    var person:String?
    var date:NSDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        what.text = object
        who.text = person
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        when.text = df.stringFromDate(date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
