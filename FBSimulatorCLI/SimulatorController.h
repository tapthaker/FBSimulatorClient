//
//  SimulatorController.h
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimulatorController : NSObject

+ (instancetype)sharedController;

- (NSInteger)launchSimulatorOfType:(NSString*)simulatorType WithApp:(NSString*)appPath withError:(NSError **)error;

@end
