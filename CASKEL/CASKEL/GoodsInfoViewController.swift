//
//  GoodsInfoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/22.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class GoodsInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backgroudImage: UIImageView!
    @IBOutlet weak var goodsList: UITableView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var categoryButton1: UIButton!
    @IBOutlet weak var categoryButton2: UIButton!
    @IBOutlet weak var categoryButton3: UIButton!
    @IBOutlet weak var categoryButton4: UIButton!
    
    var idList: [String] = []
    // idをキーとした連想配列で管理する
    var imageList: [String: UIImage] = [:]
    var titleList: [String: String] = [:]
    var categoryList: [String: String] = [:]
    var enableList: [String: Bool] = [:]
    
    var selectEnable: Bool = false
    
    var selectedGoodsId: String = ""
    var selectedGoodsName: String = ""
    
    var prevSelectedId: String = ""
    var prevSelectedName: String = ""
    
    let allCategories = ["本・漫画", "CD・DVD", "ゲーム", "その他"]
    
    var selectedCategory: String = ""
    var selectedIdList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCategoryButton()
        pushedButton(categoryButton1)
        selectedCategory = allCategories[0]
        
        if selectEnable {
            backgroudImage.image = UIImage(named: "kashidashi")
            selectButton.enabled = true
            selectButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            selectButton.backgroundColor = UIColor.blueColor()
        } else {
            backgroudImage.image = UIImage(named: "EXkashi")
            selectButton.enabled = false
            selectButton.setTitleColor(UIColor.clearColor(), forState: UIControlState.Normal)
            selectButton.backgroundColor = UIColor.clearColor()
            goodsList.allowsSelection = false
        }
        
        let query = NCMBQuery(className: "GoodsTable")
        
        /** ここに条件 **/
        query.whereKey("owner", equalTo: NCMBUser.currentUser().userName)
        if selectEnable {
            query.whereKey("isLend", equalTo: false)
        }
        
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
                    self.enableList[id] = (object.objectForKey("isLend") as? Bool)!
                    
                    let file: NCMBFile = NCMBFile.fileWithName(object.objectId + ".jpg" ,data: nil) as! NCMBFile
                    
                    file.getDataInBackgroundWithBlock { (image: NSData!, error: NSError!) -> Void in
                        if error != nil {
                            // ファイル取得失敗時の処理
                            self.imageList[id] = (UIImage(named: "NoImage.png")!)
                        } else {
                            // ファイル取得成功時の処理
                            if image != nil {
                                self.imageList[id] = (UIImage(data: image!)!)
                            } else {
                                self.imageList[id] = (UIImage(named: "NoImage.png")!)
                            }
                        }
                        
                        self.updateCategory()
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
        return selectedIdList.count
    }
    
    func tableView(goodsList: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = goodsList.dequeueReusableCellWithIdentifier("goodsListCell", forIndexPath: indexPath)
        
        let id = selectedIdList[indexPath.row]
        
        let imageView = goodsList.viewWithTag(1) as! UIImageView
        imageView.image = imageList[id]
        
        let titleLabel = goodsList.viewWithTag(2) as! UILabel
        titleLabel.text = titleList[id]
        
        let categoryLabel = goodsList.viewWithTag(3) as! UILabel
        categoryLabel.text = categoryList[id]
        
        cell.backgroundColor = UIColor.whiteColor()
        if enableList[id]! {
            cell.backgroundColor = UIColor.orangeColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id = selectedIdList[indexPath.row]
        selectedGoodsId = id
        selectedGoodsName = titleList[id]!
    }
    
    @IBAction func tapCategoryButton(button: UIButton) {
        selectedCategory = (button.titleLabel?.text)!
        resetCategoryButton()
        pushedButton(button)
        updateCategory()
        
        selectedGoodsId = ""
        selectedGoodsName = ""
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
    
    func initCategoryButton() {
        categoryButton1.setTitle(allCategories[0], forState: UIControlState.Normal)
        
        categoryButton2.setTitle(allCategories[1], forState: UIControlState.Normal)
        
        categoryButton3.setTitle(allCategories[2], forState: UIControlState.Normal)
        
        categoryButton4.setTitle(allCategories[3], forState: UIControlState.Normal)
        
        resetCategoryButton()
    }
    
    func resetCategoryButton() {
        categoryButton1.selected = false
        categoryButton1.enabled = true
        categoryButton1.backgroundColor = UIColor.whiteColor()
        
        categoryButton2.selected = false
        categoryButton2.enabled = true
        categoryButton2.backgroundColor = UIColor.whiteColor()
        
        categoryButton3.selected = false
        categoryButton3.enabled = true
        categoryButton3.backgroundColor = UIColor.whiteColor()
        
        categoryButton4.selected = false
        categoryButton4.enabled = true
        categoryButton4.backgroundColor = UIColor.whiteColor()
    }
    
    func pushedButton(button: UIButton) {
        button.selected = true
        button.enabled = false
        button.backgroundColor = UIColor.lightGrayColor()
    }
    
    func updateCategory() {
        selectedIdList = []
        for id in idList {
            if categoryList[id] == selectedCategory {
                selectedIdList.append(id)
            }
        }
        goodsList.reloadData()
    }
    
    func isSelected() -> Bool {
        return (!selectedGoodsId.isEmpty && !selectedGoodsName.isEmpty)
    }
    
}
