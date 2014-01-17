//
//  AppColors.m
//  etikado
//
//  Created by Krishantha Jayathilake on 2013/12/06.
//  Copyright (c) 2013 TechOne. All rights reserved.
//

#import "Colors.h"

@implementation Colors

#pragma mark - App Colors -

+ (UIColor *) background
{
    return [self colorFromHexString:@"#4c4ca6"];
}

+ (UIColor *) loginButton
{
    return [self colorFromHexString:@"#0099CC"];
}

+ (UIColor *) cloudBackground
{
    return [self colorFromHexString:@"#ffffff"];
}

+ (UIColor *) tagSelected
{
    return [self colorFromHexString:@"#53b1e1"];
}

+ (UIColor *) menuBackground
{
    return [self colorFromHexString:@"#25313c"];
}


#pragma mark - Color Utils -

+ (UIColor *) colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSString*) colorToWeb:(UIColor*)color
{
    NSString *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);
        
        // Convert with %02x (use 02 to always get two chars)
        webColor = [[NSString alloc]initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    
    return webColor;
}

+ (NSString *) htmlFromUIColor:(UIColor *)_color
{
    if (CGColorGetNumberOfComponents(_color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(_color.CGColor);
        _color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(_color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(_color.CGColor))[0]*255.0), (int)((CGColorGetComponents(_color.CGColor))[1]*255.0), (int)((CGColorGetComponents(_color.CGColor))[2]*255.0)];
}


@end
