//
//  DessertListViewController.h
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface DessertListViewController : UITableViewController

@property (nonatomic) User *user;
@property (nonatomic) NSDate *date;

@end
