//
//  AppDelegate.m
//  FBSimulatorCLI
//
//  Created by Tapan Thaker on 07/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import "AppDelegate.h"
#import "ArgumentParser.h"
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

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    ArgumentParser *parser = [[ArgumentParser alloc]initWithArguments:arguments];
    NSUInteger numberOfSimulators = [parser valueForFlag:@"--number-of-simulators"].integerValue;
    NSString* appPath = [parser valueForFlag:@"--app-path"];
    
    NSError *appError;
    FBSimulatorApplication *app = [FBSimulatorApplication applicationWithPath:appPath error:&appError];
    if (appError) {
        [NSException raise:@"Error reading the app" format:@"Error:%@",appError.localizedDescription];
    }
    
    FBSimulatorManagementOptions options =
    FBSimulatorManagementOptionsDeleteAllOnFirstStart |
    FBSimulatorManagementOptionsKillSpuriousSimulatorsOnFirstStart |
    FBSimulatorManagementOptionsDeleteOnFree;
    
    NSError *simulatorError;
    FBSimulatorControlConfiguration *configuration = [FBSimulatorControlConfiguration configurationWithSimulatorApplication:[FBSimulatorApplication simulatorApplicationWithError:&simulatorError] deviceSetPath:nil options:options];
    if (simulatorError) {
        [NSException raise:@"Error in finding the simulator application" format:@"Error:%@",simulatorError.localizedDescription];
    }
    
    FBSimulatorControl *control = [[FBSimulatorControl alloc] initWithConfiguration:configuration];
    
    NSError *sessionError = nil;
    FBSimulatorSession *session = [control createSessionForSimulatorConfiguration:FBSimulatorConfiguration.iPhone5 error:&sessionError];
    
    FBApplicationLaunchConfiguration *appLaunch = [FBApplicationLaunchConfiguration
                                                   configurationWithApplication:app
                                                   arguments:@[]
                                                   environment:@{}];
    
    // System Applications can be launched directly, User applications must be installed first with `installSimulator:`
    [[[[session.interact
                      bootSimulator] installApplication:app]
                     launchApplication:appLaunch]
                    performInteractionWithError:&sessionError];
    
    if (sessionError) {
        [NSException raise:@"Error in Session" format:@"%@Error:@",sessionError.localizedDescription];
    }

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
