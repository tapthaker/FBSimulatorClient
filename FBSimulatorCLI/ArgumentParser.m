//
//  ArgumentParser.m
//  FBSimulatorCLI
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import "ArgumentParser.h"

@interface ArgumentParser (){
    NSArray *arguments;
}
@end

@implementation ArgumentParser

- (instancetype)initWithArguments:(NSArray*)args
{
    self = [super init];
    if (self) {
        arguments = args;
    }
    return self;
}

-(NSString*)valueForFlag:(NSString*)flag {
    NSInteger i = [self indexOfFlag:flag];
    if (i + 1 < arguments.count) {
        return arguments[i+1];
    }
    return nil;
}

-(NSInteger)indexOfFlag:(NSString*)flag {
    for (NSInteger i = 0 ; i < arguments.count ; i++) {
        if ([flag isEqualToString:arguments[i]]) {
            return i;
        }
    }
    return -1;
}

-(BOOL)flagExists:(NSString*)flag {
    NSInteger i = [self indexOfFlag:flag];
    if (i > 0 && i< arguments.count) {
        return YES;
    }
    return NO;
}

@end
