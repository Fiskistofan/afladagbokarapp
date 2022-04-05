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
import CoreLocation


class Net: Toss, JSONInitable, Fridjonable {
    let id: String
    
    let date: Date
    let coordinates: CLLocationCoordinate2D
    let type: EquipmentType
    let tossCount: Int
    var pulls: [Pull]
    let initialPulls: Int
    
    var hasBeenLogged: Bool
    
    init(coordinates: CLLocationCoordinate2D, type: EquipmentType, tossCount: Int, pulls: [Pull] = [], initialPulls: Int = 0, hasBeenLogged: Bool = false) {
        self.id = UUID().uuidString
        self.date = Date()
        self.coordinates = coordinates
        self.type = type
        self.tossCount = tossCount
        self.pulls = pulls
        self.initialPulls = initialPulls
        self.hasBeenLogged = hasBeenLogged
    }
    
    required init?(json: JSON) {
        guard let id = json["id"] as? String else {
            print("Could not find key ´id´ in Net")
            return nil
        }
        
        guard let date = json["date"] as? Date else {
            print("Could not find key ´date´ in Net")
            return nil
        }
        
        guard let typeId = json["type"] as? Int, let type = EquipmentType(rawValue: typeId) else {
            print("Could not find key ´type´ in Net")
            return nil
        }
        
        guard let tossCount = json["tossCount"] as? Int else {
            print("Could not find key ´tossCount´ in Net")
            return nil
        }
        
        guard let latitude = json["latitude"] as? Double else {
            print("Could not find key ´latitude´ in Net")
            return nil
        }
        
        guard let longitude = json["longitude"] as? Double else {
            print("Could not find key ´longitude´ in Net")
            return nil
        }
        
        guard let pulls = json["pulls"] as? [JSON] else {
            print("Could not find key ´pulls´ in Net")
            return nil
        }
        
        guard let hasBeenLogged = json["hasBeenLogged"] as? Bool else {
            print("Could not find key ´hasBeenLogged´ in Net")
            return nil
        }
        
        self.id = id
        self.date = date
        self.type = type
        self.tossCount = tossCount
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.pulls = pulls.flatMap { Pull(json: $0) }
        self.initialPulls = json["pulledCount"] as? Int ?? 0
        self.hasBeenLogged = hasBeenLogged
    }
}

extension Net: JSONReturnable {
    func toJSON() -> JSON {
        var dict: [String: Any] = [:]
        
        dict["id"] = self.id
        dict["date"] = self.date
        dict["latitude"] = self.coordinates.latitude
        dict["longitude"] = self.coordinates.longitude
        dict["type"] = self.type.rawValue
        dict["tossCount"] = self.tossCount
        dict["pulls"] = self.pulls.map { $0.toJSON() }
        dict["pulledCount"] = self.initialPulls
        dict["hasBeenLogged"] = self.hasBeenLogged
        
        return dict
    }
}
