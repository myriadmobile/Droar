//
//  ObjcHelper.m
//  Pods
//
//  Created by Nathan Jangula on 6/15/17.
//
//

#import "ObjcHelper.h"
#import <Droar/Droar-Swift.h>

@implementation ObjcHelper
    
    NSString *compileDate() {
        return [NSString stringWithUTF8String:__DATE__];
    }
    
    NSString *compileTime() {
        return [NSString stringWithUTF8String:__TIME__];
    }
    
@end
