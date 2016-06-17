//
//  CCReplyBarView.h
//  ccReplyBar
//
//  Created by jason on 16/6/7.
//  Copyright © 2016年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TappedSendBtn)(NSString *obj);
typedef void (^TappedlikeBtn)(UIButton *obj);


@interface CCReplyBarView : UIView
@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic, copy) TappedSendBtn TappedSendblock;
@property (nonatomic, copy) TappedlikeBtn Tappedlikeblock;
@property (nonatomic,weak) IBOutlet UIButton *sendBtn;
@property (nonatomic,weak) IBOutlet UIButton *likeBtn;
-(instancetype)loadWithSuperView:(UIView *)superView sendblock:(TappedSendBtn)sendblock likeblock:(TappedlikeBtn)likeblock;

@end
