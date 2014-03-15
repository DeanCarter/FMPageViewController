//
//  FMPageViewController.h
//  NewPhoenixFM
//
//  Created by Dean on 14-2-27.
//  Copyright (c) 2014年 Li James. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMPageContentViewController;
@protocol FMPageViewControllerDataSource;
@protocol FMPageViewControllerDelegate;


@interface FMPageViewController : UIViewController
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, strong) FMPageContentViewController *currentViewController;

@property (nonatomic, weak) id<FMPageViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<FMPageViewControllerDelegate>delegate;

- (void)setCurrentPageWithIndex:(NSInteger)index withObject:(NSObject *)obj;

@end


@protocol FMPageViewControllerDataSource <NSObject>
@required

/*
 返回该pageViewController会有多少页
 */
- (NSInteger)numberOfPageInPageViewController:(FMPageViewController *)pageViewController;

/*
 根据index生成当前需要显示的contentViewController
 */
- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController
                       currentViewControllerWithIndex:(NSInteger)index;

/**
 预加载前一页视图，如果返回为nil，则说明左边没有更多视图
 
 @param pageViewController 当前的承载器
 @param currentIndex  即将显示的viewController的位置
 */
- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController
                        beforeViewControllerWithIndex:(NSInteger)currentIndex;
/**
 预加载下一页视图，如果返回为nil，则说明右边没有更多视图
 
 @param pageViewController 当前的承载器
 @param currentIndex  即将显示的viewController的位置
 */
- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController
                    afterviewControllerWithIndex:(NSInteger)currentIndex;


@end


@protocol FMPageViewControllerDelegate <NSObject>
@optional
- (void)pageViewDidScroll:(UIScrollView *)scrollView;
- (void)pageViewDidEndDecelerating:(UIScrollView *)scrollView;
@end