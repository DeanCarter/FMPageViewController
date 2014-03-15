//
//  FMPageViewController.m
//  NewPhoenixFM
//
//  Created by Dean on 14-2-27.
//  Copyright (c) 2014年 Li James. All rights reserved.
//

#import "FMPageViewController.h"
#import "FMPageContentViewController.h"


#define POSITIONID (int)self.scrollView.contentOffset.x/320

@interface FMPageViewController ()<UIScrollViewDelegate>
{
    CGFloat userStartContentOffsetX;
    
    NSInteger lastSelectedForUser;
    
    BOOL _isAlwaysFirstPage;
    
    BOOL _isLeftScroll;
    
    BOOL _isScrollViewMove;
    
}
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign, getter = hasInitialized) BOOL initialized;
@property (nonatomic, assign, getter = isRotating) BOOL rotating;

@property (nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) CGFloat leftInset;
@property (nonatomic, assign) CGFloat rightInset;

@property (nonatomic, strong, readwrite) FMPageContentViewController *beforeController;
@property (nonatomic, strong, readwrite) FMPageContentViewController *afterController;

- (void)initializeChildControllers;

@end

@implementation FMPageViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect bounds = self.view.bounds;
    NSInteger numberOfPage = [self.dataSource numberOfPageInPageViewController:self];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:bounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.contentSize = CGSizeMake(bounds.size.width * numberOfPage, bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.scrollsToTop = NO;
    self.scrollView = scrollView;
    
    [self.view addSubview:self.scrollView];
    
    self.initialized = NO;
    self.leftInset = 0.f;
    self.rightInset = 0.f;
    
    [self initializeChildControllers];
    
}

- (void)updateScrollViewContentSize
{
    CGRect bounds = self.view.bounds;
    
    
    NSInteger numberOfPage = [self.dataSource numberOfPageInPageViewController:self];
    
    self.scrollView.frame = bounds;
    self.scrollView.contentSize = CGSizeMake(bounds.size.width * numberOfPage, bounds.size.height);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateScrollViewContentSize];
}

- (void)initializeChildControllers
{
    if (self.currentViewController) {
        [self.currentViewController willMoveToParentViewController:self];
        [self addChildViewController:self.currentViewController];
        self.currentViewController.view.frame = self.view.bounds;
        [self.scrollView addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];
    }
    

    
    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);

    
    CGRect bounds = self.scrollView.bounds;
    self.beforeController = [self.dataSource fmPageViewController:self
                               beforeViewControllerWithIndex:_currentPageIndex
                             ];
    self.afterController = [self.dataSource fmPageViewController:self
                               afterviewControllerWithIndex:_currentPageIndex
                            ];
    if (self.beforeController) {
        CGRect beforeFrame = self.scrollView.bounds;
        beforeFrame.origin.x = - bounds.size.width;
        
        [self.beforeController willMoveToParentViewController:self];
        [self addChildViewController:self.beforeController];
        self.beforeController.view.frame = beforeFrame;
        [self.scrollView addSubview:self.beforeController.view];
        [self.beforeController didMoveToParentViewController:self];
    }else {
        self.leftInset = 0.f;
    }
    
    if (self.afterController) {
        CGRect afterFrame = self.scrollView.bounds;
        afterFrame.origin.x = afterFrame.size.width;
        
        [self.afterController willMoveToParentViewController:self];
        [self addChildViewController:self.afterController];
        self.afterController.view.frame = afterFrame;
        [self.scrollView addSubview:self.afterController.view];
        [self.afterController didMoveToParentViewController:self];
    }else {
        self.rightInset = 0.f;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
    self.initialized = YES;
}

#pragma mark 滑动结束后操作(按操作顺序)

//判断用户是否快速滑动
- (BOOL)determineWhetherTheUserMoveFast:(UIScrollView *)scrollView
{
    if (fabs(lastSelectedForUser - POSITIONID) <= 1) {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark -- UIScrollViewDelegate method
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _isAlwaysFirstPage = NO;
    if (scrollView.contentOffset.x <= 0) {
        _isAlwaysFirstPage = YES;
    }
    userStartContentOffsetX = scrollView.contentOffset.x;
    _isScrollViewMove = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewDidScroll:)]) {
        [self.delegate pageViewDidScroll:scrollView];
    }
    
    if (self.isRotating) {
        return;
    }
    
    if (!self.hasInitialized && self.scrollView.superview) {
        [self initializeChildControllers];
        self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
    }else {
        if (scrollView.tracking && scrollView.dragging) {
            self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
        }
    }
    
    CGRect bounds = self.scrollView.bounds;
    
    if (CGRectIsEmpty(bounds)) {
        return;
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPageIndex = POSITIONID;
    DLog(@"ContentOffsetX:  %f",scrollView.contentOffset.x);
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewDidEndDecelerating:)]) {
        [self.delegate pageViewDidEndDecelerating:scrollView];
    }
    
    if (lastSelectedForUser - POSITIONID < 0) {
        _isLeftScroll = YES;
    }else {
        _isLeftScroll = NO;
    }
    
    BOOL isMoveFast = [self determineWhetherTheUserMoveFast:scrollView];
    if (POSITIONID == lastSelectedForUser) {
        _isScrollViewMove = NO;
        
        return;
    }
    

    [self adjustPageContentViewScrollView:scrollView withMoveFast:isMoveFast];
}

- (void)adjustPageContentViewScrollView:(UIScrollView *)scrollView
                           withMoveFast:(BOOL)isMoveFast
{
    
    NSInteger currentPageIndex = POSITIONID;
    
    _currentPageIndex = currentPageIndex;
    
    lastSelectedForUser = _currentPageIndex;
    
    CGRect bounds = self.scrollView.bounds;
    
    if (isMoveFast) {
        [self.currentViewController clearDataAndSomeViews];
        [self.beforeController clearDataAndSomeViews];
        [self.afterController clearDataAndSomeViews];
        
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        
        self.currentViewController = [self.dataSource fmPageViewController:self
                                            currentViewControllerWithIndex:currentPageIndex
                                      ];
        self.currentViewController.view.frame = CGRectMake(bounds.size.width * currentPageIndex, 0, bounds.size.width, bounds.size.height);
        [self.currentViewController willMoveToParentViewController:self];
        [self addChildViewController:self.currentViewController];
        [self.scrollView addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];
        
        
        
        
        [self.beforeController willMoveToParentViewController:nil];
        [self.beforeController.view removeFromSuperview];
        [self.beforeController removeFromParentViewController];

        self.beforeController = [self.dataSource fmPageViewController:self
                                        beforeViewControllerWithIndex:currentPageIndex
                                 ];
        if (self.beforeController) {
            self.beforeController.view.frame = CGRectMake(bounds.size.width * (currentPageIndex - 1), 0, bounds.size.width, bounds.size.height);
            [self.beforeController willMoveToParentViewController:self];
            [self addChildViewController:self.beforeController];
            [self.scrollView addSubview:self.beforeController.view];
            [self.beforeController didMoveToParentViewController:self];
        }
        
        [self.afterController willMoveToParentViewController:nil];
        [self.afterController.view removeFromSuperview];
        [self.afterController removeFromParentViewController];
        
        self.afterController = [self.dataSource fmPageViewController:self
                                        afterviewControllerWithIndex:currentPageIndex
                                 ];
        if (self.afterController) {
            self.afterController.view.frame = CGRectMake(bounds.size.width * (currentPageIndex + 1), 0, bounds.size.width, bounds.size.height);
            [self.afterController willMoveToParentViewController:self];
            [self addChildViewController:self.afterController];
            [self.scrollView addSubview:self.afterController.view];
            [self.afterController didMoveToParentViewController:self];
        }
    }else {
        //单页滑动
        if (_isLeftScroll) {
            //向左滑
            FMPageContentViewController *currentVC = self.afterController;
            
            [self.beforeController willMoveToParentViewController:nil];
            [self.beforeController.view removeFromSuperview];
            [self.beforeController removeFromParentViewController];
            
            self.beforeController = self.currentViewController;
            self.currentViewController = currentVC;
            
            self.afterController = [self.dataSource fmPageViewController:self
                                            afterviewControllerWithIndex:currentPageIndex];
            if (self.afterController) {
                self.afterController.view.frame = CGRectMake(bounds.size.width * (currentPageIndex + 1), 0, bounds.size.width, bounds.size.height);
                [self.afterController willMoveToParentViewController:self];
                [self addChildViewController:self.afterController];
                [self.scrollView addSubview:self.afterController.view];
                [self.afterController didMoveToParentViewController:self];
            }
            
        }else {
            //向右滑
            FMPageContentViewController *currentVC = self.beforeController;
            
            [self.afterController willMoveToParentViewController:nil];
            [self.afterController.view removeFromSuperview];
            [self.afterController removeFromParentViewController];
            
            self.afterController = self.currentViewController;
            self.currentViewController = currentVC;
            
            DLog(@"Currentframe:  %@",NSStringFromCGRect(self.currentViewController.view.frame));
            
            self.beforeController = [self.dataSource fmPageViewController:self
                                            beforeViewControllerWithIndex:currentPageIndex
                                    ];
            if (self.beforeController) {
                self.beforeController.view.frame = CGRectMake(bounds.size.width * (currentPageIndex - 1), 0, bounds.size.width, bounds.size.height);
                [self.beforeController willMoveToParentViewController:self];
                [self addChildViewController:self.beforeController];
                [self.scrollView addSubview:self.beforeController.view];
                [self.beforeController didMoveToParentViewController:self];
            }

        }
    }
    [self updateScrollViewContentSize];
}


- (void)setCurrentPageWithIndex:(NSInteger)index withObject:(NSObject *)obj
{
    NSInteger numberOfPage = [self.dataSource numberOfPageInPageViewController:self];
    CGRect bounds = self.scrollView.bounds;

    
    if (index == NSNotFound || index >= numberOfPage || index < 0 || obj == nil) {
        return;
    }
    _currentPageIndex = index;
    if (obj == _currentViewController.currentObject) {
        return;
    }else if (obj == _beforeController.currentObject) {
        //单页向右滑
        FMPageContentViewController *currentVC = self.beforeController;
        
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        
        self.currentViewController = currentVC;
        
        self.beforeController = [self.dataSource fmPageViewController:self
                                        beforeViewControllerWithIndex:_currentPageIndex
                                 ];
        if (self.beforeController) {
            self.beforeController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex - 1), 0, bounds.size.width, bounds.size.height);
            [self.beforeController willMoveToParentViewController:self];
            [self addChildViewController:self.beforeController];
            [self.scrollView addSubview:self.beforeController.view];
            [self.beforeController didMoveToParentViewController:self];

        }
        
        
        [self.afterController willMoveToParentViewController:nil];
        [self.afterController.view removeFromSuperview];
        [self.afterController removeFromParentViewController];
        
        self.afterController = [self.dataSource fmPageViewController:self
                                        afterviewControllerWithIndex:_currentPageIndex];
        if (self.beforeController) {
            self.beforeController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex + 1), 0, bounds.size.width, bounds.size.height);
            [self.afterController willMoveToParentViewController:self];
            [self addChildViewController:self.afterController];
            [self.scrollView addSubview:self.afterController.view];
            [self.afterController didMoveToParentViewController:self];
        }
        
        [self.scrollView scrollRectToVisible:self.currentViewController.view.frame animated:NO];;
    }else if (obj == _afterController.currentObject) {
        //单页向左滑
        
        FMPageContentViewController *currentVC = self.afterController;
        
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        
        self.currentViewController = currentVC;
        
        [self.beforeController willMoveToParentViewController:nil];
        [self.beforeController.view removeFromSuperview];
        [self.beforeController removeFromParentViewController];
        
        self.beforeController = [self.dataSource fmPageViewController:self
                                        beforeViewControllerWithIndex:_currentPageIndex
                                 ];
        if (self.beforeController) {
            self.beforeController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex - 1), 0, bounds.size.width, bounds.size.height);
            [self.beforeController willMoveToParentViewController:self];
            [self addChildViewController:self.beforeController];
            [self.scrollView addSubview:self.beforeController.view];
            [self.beforeController didMoveToParentViewController:self];
            
        }
        
        
        self.afterController = [self.dataSource fmPageViewController:self
                                        afterviewControllerWithIndex:_currentPageIndex];
        if (self.afterController) {
            self.afterController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex + 1), 0, bounds.size.width, bounds.size.height);
            [self.afterController willMoveToParentViewController:self];
            [self addChildViewController:self.afterController];
            [self.scrollView addSubview:self.afterController.view];
            [self.afterController didMoveToParentViewController:self];
        }
    }else {
        
        [self.currentViewController clearDataAndSomeViews];
        [self.beforeController clearDataAndSomeViews];
        [self.afterController clearDataAndSomeViews];
        
        [self.currentViewController willMoveToParentViewController:nil];
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        
        self.currentViewController = [self.dataSource fmPageViewController:self
                                            currentViewControllerWithIndex:_currentPageIndex
                                      ];
        self.currentViewController.view.frame = CGRectMake(bounds.size.width * _currentPageIndex, 0, bounds.size.width, bounds.size.height);
        [self.currentViewController willMoveToParentViewController:self];
        [self addChildViewController:self.currentViewController];
        [self.scrollView addSubview:self.currentViewController.view];
        [self.currentViewController didMoveToParentViewController:self];
        
        
        
        
        [self.beforeController willMoveToParentViewController:nil];
        [self.beforeController.view removeFromSuperview];
        [self.beforeController removeFromParentViewController];
        
        self.beforeController = [self.dataSource fmPageViewController:self
                                        beforeViewControllerWithIndex:_currentPageIndex
                                 ];
        if (self.beforeController) {
            self.beforeController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex - 1), 0, bounds.size.width, bounds.size.height);
            [self.beforeController willMoveToParentViewController:self];
            [self addChildViewController:self.beforeController];
            [self.scrollView addSubview:self.beforeController.view];
            [self.beforeController didMoveToParentViewController:self];
        }
        
        [self.afterController willMoveToParentViewController:nil];
        [self.afterController.view removeFromSuperview];
        [self.afterController removeFromParentViewController];
        
        self.afterController = [self.dataSource fmPageViewController:self
                                        afterviewControllerWithIndex:_currentPageIndex
                                ];
        if (self.afterController) {
            self.afterController.view.frame = CGRectMake(bounds.size.width * (_currentPageIndex + 1), 0, bounds.size.width, bounds.size.height);
            [self.afterController willMoveToParentViewController:self];
            [self addChildViewController:self.afterController];
            [self.scrollView addSubview:self.afterController.view];
            [self.afterController didMoveToParentViewController:self];
        }

    }
    
    lastSelectedForUser = _currentPageIndex;
    [self updateScrollViewContentSize];
    
    [self.scrollView scrollRectToVisible:self.currentViewController.view.frame animated:NO];
    
}

#pragma mark -- UIGestureRecognizer Delegate method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL valid = YES;
    return valid;
}

#pragma mark -create BeforeViewController || AfterViewController
- (void)queuingScrollViewDidPageForward:(UIScrollView *)scrollView
{
    
}

- (void)queuingScrollViewDidPageBackward:(UIScrollView *)scrollView
{
    
}

@end
