//
//  DessertInfo.h
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dessert, User;

@interface DessertInfo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Dessert *dessert;

@end
