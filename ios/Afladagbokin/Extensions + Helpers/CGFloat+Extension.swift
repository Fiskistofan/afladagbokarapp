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
import StokkurUtls

extension CGFloat {
    
    /*
     * Returns a random number between min and max
     */
    public func randomnessBetween(min: CGFloat, max: CGFloat) -> CGFloat{
        return min + CGFloat(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func scaleFactor() -> CGFloat {
        
        let screenType = Utls.screenType()
        
        switch screenType {
        case .iPhone4ScreenSize: return self * 0.8
        case .iPhone5ScreenSize: return self * 0.85
        case .iPhone6ScreenSize: return self * 1.0
        case .iPhone6PScreenSize, .iPhone7PScreenSize: return self * 1.1
        default: return self * 1.0
        }
    }
}
