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


struct PullModel {
    let id: String
    let count: Int
    let datePulled: Date
    let tossId: String
    
    init(count: Int, tossId: String) {
        self.id = UUID().uuidString
        self.count = count
        self.datePulled = Date()
        self.tossId = tossId
    }
}

extension PullModel {
    init(pull: Pull) {
        self.id = pull.id
        self.count = pull.count
        self.datePulled = pull.date
        self.tossId = pull.tossId
    }
}


extension PullModel: JSONInitable, JSONReturnable {
    init?(json: JSON) {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        guard let count = json["count"] as? Int else {
            return nil
        }
        
        guard let datePulled = json["datePulled"] as? Date else {
            return nil
        }
        
        guard let tossId = json["tossId"] as? String else {
            return nil
        }
        
        self.id = id
        self.count = count
        self.datePulled = datePulled
        self.tossId = tossId
    }
    
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        json["count"] = self.count
        json["datePulled"] = formatter.string(from: self.datePulled)
        json["tossId"] = self.tossId
        
        return json
    }
}
