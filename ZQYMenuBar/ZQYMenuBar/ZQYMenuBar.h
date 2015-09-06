//
//  ZQYMenuBar.h
//  ZQYMenuBar
//
//  Created by zqybin on 15/8/29.
//  Copyright (c) 2015年 zqybin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZQYMenuBarDelegate;

@interface ZQYMenuBar : UIView

/**
 *  delegate
 */
@property (nonatomic, assign) id <ZQYMenuBarDelegate> delegate;

///**
// *  类方法实例化，需要设置frame，titles
// */
//+ (instancetype)menuBar;

/**
 *  MenuBar初始化方法，通过标题来初始化，适用于控件初始化时拿到数据源
 *
 *  @param frame MenuBar的frame
 *
 *  @param titles 标题
 *
 *  @return 实例对象
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

/**
 *  标题数组
 */
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIColor *menuBarBackgroundColor;      //设置全部背景色

//@property (nonatomic, strong) UIColor *topSeparateLineColor;        //上分割线颜色，default lightGrayColor
@property (nonatomic, strong) UIColor *bottomSeparateLineColor;     //下分割线颜色，default lightGrayColor

@property (nonatomic, strong) UIColor *scrollBackgroundColor;       //滑动视图的背景色，default whiteColor
@property (nonatomic, strong) UIColor *listBackgroundColor;         //列表视图的背景色，default whiteColor

@property (nonatomic, strong) UIFont *scrollTitleFont;              //滑动视图的标题字体，default font 17
@property (nonatomic, strong) UIColor *scrollTitleColor;            //滑动视图的标题颜色，default blackColor
@property (nonatomic, strong) UIColor *scrollSelectedTitleColor;    //滑动视图的选中的标题颜色，default blueColor

@property (nonatomic, strong) UIFont *listTitleFont;                //列表视图的标题字体，default font 17
@property (nonatomic, strong) UIColor *listTitleColor;              //列表视图的标题颜色，default blackColor
@property (nonatomic, strong) UIColor *listSelectedTitleColor;      //列表视图的选中的标题颜色，default blueColor

@property (nonatomic, strong) UIColor *promptColor;                 //提示条的颜色，default redColor

@property (nonatomic, strong) UIImage *dropDownImage;               //下拉按钮的图片

@property (nonatomic, strong) UIImage *dropDownSelectedImage;       //已下拉按钮的图片

@end

@protocol ZQYMenuBarDelegate <NSObject>

@optional

/**
 *  MenuBar代理方法，点击相应的按钮对应的索引
 *
 *  @param menuBar MenuBar
 *
 *  @param index 索引
 */
- (void)menuBar:(ZQYMenuBar *)menuBar didSelectButtonIndex:(NSInteger)index;

@end

