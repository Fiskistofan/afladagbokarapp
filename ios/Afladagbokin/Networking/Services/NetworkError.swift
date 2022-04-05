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


enum NetworkError: Error {
    case noInternet
    case custom(String,HTTPStatusCode?)
    case unknown(HTTPStatusCode?)
}


extension NetworkError: LocalizedError {
    
    ///Return the error description
    var why: String {
        switch self {
        case .noInternet:
            return "No Internet connection"
        case .unknown(let statusCode):
            return "Something went wrong. Sorry!" + " (\(statusCode!.rawValue))"
        case .custom(let message, _):
            return message
        }
    }
    
    var code:HTTPStatusCode{
        switch self {
        case .noInternet:
            return HTTPStatusCode.requestTimeout
        case .unknown(let statusCode):
            return statusCode!
        case .custom(_, let statusCode):
            return statusCode!
        }
    }
    
    ///Construct the error message from json
    init(json: JSON, statusCode: HTTPStatusCode?) {
        let message = (json["message"] as? String) ?? "Unknown error"
        self = .custom(message, statusCode)
    }
    
    
    ///Construct the error message from json
    init(error: Error, statusCode: HTTPStatusCode?) {
        self = .custom(error.localizedDescription, statusCode)
    }
}
