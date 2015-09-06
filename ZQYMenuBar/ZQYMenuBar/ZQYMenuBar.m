//
//  ZQYMenuBar.m
//  ZQYMenuBar
//
//  Created by zqybin on 15/8/29.
//  Copyright (c) 2015年 zqybin. All rights reserved.
//

#import "ZQYMenuBar.h"

#define kDropDownButtonWith self.bounds.size.height
#define kScrollButtonInterval 15.0f

@interface ZQYMenuBar ()
{
    //下拉视图的高度
    CGFloat listViewHeight;
    
    //scrollView在mainScreen的坐标系
    CGRect windowRect;
    
    //屏幕缩放比例
    CGFloat scale;
}

//标题视图
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *backgroundView;

//下拉视图
@property (nonatomic, strong) UIView *listView;

//下拉按钮
@property (nonatomic, weak) UIButton *dropDownBtn;

//提示视图
@property (nonatomic, weak) UIView *promptView;

//上部分割线
@property (nonatomic, weak) UIView *topSeparateLine;

//底部分割线
@property (nonatomic, weak) UIView *bottomSeparateLine;


@end

@implementation ZQYMenuBar

//+ (instancetype)menuBar
//{
//    return [[self alloc] init];
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        [self initProperty];
//        
//        [self loadView];
//    }
//    return self;
//}

- (void)initProperty
{
    scale = [[UIScreen mainScreen] scale];
    
//    _topSeparateLineColor = [UIColor lightGrayColor];
    _bottomSeparateLineColor = [UIColor lightGrayColor];
    
    _scrollBackgroundColor = [UIColor whiteColor];
    _listBackgroundColor = [UIColor whiteColor];
    
    _scrollTitleFont = [UIFont systemFontOfSize:17.0f];
    _scrollTitleColor = [UIColor blackColor];
    _scrollSelectedTitleColor = [UIColor blueColor];
    
    _listTitleFont = [UIFont systemFontOfSize:17.0f];
    _listTitleColor = [UIColor blackColor];
    _listSelectedTitleColor = [UIColor blueColor];
    
    _promptColor = [UIColor redColor];
    
    listViewHeight = 0;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initProperty];
        
        [self loadView];
        
        self.titles = titles;
    }
    return self;
}

- (void)loadView
{
    UIView *topSeparateLine = [[UIView alloc] init];
    [self addSubview:topSeparateLine];
    _topSeparateLine = topSeparateLine;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.backgroundColor = _scrollBackgroundColor;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    UIView *promptView = [[UIView alloc] init];
    promptView.backgroundColor = _promptColor;
    [_scrollView addSubview:promptView];
    _promptView = promptView;
    
    UIView *bottomSeparateLine = [[UIView alloc] init];
    bottomSeparateLine.backgroundColor = _bottomSeparateLineColor;
    [self addSubview:bottomSeparateLine];
    _bottomSeparateLine = bottomSeparateLine;
    
    UIButton *dropDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dropDownBtn.backgroundColor = [UIColor clearColor];
    [dropDownBtn setImage:_dropDownImage forState:UIControlStateNormal];
    [dropDownBtn setImage:_dropDownSelectedImage forState:UIControlStateSelected];
    dropDownBtn.selected = NO;
    [dropDownBtn addTarget:self action:@selector(showListView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dropDownBtn];
    _dropDownBtn = dropDownBtn;
    
    _backgroundView = [[UIView alloc] init];
    _backgroundView.frame = [[UIScreen mainScreen] bounds];
    
    //设置window上试图的背景色
    //_backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideListView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_backgroundView addGestureRecognizer:tap];
    
    _listView = [[UIView alloc] init];
    _listView.backgroundColor = _listBackgroundColor;
    [_backgroundView addSubview:_listView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    windowRect = [self convertRect:frame toView:_backgroundView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topSeparateLine.frame = CGRectMake(0, 0, self.frame.size.width, 0);
//    _scrollView.frame = CGRectMake(0, 0.5f, self.frame.size.width - self.frame.size.height, self.frame.size.height - 1.0f);
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height - 0.5f);
    
    int tag = 0;
    CGFloat btnX = 15.0f;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            CGSize buttonSize = [self sizeWithTitle:_titles[tag]];
            btn.frame = CGRectMake(btnX, 0, buttonSize.width, self.frame.size.height - 2.0f);
            btnX += buttonSize.width + kScrollButtonInterval;
            tag++;
        }
    }
    _scrollView.contentSize = CGSizeMake(btnX, self.frame.size.height - 0.5f);
    CGSize buttonSize = [self sizeWithTitle:_titles.firstObject];
    _promptView.frame = CGRectMake(15.0f, self.frame.size.height - 3.0f, buttonSize.width, 3.0f);
    
    _dropDownBtn.frame = CGRectMake(CGRectGetMaxX(_scrollView.frame), 0.5f, self.frame.size.height, self.frame.size.height - 1.0f);
    _bottomSeparateLine.frame = CGRectMake(0, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f);
    
    _listView.frame = CGRectMake(0, CGRectGetMaxY(windowRect), self.frame.size.width, 0);
    
    tag = 0;
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            NSArray *frameArray = [self frameWithTitles:_titles];
            btn.frame = [frameArray[tag] CGRectValue];
            btnX += buttonSize.width + kScrollButtonInterval;
            tag++;
        }
    }
}

- (void)showListView:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        
        [self hideListView];
    }
    else {
        button.selected = YES;
        
        [self showListView];
    }
}

- (void)showListView
{
    _listView.frame = CGRectMake(0, CGRectGetMaxY(windowRect), self.frame.size.width, 0);
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:_backgroundView];
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(0, CGRectGetMaxY(windowRect), self.frame.size.width, listViewHeight);
    } completion:^(BOOL finished) {
        for (UIView *view in _listView.subviews) {
            view.hidden = NO;
        }
    }];
}

- (void)hideListView
{
    _dropDownBtn.selected = NO;
    _listView.frame = CGRectMake(0, CGRectGetMaxY(windowRect), self.frame.size.width, listViewHeight);
    for (UIView *view in _listView.subviews) {
        view.hidden = YES;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(0, CGRectGetMaxY(windowRect), self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:_scrollTitleColor forState:UIControlStateNormal];
    [button setTitleColor:_scrollSelectedTitleColor forState:UIControlStateSelected];
    [button setImage:_dropDownImage forState:UIControlStateNormal];
    [button setImage:_dropDownSelectedImage forState:UIControlStateSelected];
    button.titleLabel.font = _scrollTitleFont;
    return button;
}

- (void)scrollSelectedButton:(UIButton *)button
{
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    button.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        _promptView.frame = CGRectMake(CGRectGetMinX(button.frame), _promptView.frame.origin.y, CGRectGetWidth(button.frame), _promptView.frame.size.height);
    }];
    UIButton *nextBtn;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (button.tag == btn.tag - 1) {
                nextBtn = btn;
            }
        }
    }
    
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (button.tag == btn.tag) {
                btn.selected = YES;
            }
            else {
                btn.selected = NO;
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(menuBar:didSelectButtonIndex:)]) {
        [_delegate menuBar:self didSelectButtonIndex:button.tag];
    }
}

- (void)listSelectedButton:(UIButton *)button
{
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.selected = NO;
        }
    }
    button.selected = YES;
    [self hideListView];
    
    CGRect btnRect;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (button.tag == btn.tag) {
                btn.selected = YES;
                btnRect = btn.frame;
            }
            else {
                btn.selected = NO;
            }
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        _promptView.frame = CGRectMake(CGRectGetMinX(btnRect), _promptView.frame.origin.y, CGRectGetWidth(btnRect), _promptView.frame.size.height);
    }];
    [_scrollView scrollRectToVisible:CGRectMake(btnRect.origin.x - kScrollButtonInterval, btnRect.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    
    if ([_delegate respondsToSelector:@selector(menuBar:didSelectButtonIndex:)]) {
        [_delegate menuBar:self didSelectButtonIndex:button.tag];
    }
}

- (CGSize)sizeWithTitle:(NSString *)title
{
    CGSize size;
    
    CGSize maxSize = CGSizeMake(1000.0f, self.frame.size.height);
    if (_scrollTitleFont == nil) {
        return CGSizeMake(0, 0);
    }
    NSDictionary *attributes = @{NSFontAttributeName:_scrollTitleFont};

    CGRect rect = [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    size = CGSizeMake(rect.size.width + 8.0, rect.size.height);
    
    return size;
}

- (NSArray *)frameWithTitles:(NSArray *)titles
{
    NSMutableArray *frameArray = [NSMutableArray array];

    CGFloat  btnWidth = (self.frame.size.width - kScrollButtonInterval * 3) / 4;
    
    NSInteger row = 0;
    for (int i = 0; i < titles.count; i++) {
//        NSString *title = titles[i];
        row = i / 4;
        NSInteger column = (i - 4 * row) % 4;
        CGRect frame = CGRectMake(kScrollButtonInterval + (btnWidth + 5.0f) * column, kScrollButtonInterval + (kScrollButtonInterval + 30.0f) * row, btnWidth, 30.0f);
        [frameArray addObject:[NSValue valueWithCGRect:frame]];
    }
    listViewHeight = kScrollButtonInterval * (row + 2) + (row + 1) * 30.0f;
    return frameArray;
}

#pragma mark - set method

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    if (_scrollView.subviews.count <= 1 || _scrollView.subviews.count != _titles.count + 1) {
        for (UIView *view in _scrollView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
        
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self buttonWithTitle:titles[i]];
            button.tag = i;
            if (i == 0) {
                button.selected = YES;
            }
            else {
                button.selected = NO;
            }
            [button addTarget:self action:@selector(scrollSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
    }
    
    if (_listView.subviews.count == 0 || _listView.subviews.count != _titles.count) {
        [_listView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [self buttonWithTitle:titles[i]];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            button.tag = i;
            if (i == 0) {
                button.selected = YES;
            }
            else {
                button.selected = NO;
            }
            button.hidden = YES;
            [button addTarget:self action:@selector(listSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
            [_listView addSubview:button];
        }
    }
    
    int tag = 0;
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitle:_titles[tag] forState:UIControlStateNormal];
            tag++;
        }
    }
    for (int i = 0; i < _listView.subviews.count; i++) {
        UIView *view = _listView.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
        }
    }
}

- (void)setMenuBarBackgroundColor:(UIColor *)menuBarBackgroundColor
{
    _menuBarBackgroundColor = menuBarBackgroundColor;
    
    self.backgroundColor = _menuBarBackgroundColor;
    self.scrollBackgroundColor = _menuBarBackgroundColor;
    self.listBackgroundColor = _menuBarBackgroundColor;
}


- (void)setScrollBackgroundColor:(UIColor *)scrollBackgroundColor
{
    _scrollBackgroundColor = scrollBackgroundColor;
    
    _scrollView.backgroundColor = _scrollBackgroundColor;
}

- (void)setListBackgroundColor:(UIColor *)listBackgroundColor
{
    _listBackgroundColor = listBackgroundColor;
    
    _listView.backgroundColor = _listBackgroundColor;
}

- (void)setScrollTitleFont:(UIFont *)scrollTitleFont
{
    _scrollTitleFont = scrollTitleFont;
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.titleLabel.font = _scrollTitleFont;
            [self layoutSubviews];
        }
    }
}

- (void)setScrollTitleColor:(UIColor *)scrollTitleColor
{
    _scrollTitleColor = scrollTitleColor;
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_scrollTitleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setScrollSelectedTitleColor:(UIColor *)scrollSelectedTitleColor
{
    _scrollSelectedTitleColor = scrollSelectedTitleColor;
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_scrollSelectedTitleColor forState:UIControlStateSelected];
        }
    }
}

- (void)setListTitleFont:(UIFont *)listTitleFont
{
    _listTitleFont = listTitleFont;
    
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            btn.titleLabel.font = _listTitleFont;
        }
    }
}

- (void)setListTitleColor:(UIColor *)listTitleColor
{
    _listTitleColor = listTitleColor;
    
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_listTitleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setListSelectedTitleColor:(UIColor *)listSelectedTitleColor
{
    _listSelectedTitleColor = listSelectedTitleColor;
    
    for (UIView *view in _listView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:_listSelectedTitleColor forState:UIControlStateSelected];
        }
    }
}

- (void)setPromptColor:(UIColor *)promptColor
{
    _promptColor = promptColor;
    
    _promptView.backgroundColor = _promptColor;
}

- (void)setDropDownImage:(UIImage *)dropDownImage
{
    _dropDownImage = dropDownImage;
    
    [_dropDownBtn setImage:_dropDownImage forState:UIControlStateNormal];
}

- (void)setDropDownSelectedImage:(UIImage *)dropDownSelectedImage
{
    _dropDownSelectedImage = dropDownSelectedImage;
    
    [_dropDownBtn setImage:_dropDownSelectedImage forState:UIControlStateSelected];
}

//- (void)setTopSeparateLineColor:(UIColor *)topSeparateLineColor
//{
//    _topSeparateLineColor = topSeparateLineColor;
//    
//    _topSeparateLine.backgroundColor = _topSeparateLineColor;
//}

- (void)setBottomSeparateLineColor:(UIColor *)bottomSeparateLineColor
{
    _bottomSeparateLineColor = bottomSeparateLineColor;
    
    _bottomSeparateLine.backgroundColor = _bottomSeparateLineColor;
}

@end
