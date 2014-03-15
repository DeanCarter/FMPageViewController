//
//  FMPageContentViewController.m
//  NewPhoenixFM
//
//  Created by Dean on 14-2-27.
//  Copyright (c) 2014年 Li James. All rights reserved.
//

#import "FMPageContentViewController.h"

@interface FMPageContentViewController ()
{
    NSInteger _page;
}
@property(nonatomic,strong,readwrite) NSObject *object;
@end

@implementation FMPageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithObject:(NSObject *)object withIndex:(NSInteger)index;
{
    if (self = [super init]) {
        self.object = object;
        _page = index;
    }
    return self;
}

- (NSObject *)currentObject
{
    return self.object;
}

- (NSInteger)currentPage
{
    return _page;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearDataAndSomeViews
{
    
}

@end
