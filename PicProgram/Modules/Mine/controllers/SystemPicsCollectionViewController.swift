//
//  SystemPicsCollectionViewController.swift
//  PicProgram
//
//  Created by 龚丹丹 on 2017/11/21.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

private let reuseIdentifier = "Cell"

class SystemPicsCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var dataSource:[PHAsset]!
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                return
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    func getOriginalImages() {
        let assetCollections:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
//        for asset in assetCollections {
//
//        }
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
    }
    
    func enumerateAssetCollection(assetCollection:PHAssetCollection,original:Bool) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection, options: nil)
        for i in 0 ..< assets.count {
            let asset = assets.object(at: i)
            let size = (original == true ? CGSize.init(width: asset.pixelWidth, height: asset.pixelHeight): CGSize.zero)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: options, resultHandler: { (image, result) in
                
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (SCREEN_WIDTH - 20)/3, height: (SCREEN_WIDTH - 20)/3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
