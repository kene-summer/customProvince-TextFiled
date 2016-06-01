//
//  PKRTextFieldBox.h
//  EPark-Base
//
//  Created by charles_wtx on 16/5/19.
//  Copyright © 2016年 ecaray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKRTextFieldBoxDelegate <NSObject>

- (void)getInputString:(NSString *)inputStr;

@end

@interface PKRTextFieldBox : UIView

@property (nonatomic,strong) NSString *boxImgName;
@property (nonatomic,assign) NSUInteger boxNum;//格子数
@property (nonatomic,assign) id<PKRTextFieldBoxDelegate>delegate;

- (void)becomeFirstResponder;

@end
