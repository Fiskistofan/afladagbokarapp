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

struct TossesModel{
    
    static let idKey = "id"
    static let dateTimeKey = "datetime"
    static let countKey = "count"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let tourIdKey = "tourId"
    static let pulledCountKey = "pulledCount"
    static let equipmentIdKey = "equipmentTypeId"
    
    public var id = ""
    public var dateTime = ""
    public var count = 0
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var tourId = 0
    public var pulledCount = 0
    public var equipmentId = 0
}

extension TossesModel: JSONInitable, JSONReturnable {
    
    init?(json: JSON) {
        
        guard let id = json[TossesModel.idKey] as? String else{
            return nil
        }
        guard let dateTime = json[TossesModel.dateTimeKey] as? String else{
            return nil
        }
        guard let count = json[TossesModel.countKey] as? Int else{
            return nil
        }
        guard let latitude = json[TossesModel.latitudeKey] as? Double else{
            return nil
        }
        guard let longitude = json[TossesModel.longitudeKey] as? Double else{
            return nil
        }
        guard let tourId = json[TossesModel.tourIdKey] as? Int else{
            return nil
        }
        guard let pulledCount = json[TossesModel.pulledCountKey] as? Int else{
            return nil
        }
        guard let equipmentId = json[TossesModel.equipmentIdKey] as? Int else {
            return nil
        }
        
        self.id = id
        self.dateTime = dateTime
        self.count = count
        self.latitude = latitude
        self.longitude = longitude
        self.tourId = tourId
        self.pulledCount = pulledCount
        self.equipmentId = equipmentId
    }
    
    func toJSON() -> JSON {
        var json: JSON = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        json["id"] = self.id
        json["dateTime"] = self.dateTime
        json["latitude"] = self.latitude
        json["longitude"] = self.longitude
        json["count"] = self.count
        json["pulledCount"] = self.pulledCount
        json["tourId"] = self.tourId
        json["equipmentId"] = self.equipmentId
        
        return json
    }
}
