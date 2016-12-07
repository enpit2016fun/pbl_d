//
//  AddRentalGoodsViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/16.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class AddRentalGoodsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var goodsTitleTextField: UITextField!
    
    var goodsImage: UIImage?
    var goodsImageData: NSData?
    
    let categoryList = ["本・マンガ", "CD・DVD", "ゲーム", "その他"]
    
    var category: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goodsImage == nil {
            goodsImage = UIImage(named: "NoImage.png")
        }
        goodsImageView.image = goodsImage
        
        // データベース保存用に写真をJPEGに変換
        goodsImageData = UIImageJPEGRepresentation(goodsImage!, 0.5)
        
        category = categoryList[0]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category = categoryList[row]
    }
    
    @IBAction func tapView(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func pushReturn(sender: AnyObject) {
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
        view.endEditing(true)
        
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
        
        //*** データベースへグッズ情報を送信 ***
        let userid = NCMBUser.currentUser().userName
        // 保存先クラスを作成
        let obj = NCMBObject(className: "GoodsTable")
        // 値を設定
        obj.setObject(userid, forKey: "owner")
        obj.setObject(goodsTitleTextField.text!, forKey: "title")
        obj.setObject(category, forKey: "category")
        obj.setObject(false, forKey: "isLend")
        // 保存を実施
        obj.saveInBackgroundWithBlock{(error: NSError!) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                let alertController = UIAlertController(
                    title: "データベース接続エラー",
                    message: "エラーコード：\(error.code)",
                    preferredStyle: .Alert)
                
                alertController.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil ))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                // 保存に成功した場合の処理
                let file = NCMBFile.fileWithName(obj.objectId + ".jpg", data: self.goodsImageData) as! NCMBFile
                
                // ファイルストアへ画像のアップロード
                file.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
                    if error != nil {
                        // 保存失敗時の処理
                        let alertController = UIAlertController(
                            title: "登録エラー",
                            message: "エラーコード：\(error.code)",
                            preferredStyle: .Alert)
                        
                        alertController.addAction(UIAlertAction(
                            title: "OK",
                            style: .Default,
                            handler: nil ))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    } else {
                        // 保存成功時の処理
                    }
                    
                    }, progressBlock: { (int: Int32) -> Void in
                        // 進行状況を取得するためのBlock
                        /* 1-100のpercentDoneを返す */
                        /* このコールバックは保存中何度も呼ばれる */
                        
                })
            }
        }
        self.performSegueWithIdentifier("registerComplete", sender: self)
    }
    
    func isTextFieldEmpty() -> Bool {
        return goodsTitleTextField.text!.isEmpty
    }
    
}
