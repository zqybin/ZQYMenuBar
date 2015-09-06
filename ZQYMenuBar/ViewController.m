//
//  ViewController.m
//  ZQYMenuBar
//
//  Created by zqybin on 15/8/29.
//  Copyright (c) 2015年 zqybin. All rights reserved.
//

#import "ViewController.h"
#import "ZQYMenuBar.h"

@interface ViewController () <ZQYMenuBarDelegate>
{
    NSArray *array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ZQYMenuBar";
    
    //设置frame
    CGRect frame = CGRectMake(0, 64.0f, self.view.frame.size.width, 44.0f);
    //设置标题
    array = @[@"全部", @"互联网", @"传媒", @"汽车", @"娱乐", @"军事", @"财经", @"体育", @"国内", @"社会", @"科技", @"国际", @"女人", @"房产", @"游戏", @"视频", @"名站"];
    //ZQYMenuBar实例并初始化
    ZQYMenuBar *menuBar = [[ZQYMenuBar alloc] initWithFrame:frame titles:array];
    //设置代理
    menuBar.delegate = self;
    //设置滚动标题的背景色
    menuBar.scrollBackgroundColor = [UIColor whiteColor];
    //设置列表试图的背景色
    menuBar.listBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    //设置滚动标题的颜色
    menuBar.scrollTitleColor = [UIColor grayColor];
    //设置滚动标题被选中的颜色
    menuBar.scrollSelectedTitleColor = [UIColor redColor];
    //设置滚动标题的字体
    menuBar.scrollTitleFont = [UIFont systemFontOfSize:20];
    //设置列表标题的颜色
    menuBar.listTitleColor = [UIColor whiteColor];
    //设置列表标题被选中的颜色
    menuBar.listSelectedTitleColor = [UIColor redColor];
    //下拉按钮的图片
    menuBar.dropDownImage = [UIImage imageNamed:@"n_dropdown"];
    //下拉按钮选中时的图片
    menuBar.dropDownSelectedImage = [UIImage imageNamed:@"dropdown"];
    menuBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuBar];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, CGRectGetMaxY(menuBar.frame), self.view.frame.size.width, self.view.frame.size.height - 108);
    imageView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZQYMenuBarDelegate

- (void)menuBar:(ZQYMenuBar *)menuBar didSelectButtonIndex:(NSInteger)index
{
    NSLog(@"选择的菜单：%@", array[index]);
}

@end
