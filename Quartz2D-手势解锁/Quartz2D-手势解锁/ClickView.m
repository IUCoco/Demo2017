//
//  ClickView.m
//  Quartz2D-手势解锁
//
//  Created by 陈志强 on 16/9/20.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "ClickView.h"

@interface ClickView ()

@property(nonatomic, strong)NSMutableArray *selectedBtnArrM;
@property(nonatomic, assign)CGPoint curP;

@end

@implementation ClickView

//selectedBtnArrM懒加载
- (NSMutableArray *)selectedBtnArrM{
    if (!_selectedBtnArrM) {
        _selectedBtnArrM = [NSMutableArray array];
    }
    return _selectedBtnArrM;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    //搭建界面添加按钮
    [self setUp];
}

//搭建界面添加按钮
- (void) setUp{
    for (int i = 0; i < 9; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        //不让按钮接收事件，让其父控件处理也是就是ClickView否则touchBegin方法不能被调用
        btn.userInteractionEnabled = NO;
        //设置按钮不同状态下的图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        [self addSubview:btn];
    }
}

//抽取方法
  //获取当前手指所在的点
- (CGPoint)currentPount:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    return  [touch locationInView:self];
}
//给定一个点，判断这个点在不在按钮身上，如果在返回该按钮，取得该按钮后可以执行自己特殊操作，如果不在返回nil
- (UIButton *)btnContaintsPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        //        Returns whether a rectangle contains a specified point.
        //        A point is considered inside the rectangle if its coordinates lie inside the rectangle or on the minimum X or minimum Y edge.
        if (CGRectContainsPoint(btn.frame, point)) {
            //让当前按钮为选中状态
//            btn.selected = YES;
            return btn;
        }
    }
       return nil;
}

#pragma mark - delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断当前的手指在不在按钮上，如果在让按钮处于选中状态
    //获取当前手指所在的点
//    UITouch *touch = [touches anyObject];
//    CGPoint curP = [touch locationInView:self];
    CGPoint curP = [self currentPount:touches];
    self.curP = curP;
    //判断curP在不在按钮身上
//    for (UIButton *btn in self.subviews) {
////        Returns whether a rectangle contains a specified point.
////        A point is considered inside the rectangle if its coordinates lie inside the rectangle or on the minimum X or minimum Y edge.
//        if (CGRectContainsPoint(btn.frame, curP)) {
//            //让当前按钮为选中状态
//            btn.selected = YES;
//        }
//    }
    UIButton *btn = [self btnContaintsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        //添加到选中按钮数组
        [self.selectedBtnArrM addObject:btn];
        //重绘调用drawRect方法
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断当前的手指在不在按钮上，如果在让按钮处于选中状态
    //获取当前手指所在的点
//    UITouch *touch = [touches anyObject];
//    CGPoint curP = [touch locationInView:self];
    CGPoint curP = [self currentPount:touches];
    self.curP = curP;
    //判断curP在不在按钮身上
//    for (UIButton *btn in self.subviews) {
//        //        Returns whether a rectangle contains a specified point.
//        //        A point is considered inside the rectangle if its coordinates lie inside the rectangle or on the minimum X or minimum Y edge.
//        if (CGRectContainsPoint(btn.frame, curP)) {
//            //让当前按钮为选中状态
//            btn.selected = YES;
//        }
//    }
    UIButton *btn = [self btnContaintsPoint:curP];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        //添加到选中按钮数组
        [self.selectedBtnArrM addObject:btn];
    }
    //一移动就开始绘制
    //重绘调用drawRect方法
    [self setNeedsDisplay];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //取消所选中的按钮
    NSMutableString *str = [NSMutableString string];
    for (UIButton *btn in self.selectedBtnArrM) {
        btn.selected = NO;
        [str appendFormat:@"%ld", btn.tag];
    }
    //清空路径
    [self.selectedBtnArrM removeAllObjects];
    [self setNeedsDisplay];
    //查看当前按钮选择顺序
    NSLog(@"%@", str);
    
}



-(void)drawRect:(CGRect)rect{
    
    if (self.selectedBtnArrM.count) {
        //开启路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        //取出所有选中的按钮
        for (int i = 0; i < self.selectedBtnArrM.count; i ++) {
            UIButton *btn = self.selectedBtnArrM[i];
            //判断当前按钮是不是第一个按钮
            if (i == 0) {
                [path moveToPoint:btn.center];
            }else{
                //添加一根线到按钮中心
                [path addLineToPoint:btn.center];
            }
        }
        
        //添加一根线到当前所在的点
        [path addLineToPoint:self.curP];
        
        path.lineCapStyle = kCGLineCapRound;
        path.lineJoinStyle = kCGLineJoinRound;
        path.lineWidth = 10;
        [[UIColor orangeColor]setStroke];
        //绘制路径
        [path stroke];
    }
}

//设置子控件位置九宫格
- (void)layoutSubviews{
    [super layoutSubviews];
    //取出每一个按钮设置frame
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    //设置按钮之间的间距
     //总共三列
    int column = 3;
    CGFloat margin = (self.frame.size.width - btnWH * 3) / (column + 1);
    int curCol = 0;
    int curRoe = 0;
    
    for (int i = 0; i < self.subviews.count; i ++) {
        //当前所在的列
        curCol = i % column;
        //当前所在的行
        curRoe = i /column;
        x = margin + (btnWH + margin) * curCol;
        y = margin + (btnWH + margin) * curRoe;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}

@end
