//
//  FMPageContentViewController.h
//  NewPhoenixFM
//
//  Created by Dean on 14-2-27.
//  Copyright (c) 2014年 Li James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPageContentViewController : UIViewController
@property(nonatomic,strong,readonly) NSObject *currentObject;
@property(nonatomic, readonly) NSInteger currentPage;

- (id)initWithObject:(NSObject *)object withIndex:(NSInteger)index;

- (void)clearDataAndSomeViews;
@end
