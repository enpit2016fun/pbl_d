//
//  AddRentalGoodsViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/16.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit

class AddRentalGoodsViewController: UIViewController {
    
    @IBOutlet weak var goodsImageView: UIImageView!
    
    var goodsImage: UIImage?
    var goodsImageData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if goodsImage != nil {
            // データベース保存用に写真をJPEGに変換
            goodsImageData = UIImageJPEGRepresentation(goodsImage!, 0.5)
            goodsImageView.image = goodsImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
