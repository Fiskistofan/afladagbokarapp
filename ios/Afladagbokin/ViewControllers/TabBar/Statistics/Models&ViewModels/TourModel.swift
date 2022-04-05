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

struct TourModel{

    static let idKey = "id"
    static let landingPortNameKey = "landingPortName"
    static let dateLandedKey = "dateLanded"
    static let weightKey = "weight"
    
    public var id: Int = 0
    public var landingPort = ""
    public var dateLanded = ""
    public var weight: Int = 0
}

extension TourModel: JSONInitable{
    
    init?(json: JSON) {
        let formatter = DateFormatter.init(withFormat: "yyyy-MM-dd'T'HH:mm:ss", locale: "is_IS")
        
        guard let id = json[TourModel.idKey] as? Int else{
            return nil
        }
        
        guard let landingPortName = json[TourModel.landingPortNameKey] as? String else {
            return nil
        }
        guard let dateLanded = json[TourModel.dateLandedKey] as? String, let date = formatter.date(from: dateLanded) else {
            return nil
        }
        guard let weight = json[TourModel.weightKey] as? Int else{
            return nil
        }
        
        formatter.dateFormat = "dd. MMMM yyyy"
        
        self.id = id
        self.landingPort = landingPortName
        self.dateLanded = formatter.string(from: date)
        self.weight = weight
    }
}
