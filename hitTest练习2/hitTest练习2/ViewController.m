//
//  ViewController.m
//  hitTest练习2
//
//  Created by 陈志强 on 16/9/14.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "ViewController.h"
#import "CZQChatBtn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(CZQChatBtn *)sender {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"对话框"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"小孩"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(100, -80, 100, 80);
    sender.popBtn = btn;
    [sender addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
