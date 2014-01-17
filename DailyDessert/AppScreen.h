//
//  AppScreen.h
//  etikado
//
//  Created by Krishantha Jayathilake on 2013/12/14.
//  Copyright (c) 2013 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppScreen : NSObject

// All the screen related common public methods are implemented here.

typedef enum {
    UITypePortrait, UITypeLandscape
} UItype;

+ (CGSize) sizeInOrientation;
+ (BOOL)isiPad;
+ (BOOL)isInLandscapeMode;
+ (UItype) getUIType;

@end
