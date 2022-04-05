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

struct RestrictedZone: JSONInitable {
    let id: Int
    let coordinates: [Coordinate]
    let from: Date
    let to: Date
    let fishingGear: [String]
    let name: String
    let officialDescription: String
    let reason: String
    let species: [String]
    
    
    init?(json: JSON) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let id = json["id"] as? Int else {
            print("Could not find key ´id´ in RestrictedZone")
            return nil
        }
        
        guard let coordinates = json["coordinates"] as? [JSON] else {
            print("Could not find key ´coordinates´ in RestrictedZone")
            return nil
        }
        
        guard let fromString = json["dateFrom"] as? String, let from = formatter.date(from: fromString) else {
            print("Could not find key ´dateFrom´ in RestrictedZone")
            return nil
        }
        
        guard let toString = json["dateTo"] as? String, let to = formatter.date(from: toString) else {
            print("Could not find key ´dateTo´ in RestrictedZone")
            return nil
        }
        
        guard let fishingGear = json["fishingGear"] as? [String] else {
            print("Could not find key ´fishingGear´ in RestrictedZone")
            return nil
        }
        
        guard let name = json["name"] as? String else {
            print("Could not find key ´name´ in RestrictedZone")
            return nil
        }
        
        guard let officialDescription = json["officialDescription"] as? String else {
            print("Could not find key ´officialDescription´ in RestrictedZone")
            return nil
        }
        
        guard let reason = json["reason"] as? String else {
            print("Could not find key ´reason´ in RestrictedZone")
            return nil
        }
        
        guard let species = json["species"] as? [String] else {
            print("Could not find key ´officialDescription´ in RestrictedZone")
            return nil
        }
        
        self.id = id
        self.coordinates = coordinates.flatMap { Coordinate(json: $0) }
        self.from = from
        self.to = to
        self.fishingGear = fishingGear
        self.name = name
        self.officialDescription = officialDescription
        self.reason = reason
        self.species = species
    }
}

