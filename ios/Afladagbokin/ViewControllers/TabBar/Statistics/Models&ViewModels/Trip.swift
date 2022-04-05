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
import UIKit

struct Trip{
    
    static let nameKey = "name"
    static let landingPortNameKey = "landingPortName"
    static let dateLanededKey = "dateLanded"
    static let weightKey = "weight"
    
    var name = ""
    var landingPort = ""
    var dateLanded = ""
    var weight: CGFloat = 0
}

extension Trip: JSONInitable{
    
    init?(json: JSON) {
        guard let name = json[Trip.nameKey] as? String else{
            return nil
        }
        guard let landingPort = json[Trip.landingPortNameKey] as? String else{
            return nil
        }
        guard let dateLanded = json[Trip.landingPortNameKey] as? String else{
            return nil
        }
        guard let weight = json[Trip.landingPortNameKey] as? Double else{
            return nil
        }
        
        self.name = name
        self.landingPort = landingPort
        self.dateLanded = dateLanded
        self.weight = CGFloat(weight)
    }
}
