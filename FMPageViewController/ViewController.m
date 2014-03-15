//
//  ViewController.m
//  FMPageViewController
//
//  Created by Dean on 14-3-15.
//  Copyright (c) 2014年 Dean. All rights reserved.
//

#import "ViewController.h"
#import "FMPageViewController.h"

#import "FMDefaultViewController.h"
#import "FMMainViewController.h"
#import "FMOrderViewController.h"
#import "FourthViewController.h"


@interface ViewController ()<FMPageViewControllerDataSource,FMPageViewControllerDelegate>
{
    BOOL isFirstLoad;
}
@property (nonatomic, strong) FMPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ViewController


- (void)commitInit
{
    
    _pageViewController = [[FMPageViewController alloc] init];
    _pageViewController.view.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    [self.view addSubview:self.pageViewController.view];
   // [self.pageViewController setCurrentPageWithIndex:0 withObject:list[0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self commitInit];
    
    isFirstLoad = YES;
    self.list = [NSMutableArray arrayWithObjects:@"头条",@"娱乐",@"财经",@"科技",@"公开课",@"健康养生",@"军事",@"体育",@"社会文史",@"微博",@"手机",@"互联网", nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isFirstLoad) {
        [self.pageViewController setCurrentPageWithIndex:0 withObject:self.list[0]];
        isFirstLoad = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (FMPageContentViewController *)viewControllerWithObjectAtIndex:(NSInteger)index
{
    NSObject *channel = [self.list objectAtIndex:index];
    FMPageContentViewController *vc = nil;
    if (index == 0 || index == 4 || index == 5 || index == 8 || index == 11) {
        vc = [[FMDefaultViewController alloc] initWithObject:channel withIndex:index];
    }else if (index == 1 || index == 3 || index == 7) {
        vc = [[FMMainViewController alloc] initWithObject:channel withIndex:index];
    }else if (index == 2 || index == 6 || index == 10) {
        vc = [[FMOrderViewController alloc] initWithObject:channel withIndex:index];
    }else {
        vc = [[FourthViewController alloc] initWithObject:channel withIndex:index];
    }
    //[self.segmentView setSegmentWithIndex:index];
    return vc;
}

#pragma mark -- FMPageViewController DataSource && Delegate method
- (NSInteger)numberOfPageInPageViewController:(FMPageViewController *)pageViewController
{
    return self.list.count;
}

- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController currentViewControllerWithIndex:(NSInteger)index
{
    if (index < 0 || index >=  self.list.count || index == NSNotFound) {
        return nil;
    }
    return [self viewControllerWithObjectAtIndex:index];
}

- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController beforeViewControllerWithIndex:(NSInteger)currentIndex
{
    if (currentIndex == NSNotFound || currentIndex == 0) {
        return nil;
    }
    return [self viewControllerWithObjectAtIndex:currentIndex - 1];
}

- (FMPageContentViewController *)fmPageViewController:(FMPageViewController *)pageViewController afterviewControllerWithIndex:(NSInteger)currentIndex
{
        if (currentIndex == NSNotFound || currentIndex == (self.list.count - 1)) {
        return nil;
    }
    return [self viewControllerWithObjectAtIndex:currentIndex + 1];
}

- (void)pageViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)pageViewDidEndDecelerating:(UIScrollView *)scrollView
{

}


@end
