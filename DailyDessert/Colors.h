//
//  AppColors.h
//  etikado
//
//  Created by Krishantha Jayathilake on 2013/12/06.
//  Copyright (c) 2013 TechOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

// All the colors are defined here.

#pragma mark - App Colors -

+ (UIColor *) background;
+ (UIColor *) loginButton;
+ (UIColor *) cloudBackground;
+ (UIColor *) tagSelected;
+ (UIColor *) menuBackground;

#pragma mark - Color Utils -

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSString *) colorToWeb:(UIColor*)color;
+ (NSString *) htmlFromUIColor:(UIColor *)_color;

@end
