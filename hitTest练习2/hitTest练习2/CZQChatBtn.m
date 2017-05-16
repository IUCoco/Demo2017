//
//  CZQChatBtn.m
//  hitTest练习2
//
//  Created by 陈志强 on 16/9/14.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQChatBtn.h"

@implementation CZQChatBtn


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //判断当前的popBtn是否有值
    if (self.popBtn) {
        
        CGPoint btnP = [self convertPoint:point toView:self.popBtn];
        //判断点在不在popBtn上面
        if ([self pointInside:btnP withEvent:event]) {
            return self.popBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
        
    }else{
        return [super hitTest:point withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取touch对象
    UITouch *touch = [touches anyObject];
    //获取当前手指的点和下一个手指的点
    CGPoint curP = [touch locationInView:self];
    CGPoint preP = [touch previousLocationInView:self];
    //计算偏移量
    CGFloat conOfSetX = curP.x - preP.x;
    CGFloat conOfSetY = curP.y - preP.y;
    //平移
    self.transform = CGAffineTransformTranslate(self.transform, conOfSetX, conOfSetY);
}

@end
