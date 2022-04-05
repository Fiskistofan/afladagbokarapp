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

typealias Result<T> = (model: T?,  message: String,  success: Bool, code: HTTPStatusCode?)

class NetworkingService {
    
    //MARK: - Properties
    
    public let networking = Networking.manager
    
    //MARK: - Private methods
    
    /*
     * Construct the model, message and result status from the json/error with generics
     */
    public func resultFromJSON<T: JSONInitable>(_ json: JSON?, _ error: NetworkError?) -> Result<T>{
        
        //If we have an error we return immediately with the errors message
        if let error = error {
            return Result(nil, error.why, false, error.code)
        }
            
        //else if we have some data we try to init the model with the data
        else if let json = json{
            
            if let model = T(json:json){
                return Result(model, "", true, HTTPStatusCode.ok)
            }
            else{
                return Result(nil, ApplicationConstants.unkownError, false, nil)
            }
        }
        //else we have an empty response but we take that as a success
        else{
            return Result(nil, "", true, HTTPStatusCode.ok)
        }
    }
}
