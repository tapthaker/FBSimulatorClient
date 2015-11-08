//
//  ArgumentParser.h
//  FBSimulatorCLI
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArgumentParser : NSObject

- (instancetype)initWithArguments:(NSArray*)args;
-(NSString*)valueForFlag:(NSString*)flag;
-(BOOL)flagExists:(NSString*)flag;

@end
