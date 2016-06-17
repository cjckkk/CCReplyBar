//
//  CCReplyBarView.m
//  ccReplyBar
//
//  Created by jason on 16/6/7.
//  Copyright © 2016年 jason. All rights reserved.
//

#import "CCReplyBarView.h"
#import "UIView+Extension.h"
#import "HWTextView.h"
#import "NSString+Tools.h"
@interface CCReplyBarView ()<UITextViewDelegate>

@property (nonatomic,weak) IBOutlet HWTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *likebtnWidth;
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@property (nonatomic,weak) UIView *superView;
@property (assign,nonatomic) CGFloat keyboradY;
@end
@implementation CCReplyBarView
//UIKIT_EXTERN NSString *const UIKeyboardWillShowNotification;
-(UITapGestureRecognizer *)tap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self.superView action:@selector(endEditing:)];
    }
    return _tap;
}
-(void)initWithSuperView:(UIView *)superView
{
        self.superView = superView;
        self.height = 49;
        self.width = CGRectGetWidth(superView.frame);
        self.x =0;
        self.y = CGRectGetHeight(superView.frame) - self.height;
    
//        LCLog(@"回复框---%@----%@",NSStringFromCGRect(self.frame),NSStringFromCGRect(superView.frame));

        [superView addSubview:self];
        //设置文字
        self.textView.placeholder = self.placeholder;
    
    if (!self.textView.placeholder.length) {
        self.textView.placeholder = @"说点什么";
    }
        self.textView.delegate = self;
    
    
    
    [self SetupUI];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.sendBtn addTarget:self  action:@selector(sendBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.likeBtn addTarget:self  action:@selector(likeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];


}

-(void)sendBtnTapped
{
    self.TappedSendblock?_TappedSendblock(self.textView.text):nil;
}
-(void)likeBtnTapped:(UIButton *)btn
{
    self.Tappedlikeblock?_Tappedlikeblock(btn):nil;
}
-(instancetype)loadWithSuperView:(UIView *)superView sendblock:(TappedSendBtn)sendblock likeblock:(TappedlikeBtn)likeblock
{
    CCReplyBarView *view =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    if(sendblock)
    view.TappedSendblock = sendblock;
    if (likeblock)
    view.Tappedlikeblock = likeblock;
    else
    {
        view.likebtnWidth.constant = 0;
        [view updateConstraintsIfNeeded];
    }
    [view performSelector:@selector(initWithSuperView:) withObject:superView afterDelay:0.3];
    return view;
}
#pragma mark --  textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textView becomeFirstResponder];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
    [self.superview endEditing:true];
    [self endEditing:true];
}

-(void)keyBoardWillShow:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    self.keyboradY = y;
    [UIView animateWithDuration:0.25 animations:^{
        self.y = y-self.height;
        
    }];
    //添加手势
    [self.superView addGestureRecognizer:self.tap];
}

-(void)keyBoardWillHide:(NSNotification *)noti
{
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    self.keyboradY = y;
    [UIView animateWithDuration:0.25 animations:^{
        self.y = y-self.height;
    }];
    
    [self.superView removeGestureRecognizer:self.tap];
}

-(void)textViewDidChange:(UITextView *)textView
{
    
//    NSLog(@"---%f-------%f----",self.width,textView.width);
    CGFloat padding = 8,maxheight = 200;
//    NSLog(@"textview contentsize  %@",NSStringFromCGSize(self.textView.contentSize));
    if (self.textView.contentSize.height <= 49-padding*2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.height =  49;
            self.y = self.keyboradY -self.height;

        }];
    }else if (fabsf(textView.height - self.textView.contentSize.height ) > 1.0f)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.height = self.textView.contentSize.height+padding*2;
            if (self.height >maxheight)
                self.height = maxheight;
            self.y = self.keyboradY- self.height;

        }];
    }

}
-(void)SetupUI
{
    [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_sendBtn setTitle:@"发表" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1] forState:UIControlStateNormal];
    
    [_sendBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    [_sendBtn.layer setMasksToBounds:YES];
    [_sendBtn.layer setCornerRadius:4.0]; //设置矩圆角半径
    
    
//    [_sendBtn.layer setBorderWidth:1.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[])
//                                        { 217/255.0, 217/255.0, 217/255.0, 1 });
//    [_sendBtn.layer setBorderColor:colorref];//边框颜色

    
    
    _textView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    _textView.tintColor = [UIColor blackColor];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    _textView.bounces = NO;
    _textView.contentInset = UIEdgeInsetsMake(-3, 0, -4, 0);
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    
  }
@end
