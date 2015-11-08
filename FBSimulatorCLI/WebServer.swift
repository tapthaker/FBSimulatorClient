import Foundation
import GCDWebServer

class WebServer : NSObject {
    private let webserver : GCDWebServer!
    private let portNumber : UInt
    
    private let handlers = [ ["method":"POST","path":"/simulator/launch", "handler":LaunchRequestHandler()],
        ["method":"POST","path":"/simulator/kill", "handler" : KillRequestHandler()]]
    
    init(port: UInt) {
        webserver = GCDWebServer()
        portNumber = port
        super.init()
        self.addHandlers()
    }
    
    private func addHandlers()  {
        for handlerMapping in handlers {
            let method = handlerMapping["method"] as! String
            let path = handlerMapping["path"] as! String
            let handler = handlerMapping["handler"] as! RequestHandler
            self.addHandler(method, path: path, handler: handler)
        }
    }
    
    private func addHandler(method: String, path: String, handler: RequestHandler) {
        webserver.addHandlerForMethod(method, path: path, requestClass: GCDWebServerDataRequest.self) { (request, completionCallback) -> Void in
            self .handleRequest(request, handler: handler, completionBlock: completionCallback)
        }
    }
    
    private func handleRequest(request : GCDWebServerRequest, handler : RequestHandler, completionBlock : GCDWebServerCompletionBlock) {
        
        let dataRequest = request as! GCDWebServerDataRequest
        var serializationError : NSError?
        let map = NSJSONSerialization.JSONObjectWithData(dataRequest.data, options: NSJSONReadingOptions.allZeros, error: &serializationError) as? Map
        
        if let error = serializationError {
            completionBlock(self.dataResponseForError(error))
        } else {
            if let requestMap = map {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let response = handler.handle(requestMap)
                    var dataResponse  : GCDWebServerDataResponse;
                    if response.isLeft() {
                        dataResponse = GCDWebServerDataResponse(data: NSJSONSerialization.dataWithJSONObject(response.left!, options: NSJSONWritingOptions.allZeros, error: nil) , contentType: "application/json")
                        dataResponse.statusCode = 200;
                    } else {
                        dataResponse = self.dataResponseForError(response.right!)
                    }
                    completionBlock(dataResponse)
                })
            }
        }
    }
    
    private func dataResponseForError(error :NSError) -> GCDWebServerDataResponse {
        let dataResponse = GCDWebServerDataResponse(data: NSJSONSerialization.dataWithJSONObject(error.userInfo!, options: NSJSONWritingOptions.allZeros, error: nil) , contentType: "application/json")
        dataResponse.statusCode = 500
        return dataResponse
    }
    
    func startServer()  {
        webserver.startWithPort(portNumber, bonjourName: "FBSimulatorClient")
    }
    
}


