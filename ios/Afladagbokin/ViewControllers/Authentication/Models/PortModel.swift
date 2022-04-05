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

struct PortModel{
    
    static let idKey = "id"
    static let portNameKey = "portName"
    
    public var id = 0
    public var portName = ""
}

extension PortModel: JSONInitable{
    
    init?(json: JSON){
        
        guard let id = json[PortModel.idKey] as? Int else{
            return nil
        }
        
        guard let portName = json[PortModel.portNameKey] as? String else{
            return nil
        }
        self.id = id
        self.portName = portName
    }
}

extension PortModel: JSONReturnable{
    
    func toJSON() -> JSON {
        return [PortModel.idKey : id, PortModel.portNameKey : portName]
    }
}
