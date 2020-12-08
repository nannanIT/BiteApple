//
//  BAAlbum.m
//  BiteApple
//
//  Created by jayhuan on 2020/11/30.
//

#import "BAAlbum.h"
#import <Photos/PHAsset.h>

/**
 1、PHAsset：
 PHAsset fetchAssetsInAssetCollection
 返回PHAsset的数组
 
 2、PHAssetCollection：
 PHAssetCollection fetchAssetCollectionsWithType
 返回PHAssetCollection的数组
 
 PHFetchResult<PHAssetCollection *> *myPhotoStreamAlbum =
         [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                  subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream
                                                  options:nil];
 
 3、PHImageManager
 [PHImageManager defaultManager] requestImageForAsset
 Request an image representation for the specified asset.
 根据assert获取image，返回UIImage类型的result
 
 4、PHPhotoLibrary
 相册权限相关的
 
 5、PHFetchResult
 类似数组，保存相关结果
 PHFetchResult<PHAsset *>
 PHFetchResult<PHAssetCollection *>等
 
 6、PHFetchOptions
 选项配置
 PHFetchOptions *option = [[PHFetchOptions alloc] init];
 option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %@", @(PHAssetMediaTypeVideo)];
 
 7、PHPickerViewController
 iOS14以后新API
 PHPickerConfiguration
 PHPickerFilter
 8、UIImagePickerController
 老的API
 
 9、PHPickerResult
 (1)itemProvider
 itemProvider loadObjectOfClass
 
 (2) assetIdentifier
 PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
 
 
 https://www.jianshu.com/p/989675debaf1
 */

@implementation BAAlbum

+ (void)mediaAuthorizationStatusAuthorized {
    PHAuthorizationStatus status = [self mediaAuthorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
            } else {
                
            }
        }];
    } else {
        if (status == PHAuthorizationStatusAuthorized) {
            
        } else {
            
        }
    }
}

+ (PHAuthorizationStatus)mediaAuthorizationStatus {
    return [PHPhotoLibrary authorizationStatus];
}

@end
