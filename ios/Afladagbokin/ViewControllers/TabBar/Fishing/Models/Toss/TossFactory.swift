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

struct TossFactory {
    static func fromJSON(_ json: JSON) -> Toss? {
        guard let typeId = json["type"] as? Int, let type = EquipmentType(rawValue: typeId) else {
            return nil
        }
        
        switch type.baseType {
        case .lina: return Lina(json: json)
        case .net: return Net(json: json)
        case .handfaeri: return Handfaeri(json: json)
        }
    }
    
    static func fromTossModel(_ tossModel: TossesModel) -> Toss? {
        let session = Session.manager
        var tossModelJSON = tossModel.toJSON()
        var json: JSON = [:]
        
        guard let equipmentId = tossModelJSON["equipmentId"] as? Int, let type = EquipmentType(rawValue: equipmentId) else {
            return nil
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateString = tossModelJSON["dateTime"] as! String
        
        json["id"] = tossModelJSON["id"] as? String
        json["date"] = formatter.date(from: dateString)
        json["latitude"] = tossModelJSON["latitude"] as? Double
        json["longitude"] = tossModelJSON["longitude"] as? Double
        json["type"] = equipmentId
        json["tossCount"] = tossModelJSON["count"] as? Int
        json["pulls"] = []
        json["hasBeenLogged"] = true
        json["pulledCount"] = tossModelJSON["pulledCount"] as? Int
        
        switch type.baseType {
        case .lina:
            json["onglaCount"] = session.getOnglaCount()
            json["bjodaCount"] = session.getBjodaCount()
        case .net, .handfaeri:
            break
        }
        
        return fromJSON(json)
    }
}

