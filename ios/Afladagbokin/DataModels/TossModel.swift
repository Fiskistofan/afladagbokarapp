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

struct TossModel {
    let id: String
    let dateTime: Date
    let latitude: Double
    let longitude: Double
    let count: Int
    let tourId: Int
}


extension TossModel {
    init(tourId: Int, toss: Toss) {
        self.id = toss.id
        self.dateTime = toss.date
        self.latitude = toss.coordinates.latitude
        self.longitude = toss.coordinates.longitude
        self.count = toss.tossCount
        self.tourId = tourId
    }
}


extension TossModel: JSONInitable, JSONReturnable {
    init?(json: JSON) {
        guard let id = json["id"] as? String else {
            return nil
        }
        
        guard let dateTime = json["dateTime"] as? Date else {
            return nil
        }
        
        guard let latitude = json["latitude"] as? Double else {
            return nil
        }
        
        guard let longitude = json["longitude"] as? Double else {
            return nil
        }
        
        guard let count = json["count"] as? Int else {
            return nil
        }
        
        guard let tourId = json["tourId"] as? Int else {
            return nil
        }
        
        self.id = id
        self.dateTime = dateTime
        self.latitude = latitude
        self.longitude = longitude
        self.count = count
        self.tourId = tourId
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        json["dateTime"] = formatter.string(from: self.dateTime)
        json["latitude"] = self.latitude
        json["longitude"] = self.longitude
        json["count"] = self.count
        
        return json
    }
}
