//
//  MEViewController.h
//  SwipeGestureRecognizer
//
//  Created by piupiupiu on 16/7/14.
//  Copyright © 2016年 haitudeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TomViewController : UITableViewController

@property BOOL isActive;
@property NSInteger messageCount;

- (void)didRemovedFromServer;
@end
