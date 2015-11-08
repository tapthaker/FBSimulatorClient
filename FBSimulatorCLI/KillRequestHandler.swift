//
//  KillRequestHandler.swift
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

import Foundation

class KillRequestHandler: RequestHandler {
    func handle(request: Map) -> Either<Map, NSError> {
 
        let processIdentifier = request["processIdentifier"] as String?
        var error : NSError?;
        if let processIdentifierUnwrapped = processIdentifier {
            let identifier = processIdentifierUnwrapped.toInt()
            if let uIntIndentifier = identifier {
                SimulatorController.sharedController().killSimulator(UInt(uIntIndentifier), withError: &error)
            }
        } else {
            SimulatorController.sharedController().killAllSimulatorsWithError(&error)
        }

        if let errorUnwrapped = error {
            return Either.right(errorUnwrapped)
        } else {
            return Either.left(["success":"true"])
        }
    }
}
