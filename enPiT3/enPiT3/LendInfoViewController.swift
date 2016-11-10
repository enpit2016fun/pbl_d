//
//  LendInfoViewController.swift
//  enPiT3
//
//  Created by nishimura on 2016/11/09.
//  Copyright © 2016年 TeamD. All rights reserved.
//

import UIKit

class LendInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lendList: UITableView!
    
    let objectList: NSArray = ["aaa", "sss"]
    let personList: NSArray = ["ppp", "qqq"]
    let dateList: NSArray = ["2016/11/15", "2016/11/22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ lendList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectList.count
    }
    
    func tableView(_ lendList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lendList.dequeueReusableCell(withIdentifier: "lendListCell", for: indexPath)
        
        let objectLabel = lendList.viewWithTag(1) as! UILabel
        objectLabel.text = "\(objectList[indexPath.row])"
        
        let personLabel = lendList.viewWithTag(2) as! UILabel
        personLabel.text = "\(personList[indexPath.row])"
        
        let dateLabel = lendList.viewWithTag(3) as! UILabel
        dateLabel.text = "\(dateList[indexPath.row])"
        
        return cell
    }
    
    @IBAction func returnButtonAction(_ sender: UIButton) {
        let cell = sender.superview?.superview as! UITableViewCell
        let row = lendList.indexPath(for: cell)?.row
        
        let alertController = UIAlertController(
            title: "返してもらった？",
            message: "行番号：\(row!)",
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: { action in self.pushOK() } ))
        
        alertController.addAction(UIAlertAction(
            title: "キャンセル",
            style: .cancel,
            handler: { action in self.pushCancel() } ))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func pushOK() {
        
    }
    
    func pushCancel() {
        
    }
    
}
