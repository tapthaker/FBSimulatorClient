//
//  AbstractRequestHandler.swift
//  FBSimulatorClient
//
//  Created by Tapan Thaker on 08/11/15.
//  Copyright (c) 2015 TT. All rights reserved.
//

import Foundation

typealias Map = Dictionary<String,String>
protocol RequestHandler {
    func handle(request : Map) -> Either<Map, NSError>;
}
