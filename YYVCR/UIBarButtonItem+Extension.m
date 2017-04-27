//
//  UIBarButtonItem+Extension.m
//  Yoo
//
//  Created by Heisenbean on 15/1/23.
//  Copyright (c) 2015年 北京微星辰科技有限公司. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)itemWithBgImage:(UIImage *)bgImage
                    highBgImage:(UIImage *)highBgImage
                    target:(id)target
               imageInsets:(UIEdgeInsets)insets
                    action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:bgImage forState:UIControlStateNormal];
    [button setImage:highBgImage forState:UIControlStateHighlighted];
    button.imageEdgeInsets = insets;
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithBgImage:(UIImage *)bgImage
                    selectBgImage:(UIImage *)selectBgImage
                    target:(id)target
               imageInsets:(UIEdgeInsets)insets
                    action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:bgImage forState:UIControlStateNormal];
    [button setImage:selectBgImage forState:UIControlStateSelected];
    button.imageEdgeInsets = insets;
    [button sizeToFit];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:button];
}



+ (instancetype)itemWithImage:(UIImage *)buttonImage
                  buttonTitle:(NSString *)title
                  buttonFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}



+ (instancetype)itemWithButtonTitle:(NSString *)title buttonColor:(UIColor *)color target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont fontWithName:QTCommonFontName size:16]];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];

}

+ (instancetype)itemWithButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont fontWithName:QTCommonFontName size:16]];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    button.frame = CGRectMake(0, 0, 50, 30);
    button.layer.cornerRadius = 15;
    [button clipsToBounds];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
    
}

+ (instancetype)getMoreItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"interface_icon_more_white"] forState:UIControlStateNormal];
    button.frame = CGRectMake(-20, 0, 30, 30);
//    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (instancetype)getShareItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-20, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"interface_icon_share_white"] forState:UIControlStateNormal];
//        [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (instancetype)getEditItemWithTarget:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-20, 0, 30, 30);
    [button setImage:[UIImage imageNamed:@"template_button_edit_white"] forState:UIControlStateNormal];
//        [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}

+ (instancetype)getEmptyItem{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 22, 44);
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end
