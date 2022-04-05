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

class Pull: JSONInitable, Fridjonable {
    let id: String
    var tossId: String
    let date: Date
    var count: Int
    var catches: [Catch]
    var weightLogged: Int?
    var lastWeightLogDate: Date?
    
    var hasBeenLogged: Bool
    
    init(tossId: String, count: Int = 1, catches: [Catch] = [], hasBeenLogged: Bool = false) {
        self.id = UUID().uuidString
        self.tossId = tossId
        self.date = Date()
        self.count = count
        self.catches = catches
        self.hasBeenLogged = hasBeenLogged
    }
    
    required init?(json: JSON) {
        guard let id = json["id"] as? String else {
            print("Could not find key ´id´ in Pull")
            return nil
        }
        
        guard let tossId = json["tossId"] as? String else {
            print("Could not find key ´tossId´ in Pull")
            return nil
        }
        
        guard let date = json["date"] as? Date else {
            print("Could not find key ´date´ in Pull")
            return nil
        }
        
        guard let count = json["count"] as? Int else {
            print("Could not find key ´count´ in Pull")
            return nil
        }
        
        guard let catches = json["catches"] as? [JSON] else {
            print("Could not find key ´catches´ in Pull")
            return nil
        }
        
        guard let hasBeenLogged = json["hasBeenLogged"] as? Bool else {
            print("Could not find key ´hasBeenLogged´ in Pull")
            return nil
        }
        
        if let logDate = json["lastWeightLogDate"] as? Date{
            self.lastWeightLogDate = logDate
        }
        
        self.id = id
        self.tossId = tossId
        self.date = date
        self.count = count
        self.catches = catches.flatMap { Catch(json: $0) }
        self.hasBeenLogged = hasBeenLogged
    }
}

extension Pull {
    func addCatch(_ _catch: Catch) {
        catches.append(_catch)
    }
}


extension Pull: JSONReturnable {
    func toJSON() -> JSON {
        var dict: [String: Any] = [:]
        
        dict["id"] = self.id
        dict["tossId"] = self.tossId
        dict["date"] = self.date
        dict["count"] = self.count
        dict["catches"] = self.catches.map { $0.toJSON() }
        dict["hasBeenLogged"] = self.hasBeenLogged
        dict["lastWeightLogDate"] = self.lastWeightLogDate
        
        return dict
    }
}

