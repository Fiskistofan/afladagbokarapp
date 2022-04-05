// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import Alamofire
import AlamofireObjectMapper
import FirebaseAuth

///JSON data is of type [String: Any]
typealias JSON = [String: Any]
///Headers are of type string:string
typealias headers = [String: String]?

final class Networking: NSObject {
    
    //MARK: - Properties
    static let manager = Networking()
    
    private var baseUrl: String = Session.manager.baseAPI()
    
    //the encoding used to send/Receive data
    private var encoding:ParameterEncoding = JSONEncoding.default
    
    //MARK: - Public methods
    public func request(_ request:NetworkRequest, completion: @escaping (_ result: JSON?, _ error: NetworkError?) -> Void) {
        let firebaseManager = FireBaseManager.sharedInstance
        print(request.url)
        
//        firebaseManager.refreshTokenIfNeeded() { [weak self] _, _ in
//            guard let this = self else {
//                return
//            }
            
            guard let url = URL(string: baseUrl + request.url) else {
                completion(nil, NetworkError.unknown(HTTPStatusCode.badRequest))
                return
            }
            
            guard let method = request.method else {
                completion(nil, NetworkError.unknown(HTTPStatusCode.badRequest))
                return
            }
            
            let params = request.params
            let allHeaders = baseHeaders()
 
            Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers:allHeaders).responseJSON { (response:DataResponse<Any>) in
                let httpStatusCode = response.response?.statusCode ?? 404
                if httpStatusCode == 401{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let alert = UIAlertController(title: "Villa kom upp við auðkenningu", message: "Vinsamlegast skráðu þig inn aftur", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        
                        appDelegate.logOut()
                    }))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    return
                }
                let statusCode = HTTPStatusCode(rawValue: httpStatusCode)
                //act on the response received
                switch response.result {
                case .success(let value):
                    //try to get the json
                    
                    if let json = value as? JSON{
                        //check the status of the call
                        if statusCode?.isSuccess == false {
                            completion(nil, NetworkError(json: json, statusCode: statusCode))
                            return
                        }
                        //respond with json data
                        completion(json, nil)
                    }
                    else {
                        var json: JSON = [:]
                        json["response"] = value
                        
                        if statusCode?.isSuccess == false {
                            completion(nil, NetworkError(json: json, statusCode: statusCode))
                            return
                        } else {
                            //respond with json data
                            completion(json, nil)
                            return
                        }
                    }
                case .failure(let error):
                    print(error)
                    //if the status is a success but we don't get a body which results in a failure handle that as a success
                    if statusCode?.isSuccess == true {
                        completion(nil,nil)
                        return
                    }
                    //respond with the errors description
                    completion(nil, NetworkError(error: error, statusCode: statusCode))
                    return
                }
            }
        }
    //}
}



// MARK: - BaseHeader
extension Networking{
    fileprivate func baseHeaders() -> [String:String] {
        var baseHeaders:[String:String] = ["Content-Type" : "application/json"]
        
        guard let token = Session.manager.userToken() else {
            return baseHeaders
        }
        baseHeaders["Authorization"] = "Bearer \(token)"
        
        return baseHeaders
    }
}
