//
//  AppDelegate.m
//  FBSimulatorCLI
//
//  Created by Tapan Thaker on 07/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

#import "AppDelegate.h"
#import "ArgumentParser.h"
#import "FBSimulatorClient-Swift.h"
#import <Foundation/Foundation.h>

@interface AppDelegate () {
    WebServer *webserver;
}

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    ArgumentParser *parser = [[ArgumentParser alloc]initWithArguments:arguments];
    
    if ([parser flagExists:@"--start-server"] ) {
        NSString *portNumberString = [parser valueForFlag:@"--port"];
        if (portNumberString != nil) {
            NSScanner *scanner = [NSScanner scannerWithString:portNumberString];
            NSInteger portNumber;
            if ([scanner scanInteger:&portNumber]) {
                webserver = [[WebServer alloc]initWithPort:portNumber];
                [webserver startServer];
            } else {
                [NSException raise:@"Invalid port number" format:@"Invalid port number:%@",portNumberString];
            }
        } else {
            [NSException raise:@"Invalid port number" format:@"Please pass a valid port number with --port argument"];
        }
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
