//
//  ExitHandler.swift
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

import Foundation
class ControlHandler: RequestHandler {
    func handle(request: Map) -> Either<Map, NSError> {
 
        let command = request["command"];

        if let commandUnwrapped = command {
            switch commandUnwrapped {
            case "quit":
                var error : NSError?
                SimulatorController.sharedController().killAllSimulatorsWithError(&error)
                if let errorUnwrapped = error {
                    exit(1)
                }else {
                    exit(0)
                }
            default:
                return Either.right(NSError(domain: "com.fbsimulator.client", code: 500, userInfo: [NSLocalizedDescriptionKey : "No such command: "+commandUnwrapped]))
            }
        } else {
            return Either.right(NSError(domain: "com.fbsimulator.client", code: 500, userInfo: [NSLocalizedDescriptionKey : "Command parameter missing"]))
        }
    }
}
