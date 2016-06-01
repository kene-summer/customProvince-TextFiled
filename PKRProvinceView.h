//
//  PKRProvinceView.h
//  EPark-Base
//
//  Created by charles_wtx on 16/5/5.
//  Copyright © 2016年 ecaray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PKRProvinceView : UIView

- (NSString *)getCurrentProvinceToProvinceShort:(NSString *)currectProvince;
- (void)showInView:(UIView *)view;
- (void)hideViewIsLeftClick:(BOOL)isLeftClick;

@property (nonatomic,strong) void (^selectProvince)(NSString *province);
@property (nonatomic,strong) void (^deleProvice)(void);
@property (nonatomic,strong) void (^hideViewBlock)(void);

@end
