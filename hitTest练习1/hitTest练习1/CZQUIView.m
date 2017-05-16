//
//  CZQUIView.m
//  hitTest练习1
//
//  Created by 陈志强 on 16/9/14.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQUIView.h"

@interface CZQUIView ()
@property (nonatomic, weak) IBOutlet UIButton *btn;
@end

@implementation CZQUIView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    CGPoint btnP = [self convertPoint:point toView:self.btn];
    if ([self.btn hitTest:btnP withEvent:event]) {
        return self.btn;
    }else{
        
        return [super hitTest:point withEvent:event];
        
        }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s", __func__);
}

@end
