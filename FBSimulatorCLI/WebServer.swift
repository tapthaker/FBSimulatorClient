import Foundation
import GCDWebServer

class WebServer : NSObject {
    private let webserver : GCDWebServer!
    private let portNumber : UInt
    
    init(port: UInt) {
        webserver = GCDWebServer()
        portNumber = port
        super.init()
        self.addHandlers()
    }
    
    private func addHandlers()  {
        
        webserver.addHandlerForMethod("POST", path: "/simulator/launch", requestClass: GCDWebServerDataRequest.self) { (request, completionCallback) -> Void in
  
            let dataRequest = request as! GCDWebServerDataRequest
            let map = NSJSONSerialization.JSONObjectWithData(dataRequest.data, options: NSJSONReadingOptions.allZeros, error: nil) as! Map
            NSLog("GOT REQUEST: %@", map)
            let requestHandler = LaunchRequestHandler()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let response = requestHandler.handle(map)
                var dataResponse  : GCDWebServerDataResponse;
                if response.isLeft() {
                    dataResponse = GCDWebServerDataResponse(data: NSJSONSerialization.dataWithJSONObject(response.left!, options: NSJSONWritingOptions.allZeros, error: nil) , contentType: "application/json")
                    dataResponse.statusCode = 200;
                } else {
                    dataResponse = GCDWebServerDataResponse(data: NSJSONSerialization.dataWithJSONObject(response.right!.userInfo!, options: NSJSONWritingOptions.allZeros, error: nil) , contentType: "application/json")
                    
                }
                completionCallback(dataResponse)
            })
        }
        
    }
    
    func startServer()  {
        webserver.startWithPort(portNumber, bonjourName: "FBSimulatorClient")
    }
}
