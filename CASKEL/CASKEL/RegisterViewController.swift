//
//  RegisterViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/11.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
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
    
    @IBAction func tapRegisterButton(sender: AnyObject) {
        //*** データベースへの接続例 ***
        // 保存先クラスを作成
        let obj = NCMBObject(className: "TestClass")
        // 値を設定
        obj.setObject("Hello,NCMB!", forKey: "message")
        // 保存を実施
        obj.saveInBackgroundWithBlock{(error: NSError!) in
            if (error != nil) {
                // 保存に失敗した場合の処理
                print("エラーが発生しました。エラーコード:\(error.code)")
            }else{
                // 保存に成功した場合の処理
                print("保存に成功しました。objectId:\(obj.objectId)")
            }
        }
    }

    @IBAction func tapView(sender: AnyObject) {
        //キーボードを閉じる
        view.endEditing(true)
    }
    
}
