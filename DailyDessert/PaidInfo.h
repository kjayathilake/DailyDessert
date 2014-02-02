//
//  PaidInfo.h
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/02/02.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface PaidInfo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * paid;
@property (nonatomic, retain) User *user;

@end
