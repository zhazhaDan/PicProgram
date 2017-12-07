//
//  TestViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/24.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import AVFoundation

class TestViewController: BaseViewController,AVCaptureMetadataOutputObjectsDelegate {
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?

//    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        // 初始化视频预览 layer，并将其作为 viewPreview 的 sublayer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = (self.view.layer.bounds)
        self.view.layer.insertSublayer(videoPreviewLayer!, at: 0)
        
        captureSession?.startRunning()
    }
  
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == tableView {
//            if tableView.contentOffset.y <= 0 {
//                scrollView
//            }
//        }
//    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isMember(of: UIScrollView.self) {
            print("scrollview 在滚动")
        }else if scrollView.isMember(of: UITableView.self) {
            print("tableview 在滚动")
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.size.height {
                self.scrollView?.becomeFirstResponder()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    

}
