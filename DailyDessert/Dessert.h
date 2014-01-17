//
//  Dessert.h
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/01/15.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DessertInfo;

@interface Dessert : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSSet *infos;
@end

@interface Dessert (CoreDataGeneratedAccessors)

- (void)addInfosObject:(DessertInfo *)value;
- (void)removeInfosObject:(DessertInfo *)value;
- (void)addInfos:(NSSet *)values;
- (void)removeInfos:(NSSet *)values;

@end
