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

/*
 * Contains the network request that is sent
 */
struct NetworkRequest {
    
    var url: String!
    var method: HTTPMethod!
    var params: JSON?
    var headers: headers?
}

extension NetworkRequest{
    
    init(url:String, method: HTTPMethod) {
        self.init(url: url, method: method, params: nil, headers: nil)
    }
    
    init(url:String, method: HTTPMethod, params: JSON) {
        self.init(url: url, method: method, params: params, headers: nil)
    }
    
    init(url:String, method: HTTPMethod, headers: headers) {
        self.init(url: url, method: method, params: nil, headers: headers)
    }
}


/*
 * All models that have networking responsiblity can conform to this protocol
 */
protocol JSONReturnable{
    
    func toJSON() -> JSON
}


//MARK: - JSON Init

/*
 * All models that have networking responsiblity can conform to this protocol
 */
protocol JSONInitable {
    init?(json: JSON)
}

extension JSONInitable{
    
    /*
     * Returns an array of models that conform to JSONInitable protocol
     */
    func arrayOfItems<T: JSONInitable> (_ modelArray: Array<Any>) -> [T]{
        
        var arrOfItems:[T] = []
        
        for item in modelArray{
            
            if let json = item as? JSON{
                
                if let model = T(json: json){
                    arrOfItems.append(model)
                }
            }
        }
        
        return arrOfItems
    }
}
