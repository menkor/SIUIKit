//
//  SIFont.m
//  SuperId
//
//  Created by YeTao on 17/1/18.
//
//

#import "SIFontDef.h"
#import "SIFont.h"

@implementation SIFont

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:kSIFontSystemFontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:kSIFontBoldSystemFontName size:fontSize];
    if (!font) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)lightSystemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:kSIFontLightSystemFontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)mediumSystemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:kSIFontMediumSystemFontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)italicSystemFontOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:kSIFontMediumSystemFontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

@end
