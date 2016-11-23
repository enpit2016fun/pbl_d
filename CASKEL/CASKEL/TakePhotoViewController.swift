//
//  TakePhotoViewController.swift
//  CASKEL
//
//  Created by nishimura on 2016/11/16.
//  Copyright © 2016年 enPiT TeamD. All rights reserved.
//

import UIKit
import AVFoundation

class TakePhotoViewController: UIViewController {
    
    @IBOutlet weak var cameraPreview: UIView!
    
    var input: AVCaptureDeviceInput!
    var output: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    var camera: AVCaptureDevice!
    
    var takenImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCamera()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // camera stop メモリ解放
        session.stopRunning()
        
        for output in session.outputs {
            session.removeOutput(output as? AVCaptureOutput)
        }
        
        for input in session.inputs {
            session.removeInput(input as? AVCaptureInput)
        }
        session = nil
        camera = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodsRegister" {
            let argvc = segue.destinationViewController as! AddRentalGoodsViewController
            argvc.goodsImage = takenImage
        }
    }
    
    func setupCamera(){
        // セッション
        session = AVCaptureSession()
        
        for caputureDevice: AnyObject in AVCaptureDevice.devices() {
            // 背面カメラを取得
            if caputureDevice.position == AVCaptureDevicePosition.Back {
                camera = caputureDevice as? AVCaptureDevice
            }
        }
        
        // カメラからの入力データ
        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }
        // 入力をセッションに追加
        if(session.canAddInput(input)) {
            session.addInput(input)
        }
        
        // 静止画出力のインスタンス生成
        output = AVCaptureStillImageOutput()
        // 出力をセッションに追加
        if(session.canAddOutput(output)) {
            session.addOutput(output)
        }
        
        // セッションからプレビューを表示
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
        previewLayer.frame = cameraPreview.frame
        
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // レイヤーをViewに設定
        self.view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    @IBAction func tapTakePhotoButton(sender: AnyObject) {
        // ビデオ出力に接続
        if let connection: AVCaptureConnection? = output.connectionWithMediaType(AVMediaTypeVideo){
            // ビデオ出力から画像を非同期で取得
            output.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (imageDataBuffer, error) -> Void in
                
                // 取得画像のDataBufferをJpegに変換
                let imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                
                // JpegからUIImageを作成
                let image = UIImage(data: imageData)!
                
                self.takenImage = self.cropSquareImage(image)
                
                self.performSegueWithIdentifier("goodsRegister", sender: self)
            })
        }
    }
    
    @IBAction func returnTakePhoto(segue: UIStoryboardSegue) {
        
    }
    
    // 画像を中心から正方形にクリップする
    func cropSquareImage(image: UIImage) -> UIImage {
        // CGImageに変換する際に回転させないための処理
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, CGFloat(image.size.width), CGFloat(image.size.height)))
        let redrawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // パラメータ設定
        let origWidth = redrawnImage.size.width
        let origHeight = redrawnImage.size.height
        var x: CGFloat = 0
        var y: CGFloat = 0
        var w: CGFloat = 0
        var h: CGFloat = 0
        if origWidth < origHeight {
            x = 0
            y = (origHeight - origWidth) / 2
            w = origWidth
            h = origWidth
        } else {
            x = (origWidth - origHeight) / 2
            y = 0
            w = origHeight
            h = origHeight
        }
        
        // 切り抜き処理
        let cropRect  = CGRectMake(x, y, w, h)
        let cropRef   = CGImageCreateWithImageInRect(redrawnImage.CGImage, cropRect)
        let cropImage = UIImage(CGImage: cropRef!, scale: redrawnImage.scale, orientation: redrawnImage.imageOrientation)
        
        return cropImage
    }

}
