//
//  UIImage+Utils.h
//  YYVCR
//
//  Created by Heisenbean on 2017/5/5.
//  Copyright © 2017年 Heisenbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface UIImage (Utils)

/**
 @param size imageSize
 @return A placeholderImage
 */
+ (UIImage *)placeholderImageWithSize:(CGSize)size;


/**
 Asynchronous get 3 highquality images array from assetsLibrary
 */
+ (void)getThumbInailFromAssetsLibrary:(void (^)(NSArray<UIImage *> *))callback;
@end
