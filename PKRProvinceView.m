//
//  PKRProvinceView.m
//  EPark-Base
//
//  Created by charles_wtx on 16/5/5.
//  Copyright © 2016年 ecaray. All rights reserved.
//
#define kBtnTag  10000
#define h        (215)

#import "PKRProvinceView.h"

@interface PKRProvinceView ()

@property (nonatomic,strong) UIView *SNView;
@property (nonatomic,strong) NSArray *provinceShorts;
@property (nonatomic,strong) NSArray *currentCitys;
@property (nonatomic,strong) UIView  *view;
@property (nonatomic,assign) CGRect  viewOldFrame;
@property (nonatomic,strong) UIView *alphaView;
@property (nonatomic,strong) NSString *defaultProvinceShort;
@property (nonatomic,strong) NSMutableArray *btnArray;

@end

@implementation PKRProvinceView
{
    BOOL isSNViewShow;
}

- (NSArray *)currentCitys
{
    if (!_currentCitys) {
        _currentCitys = @[
        @"北京",@"上海",@"浙江",@"苏州",@"广东",@"山东",@"山西",@"河北",@"河南",
        @"四川",@"重庆",@"辽宁",@"吉林",@"黑龙江",@"安徽",@"湖北",@"湖南",@"江西",
        @"空",@"福建",@"陕西",@"甘肃",@"宁夏",@"内蒙古",@"天津",@"贵州",@"空",
                @"云南",@"广西",@"海南",@"青海",@"新疆",@"西藏"
                        ];
    }
    
    return _currentCitys;
}

- (NSArray *)provinceShorts
{
    if (!_provinceShorts)
    {
        _provinceShorts = @[
                    @"京",@"沪",@"浙",@"苏",@"粤",@"鲁",@"晋",@"冀",@"豫",
                    @"川",@"渝",@"辽",@"吉",@"黑",@"皖",@"鄂",@"湘",@"赣",
                    @"空",@"闽",@"陕",@"甘",@"宁",@"蒙",@"津",@"贵",@"空",
                            @"云",@"桂",@"琼",@"青",@"新",@"藏"
                    ];
    }
    return _provinceShorts;
}

- (NSString *)getCurrentProvinceToProvinceShort:(NSString *)currectProvince
{
    NSUInteger index = [self.currentCitys indexOfObject:currectProvince];
    if (index > self.provinceShorts.count)
    {
        return nil;
    }
    
    NSString *provinceShort = [self.provinceShorts objectAtIndex:index];
    self.defaultProvinceShort = provinceShort;
    return provinceShort;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray)
    {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (UIView *)alphaView
{
    if (!_alphaView)
    {
        _alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        _alphaView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [_alphaView addGestureRecognizer:tap];
    }
    
    return _alphaView;
}

- (void)tapClick
{
    [self hideViewIsLeftClick:NO];
}

- (void)showInView:(UIView *)view
{
    self.view = view;
    self.viewOldFrame = view.frame;
    
    self.frame = CGRectMake(0, SCREENHEIGHT-h, SCREENWIDTH, h);
    [[UIApplication sharedApplication].keyWindow addSubview:self.alphaView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (!_SNView)
    {
        _SNView = [[UIView alloc]initWithFrame:CGRectMake(0, h, self.frame.size.width, h)];
        _SNView.backgroundColor = [UIColor colorWithRed:(205/255.0) green:(207/255.0) blue:(211/255.0) alpha:1];
        
        float d1 = 7;  //左右间隔
        float d2 = 12; //上下间隔
        float width = (self.frame.size.width - d1*10)/9 ; //按钮宽
        float heigth = 40;
        
        for (int i = 0; i< self.provinceShorts.count; i++)
        {
            NSString *title = [self.provinceShorts objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (i/9==3)
            {
                CGFloat x = self.width/2-(width*6+d1*7)/2;
               btn.frame = CGRectMake(d1 + (i%9)*(width+d1)+x, d2 + (i/9)*(heigth+d2), width, heigth);
            }
            else
            {
                btn.frame = CGRectMake(d1 + (i%9)*(width+d1), d2 + (i/9)*(heigth+d2), width, heigth);
            }
            
            if ([title isEqualToString:@"空"])
            {
                [btn setTitle:@"" forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor clearColor];
                btn.userInteractionEnabled = NO;
            }
            else
            {
                [btn setTitle:title forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
                btn.userInteractionEnabled = YES;
            }
            
            btn.tag = kBtnTag + i;
            btn.layer.cornerRadius = 5.0 ;
            btn.titleLabel.font = [UIFont systemFontOfSize:17.0];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_SNView addSubview:btn];
            
            [self.btnArray addObject:btn];
        }
        
        [self addSubview:_SNView];
        
        //default isfirst 选择btn
        if (self.defaultProvinceShort&&self.btnArray.count>0)
        {
            NSUInteger index = [self.provinceShorts indexOfObject:self.defaultProvinceShort];
            for (UIButton *button in self.btnArray)
            {
                if ([button.titleLabel.text isEqualToString:@""]||button.titleLabel.text.length==0)
                {
                    button.backgroundColor = [UIColor clearColor];
                }
                else
                {
                    button.backgroundColor = [UIColor whiteColor];
                }
            }
            
            UIButton *selectBtn = self.btnArray[index];
            selectBtn.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    if (!isSNViewShow)
    {
        [self.superview endEditing:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            if (255/(view.height-64) >= 0.55)
            {
                view.frame = CGRectMake(0, 0-abs(h-255)-45, SCREENWIDTH, SCREENHEIGHT);
            }
            
            self.SNView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }];
        isSNViewShow = YES;
    }
}

- (void)btnClick:(UIButton *)sender
{
    UIButton *btn = sender;
    
    int i = (int)btn.tag - kBtnTag;
    if (i < self.provinceShorts.count)
    {
        NSString *title = [self.provinceShorts objectAtIndex:i];
        
        for (UIButton *button in self.btnArray)
        {
            if ([button.titleLabel.text isEqualToString:@""]||button.titleLabel.text.length==0)
            {
                button.backgroundColor = [UIColor clearColor];
            }
            else
            {
                button.backgroundColor = [UIColor whiteColor];
            }
        }
        
        UIButton *selectBtn = self.btnArray[i];
        selectBtn.backgroundColor = [UIColor lightGrayColor];
        
        if (self.selectProvince)
        {
            self.selectProvince(title);
        }
        
        [self hideViewIsLeftClick:NO];
    }
}

- (void)hideViewIsLeftClick:(BOOL)isLeftClick
{
    if (isSNViewShow)
    {
        isSNViewShow = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = self.viewOldFrame;
            self.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, h);
            
            self.SNView.frame = CGRectMake(0, h, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            [self.alphaView removeFromSuperview];
            [self removeFromSuperview];
        }];
        
        if (!isLeftClick)
        {
            if (self.hideViewBlock)
            {
                self.hideViewBlock();
            }
        }
        
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
