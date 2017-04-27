//
//  UIBarButtonItem+Extension.h
//  Yoo
//
//  Created by Heisenbean on 15/1/23.
//  Copyright (c) 2015年 北京微星辰科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/**
 *  通过一个按钮创建一个UIBarButtonItem
 *
 *  @param bg     背景图片
 *  @param highBg 高亮背景图片
 *  @param target 谁来监听按钮点击
 *  @param action 点击按钮会调用的方法
 */
+ (instancetype)itemWithBgImage:(UIImage *)bgImage
                    highBgImage:(UIImage *)highBgImage
                         target:(id)target
                    imageInsets:(UIEdgeInsets)insets
                         action:(SEL)action;

/**
 *  通过一个按钮创建一个选中UIBarButtonItem
 *
 *  @param bg     背景图片
 *  @param highBg 高亮背景图片
 *  @param target 谁来监听按钮点击
 *  @param action 点击按钮会调用的方法
 */

+ (instancetype)itemWithBgImage:(UIImage *)bgImage
                  selectBgImage:(UIImage *)selectBgImage
                         target:(id)target
                    imageInsets:(UIEdgeInsets)insets
                         action:(SEL)action;



/**
 *  通过一个按钮创建一个UIBarButtonItem
 *
 *  @param buttonImage 按钮图片名
 *  @param title       按钮标题
 *  @param frame       按钮frame
 *
 *  @return 一个UIBarButtonItem
 */
+ (instancetype)itemWithImage:(UIImage *)buttonImage
                  buttonTitle:(NSString *)title
                  buttonFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action;

/**
 *  创建只有title的BarButton
 *  @param color  标题颜色
 *  @param title  标题
 *  @param target 目标
 *  @param action 动作
 * */
+ (instancetype)itemWithButtonTitle:(NSString *)title buttonColor:(UIColor *)color target:(id)target action:(SEL)action;




//+ (instancetype)itemWithButtonImage:(UIImage *)image
//                        selectImage:(UIImage *)selectImage
//                             target:(id)target
//                             action:(SEL)action;

+(instancetype)getMoreItemWithTarget:(id)target action:(SEL)action;

+ (instancetype)getShareItemWithTarget:(id)target action:(SEL)action;

+ (instancetype)getEditItemWithTarget:(id)target action:(SEL)action;

+ (instancetype)itemWithButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action;
@end
