//
//  AppScreen.m
//  etikado
//
//  Created by Krishantha Jayathilake on 2013/12/14.
//  Copyright (c) 2013 TechOne. All rights reserved.
//

#import "AppScreen.h"

@implementation AppScreen


+ (CGSize) sizeInOrientation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
        size = CGSizeMake(size.height, size.width);
    if (application.statusBarHidden == YES)
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    return size;
}

+ (BOOL)isiPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL)isInLandscapeMode
{
    
    if([UIApplication sharedApplication].statusBarOrientation==1 ||[UIApplication sharedApplication].statusBarOrientation==2){
        return NO;
    }
    else return YES;
}

+ (UItype) getUIType
{
    return ([self isInLandscapeMode]?UITypeLandscape:UITypePortrait);
}


@end
