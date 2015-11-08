//
//  SimulatorController.m
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import "SimulatorController.h"
#import <Foundation/Foundation.h>
#import <FBSimulatorControl/FBSimulatorControl.h>
#import <FBSimulatorControl/FBProcessLaunchConfiguration.h>
#import <FBSimulatorControl/FBSimulator.h>
#import <FBSimulatorControl/FBSimulatorApplication.h>
#import <FBSimulatorControl/FBSimulatorConfiguration.h>
#import <FBSimulatorControl/FBSimulatorControl+Private.h>
#import <FBSimulatorControl/FBSimulatorControl.h>
#import <FBSimulatorControl/FBSimulatorControlConfiguration.h>
#import <FBSimulatorControl/FBSimulatorSession.h>
#import <FBSimulatorControl/FBSimulatorSessionInteraction.h>
#import <FBSimulatorControl/FBSimulatorPool.h>

@interface SimulatorController () {
    FBSimulatorControl *control;
}

@end

@implementation FBSimulatorPool (Query)

-(FBSimulator*) simulatorWithProcessIdentifier:(NSUInteger)processIdentifier {
    NSOrderedSet *simulators = self.allSimulators;
    for (FBSimulator *simulator in simulators) {
        if (simulator.processIdentifier == processIdentifier) {
            return simulator;
        }
    }
    return nil;
}

@end

@implementation SimulatorController

+ (instancetype)sharedController
{
    static dispatch_once_t onceQueue;
    static SimulatorController *simulatorController = nil;
    
    dispatch_once(&onceQueue, ^{ simulatorController = [[self alloc] init]; });
    return simulatorController;
}

-(instancetype) init {
    self = [super init];
    
    if (self) {
        FBSimulatorManagementOptions options = FBSimulatorManagementOptionsDeleteAllOnFirstStart | FBSimulatorManagementOptionsKillSpuriousSimulatorsOnFirstStart;
        NSError *simulatorError;
        FBSimulatorControlConfiguration *configuration = [FBSimulatorControlConfiguration configurationWithSimulatorApplication:[FBSimulatorApplication simulatorApplicationWithError:&simulatorError] deviceSetPath:nil options:options];;
        control = [[FBSimulatorControl alloc] initWithConfiguration:configuration];
    }
    return self;
}

- (NSInteger)launchSimulatorOfType:(NSString*)simulatorType WithApp:(NSString*)appPath withError:(NSError **)error {
    NSError *simulatorApplicationError;
    FBSimulatorApplication *application = [FBSimulatorApplication applicationWithPath:appPath error:&simulatorApplicationError];
    
    NSError *sessionError = nil;
    FBSimulatorConfiguration *simulatorConfig = [FBSimulatorConfiguration iPhone5s];
    FBSimulatorSession *session = [control createSessionForSimulatorConfiguration:simulatorConfig error:&sessionError];
    
    FBApplicationLaunchConfiguration *launchConfig = [FBApplicationLaunchConfiguration
                                                   configurationWithApplication:application
                                                   arguments:@[]
                                                   environment:@{}];
    
    FBSimulatorSessionInteraction *interaction = session.interact;
    [[[[interaction bootSimulator] installApplication:application] launchApplication:launchConfig]performInteractionWithError:&sessionError];
    
    return session.simulator.processIdentifier;
}

- (void) killSimulator:(NSUInteger)processIdentifier withError:(NSError**)error{
    FBSimulator *simulator = [control.simulatorPool simulatorWithProcessIdentifier:processIdentifier];
    [control.simulatorPool freeSimulator:simulator error:error];
}

- (void) killAllSimulatorsWithError:(NSError**)error {
    [control.simulatorPool killAllWithError:error];
}


@end
