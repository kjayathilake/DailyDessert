//
//  User.h
//  DailyDessert
//
//  Created by Krishantha Jayathilake on 2014/02/02.
//  Copyright (c) 2014 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DessertInfo, PaidInfo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *infos;
@property (nonatomic, retain) NSSet *pInfos;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addInfosObject:(DessertInfo *)value;
- (void)removeInfosObject:(DessertInfo *)value;
- (void)addInfos:(NSSet *)values;
- (void)removeInfos:(NSSet *)values;

- (void)addPInfosObject:(PaidInfo *)value;
- (void)removePInfosObject:(PaidInfo *)value;
- (void)addPInfos:(NSSet *)values;
- (void)removePInfos:(NSSet *)values;

@end
