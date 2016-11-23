//
//  GoodsInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/22.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class GoodsInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var goodsList: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    
    var idList: [String] = []
    var imageList: [UIImage] = []
    var titleList: [String] = []
    var categoryList: [String] = []
    
    var selectEnable: Bool = false
    
    var selectedGoodsId: String = ""
    var selectedGoodsName: String = ""
    
    var prevSelectedId: String = ""
    var prevSelectedName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectEnable {
            selectButton.enabled = true
            selectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            selectButton.backgroundColor = UIColor.blueColor()
        } else {
            selectButton.enabled = false
            selectButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
            selectButton.backgroundColor = UIColor.clearColor()
            goodsList.allowsSelection = false
        }
        
        let query = NCMBQuery(className: "GoodsTable")
        
        /** ここに条件 **/
        query.whereKey("owner", equalTo: NCMBUser.currentUser().userName)
        
        // データストアの検索を実施
        // *** バックグラウンドで行うとテーブルに反映されないので同期処理で検索 ***
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
                handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        for object in objects {
            idList.append(object.objectId)
            titleList.append((object.objectForKey("title") as? String)!)
            categoryList.append((object.objectForKey("category") as? String)!)
            
            let file: NCMBFile = NCMBFile.fileWithName(object.objectId + ".jpg" ,data: nil) as! NCMBFile
            var image: NSData? = nil
            do {
                image = try file.getData()
            } catch {
                let alertController = UIAlertController(
                    title: "データベース接続エラー",
                    message: "",
                    preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            if image != nil {
                imageList.append(UIImage(data: image!)!)
            } else {
                imageList.append(UIImage(named: "NoImage.png")!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodsSelected" {
            let ilvc = segue.destinationViewController as! InputLendViewController
            ilvc.goodsId = selectedGoodsId
            ilvc.goodsName = selectedGoodsName
        }
    }
    
    func tableView(goodsList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idList.count
    }
    
    func tableView(goodsList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = goodsList.dequeueReusableCellWithIdentifier("goodsListCell", forIndexPath: indexPath)
        
        let imageView = goodsList.viewWithTag(1) as! UIImageView
        imageView.image = imageList[indexPath.row]
        
        let titleLabel = goodsList.viewWithTag(2) as! UILabel
        titleLabel.text = titleList[indexPath.row]
        
        let categoryLabel = goodsList.viewWithTag(3) as! UILabel
        categoryLabel.text = categoryList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedGoodsId = idList[indexPath.row]
        selectedGoodsName = titleList[indexPath.row]
    }
    
    @IBAction func tapSelectButton(sender: AnyObject) {
        if isSelected() {
            performSegueWithIdentifier("goodsSelected", sender: self)
        } else {
            let alertController = UIAlertController(
                title: "貸し出し品が未選択です",
                message: "",
                preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(
                title: "OK",
                style: .Default,
                handler: nil ))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapBackButton(sender: AnyObject) {
        if selectEnable {
            selectedGoodsId = prevSelectedId
            selectedGoodsName = prevSelectedName
            performSegueWithIdentifier("goodsSelected", sender: self)
        } else {
            performSegueWithIdentifier("returnMenu", sender: self)
        }
    }
    
    func isSelected() -> Bool {
        return (!selectedGoodsId.isEmpty && !selectedGoodsName.isEmpty)
    }
    
}
