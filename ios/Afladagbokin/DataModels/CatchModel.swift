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

struct CatchModel {
    let id: String
    var pullId: String!
    let gutted: Bool
    let released: Bool
    let smallFish: Bool
    let weight: Double
    let speciesId: Int
    let type: Int
}

extension CatchModel {
    init(_catch: Catch) {
        self.id = _catch.id
        self.pullId = _catch.pullId
        self.gutted = _catch.gutted
        self.released = _catch.released
        self.smallFish = _catch.smallFish
        self.weight = _catch.weight
        self.speciesId = _catch.speciesId
        self.type = _catch.type
    }
}

extension CatchModel: JSONInitable, JSONReturnable {
    init?(json: JSON) {
        guard let id = json["id"] as? String else {
            print("Could not find key ´id´ in Catch")
            return nil
        }
        
        guard let pullId = json["pullId"] as? String else {
            print("Could not find key ´pullId´ in Catch")
            return nil
        }
        
        guard let gutted = json["gutted"] as? Bool else {
            print("Could not find key ´gutted´ in Catch")
            return nil
        }
        
        guard let released = json["released"] as? Bool else {
            print("Could not find key ´released´ in Catch")
            return nil
        }
        
        guard let smallFish = json["smallFish"] as? Bool else {
            print("Could not find key ´smallFish´ in Catch")
            return nil
        }
        
        guard let weight = json["weight"] as? Double else {
            print("Could not find key ´weight´ in Catch")
            return nil
        }
        
        guard let speciesId = json["speciesId"] as? Int else {
            print("Could not find key ´speciesId´ in Catch")
            return nil
        }
        
        guard let type = json["type"] as? Int else {
            print("Could not find key ´type´ in Catch")
            return nil
        }
        
        self.id = id
        self.pullId = pullId
        self.gutted = gutted
        self.released = released
        self.smallFish = smallFish
        self.weight = weight
        self.speciesId = speciesId
        self.type = type
    }
    
    
    func toJSON() -> JSON {
        var dict: [String: Any] = [:]
        
        dict["pullId"] = self.pullId
        
        switch self.type {
        case 0:
            dict["weight"] = self.weight
            dict["fishSpeciesId"] = self.speciesId
            dict["gutted"] = self.gutted
            dict["released"] = self.released
            dict["smallFish"] = self.smallFish
        case 1:
            dict["otherSpeciesId"] = self.speciesId
            dict["count"] = Int(self.weight)
        default:
            break
        }
        
        return dict
    }
}
