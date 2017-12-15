//
//  GDPhotoTool.swift
//  PhotoSelector
//
//  Created by 龚丹丹 on 17/1/5.
//  Copyright © 2017年 龚丹丹. All rights reserved.
//

import Foundation
import Photos
class GDPhotoTool: NSObject,PHPhotoLibraryChangeObserver {
    var imageManager:PHImageManager!;

    static let defaultTool = GDPhotoTool();
//    class var defaultTool: GDPhotoTool {
//        struct Singleton {
//            static let instance = GDPhotoTool();
//        }
//        return Singleton.instance;
//    }
    
    func authorize(_ status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus(), completion: @escaping (_ authorized: Bool) -> Void) {
        switch status {
        case .authorized:
            //授权成功
            completion(true)
        case .notDetermined:
            //没有申请过权限，开始申请权限
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async(execute: { 
                    self.authorize(status, completion: completion)
                })
            })
        default:()
        //访问相册呗拒绝，提醒用户去设置授权
            DispatchQueue.main.async(execute: { 
                completion(false)
            })
            
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    func getAllAlbums() -> Array<Any>{
        authorize { (ret) in
            if !ret {
                let alert = UIAlertView.init(title: "权限未开启", message: "请前往设置开启访问相册权限", delegate: self, cancelButtonTitle: "好的")
                alert.show()
            }else {
                PHPhotoLibrary.shared().register(self)
            }
        }
        var datasource:Array<Any> = [];
        let fetchOption = PHFetchOptions.init();
        let smartAlbumsFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: fetchOption);
        let tmpAsset = smartAlbumsFetchResult.firstObject;
        if ((tmpAsset != nil) && (tmpAsset?.estimatedAssetCount)! > 0) {
            datasource.append(tmpAsset!);
        }
        let topLevelAlbumsFetchResult = PHAssetCollection.fetchTopLevelUserCollections(with: fetchOption);
        for i in 0..<topLevelAlbumsFetchResult.count {
            datasource.append(topLevelAlbumsFetchResult[i]);
        }
        return datasource;
    }
    
    public func getFetchResultInAlbums(assetCollection:PHAssetCollection) -> PHFetchResult<AnyObject> {
        return PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>;
    }
    
    
    public func getAllPhotos(fetchResult: PHFetchResult<AnyObject>) -> Array<Any> {
        var array = Array<Any>();
        for i in 0..<fetchResult.count {
            let asset = fetchResult[i] as! PHAsset;
            if asset.mediaSubtypes.rawValue > 0 {
                let gdAsset = GDPHAsset.init()
                gdAsset.asset = asset
                gdAsset.isSelected = false
                array.append(gdAsset);
            }
        }
        return array;
    }
    
    public func getImage(asset:PHAsset,imageSize:CGSize,complete:@escaping ((UIImage,Bool)->()))  {
        if self.imageManager == nil {
            self.imageManager = PHImageManager.init();
        }
        self.imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: PHImageContentMode.aspectFit, options: PHImageRequestOptions(), resultHandler: { (result, info) in
            if (result != nil) {
                complete(result!,true);
            }
            complete(result!,false);
        });
    }

}


