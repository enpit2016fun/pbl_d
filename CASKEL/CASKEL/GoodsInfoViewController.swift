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
    // idをキーとした連想配列で管理する
    var imageList: [String: UIImage] = [:]
    var titleList: [String: String] = [:]
    var categoryList: [String: String] = [:]
    
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
                    handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 検索成功時の処理
                for object in objects {
                    let id = object.objectId
                    
                    self.idList.append(id)
                    self.titleList[id] = object.objectForKey("title") as? String
                    self.categoryList[id] = object.objectForKey("category") as? String
                    
                    let file: NCMBFile = NCMBFile.fileWithName(object.objectId + ".jpg" ,data: nil) as! NCMBFile
                    
                    file.getDataInBackgroundWithBlock { (image: NSData!, error: NSError!) -> Void in
                        if error != nil {
                            // ファイル取得失敗時の処理
                            let alertController = UIAlertController(
                                title: "データベース接続エラー",
                                message: "",
                                preferredStyle: .Alert)
                            
                            alertController.addAction(UIAlertAction(
                                title: "OK",
                                style: .Default,
                                handler: nil ))
                            
                            self.presentViewController(alertController, animated: true, completion: nil)
                        } else {
                            // ファイル取得成功時の処理
                            if image != nil {
                                self.imageList[id] = (UIImage(data: image!)!)
                            } else {
                                self.imageList[id] = (UIImage(named: "NoImage.png")!)
                            }
                            
                            self.goodsList.reloadData()
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodsSelected" {
            let ilvc = segue.destinationViewController as! InputLendViewController
            ilvc.goodsId = selectedGoodsId
            ilvc.goodsName = selectedGoodsName
            ilvc.returnOrigin = "goods"
        }
    }
    
    func tableView(goodsList: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(goodsList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = goodsList.dequeueReusableCellWithIdentifier("goodsListCell", forIndexPath: indexPath)
        
        let id = idList[indexPath.row]
        
        let imageView = goodsList.viewWithTag(1) as! UIImageView
        imageView.image = imageList[id]
        
        let titleLabel = goodsList.viewWithTag(2) as! UILabel
        titleLabel.text = titleList[id]
        
        let categoryLabel = goodsList.viewWithTag(3) as! UILabel
        categoryLabel.text = categoryList[id]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = idList[indexPath.row]
        selectedGoodsId = id
        selectedGoodsName = titleList[id]!
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
