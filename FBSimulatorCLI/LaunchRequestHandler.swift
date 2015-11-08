//
//  LaunchRequestHandler.swift
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

import Foundation

class LaunchRequestHandler : RequestHandler {
    
    func handle(request: Map) -> Either<Map, NSError> {
        let simulatorType = request["simulatorType"];
        let appPath = request["appPath"];
        var launchError : NSError?
        let processIdentifier = SimulatorController.sharedController().launchSimulatorOfType(simulatorType!, withApp: appPath!, withError: &launchError)
        
        if let error = launchError {
            return Either.right(error)
        }
        return Either.left(["processIdentifier":String(processIdentifier)])
    }
}
