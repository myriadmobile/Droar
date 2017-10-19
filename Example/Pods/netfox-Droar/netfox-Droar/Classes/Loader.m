//
//  Loader.m
//  netfox-Droar
//
//  Created by Nathan Jangula on 10/13/17.
//

#import "Loader.h"
#import <netfox_Droar/netfox_Droar-Swift.h>

@implementation Loader

+ (void)load
{
    [netfox_Droar performSelector:NSSelectorFromString(@"start")];
}

@end
