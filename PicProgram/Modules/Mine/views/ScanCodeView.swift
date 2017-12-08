//
//  ScanCodeView.swift
//  PicProgram
//
//  Created by sliencio on 2017/12/7.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import AVFoundation

class ScanCodeView: BaseView,AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var qrView: UIView!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    @IBOutlet weak var qrContentView: UIView!
    @IBOutlet weak var qrContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var qrContentWidth: NSLayoutConstraint!
    
    open weak var delegate:MineViewProtocol!

    
    
    @IBAction func backAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let width = (SCREEN_WIDTH - 170)
//        qrContentView.size = CGSize.init(width: width, height: width)
        qrContentWidth.constant = width
        qrContentHeight.constant = width
        qrContentView.updateConstraints()
        let bottom = self.qrView.height - width - 36
        let X = (85 < bottom) ? (85 - bottom) : (bottom - 85)
        let maskView = UIView.init(frame: CGRect.init(x:X, y: 36 - bottom , width: SCREEN_WIDTH - 2 * X, height: width + bottom * 2))
        maskView.layer.borderWidth = bottom
        maskView.layer.borderColor = xsColor("000000", alpha: 0.6).cgColor
        self.qrView.addSubview(maskView)
        qrContentView.layer.borderWidth = 1
        qrContentView.layer.borderColor = xsColor_main_white.cgColor
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do{
            let input = try AVCaptureDeviceInput.init(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        }catch{
            print(error)
            return;
        }
        // 初始化 AVCaptureMetadataOutput 对象，并将它作为输出
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        // 设置 delegate 并使用默认的 dispatch 队列来执行回调
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        captureMetadataOutput.rectOfInterest = CGRect.init(x: qrContentView.y/qrView.height, y: qrContentView.x/qrView.width, width: qrContentView.height/qrView.height, height: qrContentView.width/qrView.width )
        // 初始化视频预览 layer，并将其作为 viewPreview 的 sublayer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: (qrView.layer.bounds).size.height)
        qrView.layer.insertSublayer(videoPreviewLayer!, at: 0)
        captureSession?.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            print("No QR code is detected")
            HUDTool.show(.text, text: "请将二维码对准摄像头", delay: 1, view: self, complete: nil)
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if metadataObj.stringValue != nil {
                print("qr result is \(metadataObj.stringValue ?? "")")
                delegate.scanCode!(result: metadataObj.stringValue!)
                captureSession?.stopRunning()
                HUDTool.show(.text, text: "扫描已成功", delay: 1, view: self, complete: {
                    [weak self] in
                    self?.backAction(UIButton())
                })
            }
        }
    }
    
}


