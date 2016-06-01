//
//  PKRTextFieldBox.m
//  EPark-Base
//
//  Created by charles_wtx on 16/5/19.
//  Copyright © 2016年 ecaray. All rights reserved.
//

#import "PKRTextFieldBox.h"

@interface PKRTextFieldBox ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIImageView *boxImgView;
@property (nonatomic,strong) NSMutableArray *labArray;
@property (nonatomic,strong) NSMutableArray *inputStrArray;
@property (nonatomic,strong) NSMutableArray *starArray;
@property (nonatomic,assign) NSUInteger starLocation;

@end

@implementation PKRTextFieldBox

- (NSMutableArray *)labArray
{
    if (!_labArray)
    {
        _labArray = [NSMutableArray new];
    }
    return _labArray;
}

- (NSMutableArray *)inputStrArray
{
    if (!_inputStrArray)
    {
        _inputStrArray = [NSMutableArray new];
    }
    return _inputStrArray;
}

- (NSMutableArray *)starArray
{
    if (!_starArray)
    {
        _starArray = [NSMutableArray new];
    }
    return _starArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.boxNum = 6;
        self.starLocation = 0;
        
        self.boxImgView = [[UIImageView alloc]init];
        self.boxImgView.image = [UIImage imageNamed:@"parking_gop_code6"];
        if (self.boxImgName.length > 0)
        {
            self.boxImgView.image = [UIImage imageNamed:self.boxImgName];
        }
        
        [self addSubview:self.boxImgView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.boxNum = 6;
        self.starLocation = 0;
        
        self.boxImgView = [[UIImageView alloc]init];
        self.boxImgView.image = [UIImage imageNamed:@"parking_gop_code6"];
        if (self.boxImgName.length > 0)
        {
            self.boxImgView.image = [UIImage imageNamed:self.boxImgName];
        }
        
        [self addSubview:self.boxImgView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.boxImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self setUpUI];
}

- (void)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
}

- (void)setUpUI
{
    self.textField = [[UITextField alloc]initWithFrame:self.boxImgView.bounds];
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.textField.textColor = [UIColor clearColor];
    self.textField.tintColor = [UIColor clearColor];
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [self addSubview:self.textField];
    
    for (int i = 0; i < self.boxNum; i++)
    {
        CGFloat labWidth = self.frame.size.width/self.boxNum;
        CGFloat labHeight = self.frame.size.height;
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(i*labWidth, 0, labWidth, labHeight)];
        lab.textColor = CELLTITLECOLOR;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:22];
        lab.backgroundColor = [UIColor clearColor];
        [self.textField addSubview:lab];
        
        //光标
        UIView *starView = [[UIView alloc]initWithFrame:CGRectMake(labWidth/2-3/2, 10, 3, labHeight-20)];
        starView.backgroundColor = NAVIGATIONBARCOLOR;
        [starView.layer addAnimation:[self opacityForever_Animation:0.5] forKey:@"opacity"];
        starView.hidden = YES;
        [lab addSubview:starView];
        
        [self.labArray addObject:lab];
        [self.starArray addObject:starView];

    }

}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    for (int i = 0 ;i < self.starArray.count;i++)
    {
        UIView *starView = [self.starArray objectAtIndex:i];
        if (i == self.starLocation&&(self.starLocation < self.boxNum-1))
        {
            starView.hidden = NO;
        }
        else
        {
            starView.hidden = YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    for (int i = 0 ;i < self.starArray.count;i++)
    {
        UIView *starView = [self.starArray objectAtIndex:i];
        starView.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //大写
    string = string.uppercaseString;
    
    NSString *inputStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (inputStr.length > self.boxNum)
    {
        return NO;
    }
    
    if (![string isStringTypeOf:kAlphaNum])
    {
        return NO;
    }
    
    if (![string isEqualToString:@""])
    {
        if (self.inputStrArray.count < 6)
        {
          [self.inputStrArray addObject:string];
        }
        else
        {
            [self.inputStrArray replaceObjectAtIndex:self.inputStrArray.count-1 withObject:string];
        }
        
        NSUInteger index = self.inputStrArray.count - 1;
        
        if (index<=0) {
            index = 0;
        }
        
        if (index < self.labArray.count)
        {
            UILabel *lab = [self.labArray objectAtIndex:index];
            lab.text = string;
            
            UIView *lastView = [self.starArray objectAtIndex:index];
            lastView.hidden = YES;
        }
        
        if (index+1<self.starArray.count)
        {
            UIView *currentView = [self.starArray objectAtIndex:index+1];
            currentView.hidden = NO;
            self.starLocation = index+1;
        }
        
    }
    else
    {
        if (self.inputStrArray.count == 0)
        {
            return NO;
        }
        
        //后退
        NSUInteger index = self.inputStrArray.count - 1;
        if (index<=0) {
            index = 0;
        }
        UILabel *lab = [self.labArray objectAtIndex:index];
        lab.text = @"";
        
        if (index < self.starArray.count)
        {
            UIView *currentView = [self.starArray objectAtIndex:index];
            currentView.hidden = NO;
            self.starLocation = index;
        }
        
        if (index+1<self.starArray.count)
        {
            UIView *lastView = [self.starArray objectAtIndex:index+1];
            lastView.hidden = YES;
        }
        
        if (self.inputStrArray==0)
        {
            UIView *lastView = [self.starArray objectAtIndex:0];
            lastView.hidden = YES;
        }
        
        [self.inputStrArray removeLastObject];
    }
    
    textField.text = inputStr;
 
    if ([self.delegate respondsToSelector:@selector(getInputString:)])
    {
        [self.delegate getInputString:inputStr];
    }
    
    return NO;
}

#pragma mark === 永久闪烁的动画 ======

- (CABasicAnimation *)opacityForever_Animation:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
