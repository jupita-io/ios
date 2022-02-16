import Foundation

public class Jupita {
    
    /// Parameters
    public var TOUCHPOINT: Int = 0
    public var INPUT: Int = 0
    
    private var token: String = ""
    private var touchpointID: String = ""
    
    private var session: URLSession?
    private var task: URLSessionDataTask?
    
    
    /// This method initilize the Jupita
    /// - Parameters:
    ///   - token: token to call api
    ///   - touchpointID: touchpointID to call api
    public init(_ token: String, _ touchpointID: String) {
        self.token = token
        self.touchpointID = touchpointID
    }
    
    
    public func dump(text: String, inputID: String, channelTYPE: String) {
        self.dumpRequest(text: text, inputID: inputID, channelTYPE: channelTYPE, isCall: false) { _ in
        }
    }
    
    public func dump(text: String, inputID: String, channelTYPE: String, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?) {
        self.dumpRequest(text: text, inputID: inputID, channelTYPE: channelTYPE, isCall: false) { (result) -> Void? in
            completionHandler(result)
        }
    }
    
    public func dump(text: String, inputID: String, channelTYPE: String, type: Int, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?) {
        self.dumpRequest(text: text, inputID: inputID, channelTYPE: channelTYPE, type: type, isCall: false) { (result) -> Void? in
            completionHandler(result)
        }
    }
    
    public func dump(text: String, inputID: String, channelTYPE: String, type: Int, isCall: Bool, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?) {
        self.dumpRequest(text: text, inputID: inputID, channelTYPE: channelTYPE, type: type, isCall: isCall) { (result) -> Void? in
            completionHandler(result)
        }
    }
    
    ///Private Methods
    private func dumpRequest(text: String, inputID: String, channelTYPE: String, type: Int = 0, isCall: Bool, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?) {
        if(type != self.TOUCHPOINT && type != self.INPUT){
            completionHandler(.failure(NSError(domain:"You must enter Touchpoint or Input type", code:401, userInfo:nil)))
        }
        
        let parameters = ["token": self.token,
                          "touchpoint_id": self.touchpointID,
                          "input_id" : inputID,
                          "channel_type" : channelTYPE,
                          "message_type" : type,
                          "text" : text,
                          "isCall" : isCall] as [String : Any]
        
        let url:URL? = URL(string: Constants.dumpEndpoint)
        
        var request =  URLRequest(url:url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        self.network(request) { (result) in
            completionHandler(result)
        }
    }
    
    /// Create URLSession configurations
    private var sessionConfiguration: URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 7200.0
        sessionConfig.timeoutIntervalForResource = 7200.0
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        sessionConfig.httpShouldUsePipelining = true
        return sessionConfig
    }
    
    /// This method create URLSession call
    /// - Parameters:
    ///   - request: Pass api request
    ///   - completionHandler: URLSession request  result
    private func network(_ request: URLRequest, completionHandler: @escaping(_ result: Result<Any,Error>) -> Void?) {
        
        session = URLSession(configuration: sessionConfiguration)
        task = session!.dataTask(with: request) { (data, response, error) in
            
            if error == nil && data != nil {
                if let urlResponse = response as? HTTPURLResponse {
                    switch urlResponse.statusCode {
                    case 200:
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            completionHandler(.success(json))
                            
                        }catch let error {
                            completionHandler(.failure(error))
                        }
                        
                    default:
                        if let errorMessage = String(data: data!, encoding: String.Encoding.utf8) {
                            completionHandler(.failure(NSError(domain:errorMessage, code:urlResponse.statusCode, userInfo:nil)))
                        }
                    }
                }
            }else {
                completionHandler(.failure(error!))
            }
        }
        task!.resume()
    }
}
