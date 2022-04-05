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

enum Color {
    
    case whiteBgVCColor
    case green
    case white
    case blue
    case blueHeader
    case lightBlue
    case lightGrayText
    case blueButtonGradientStart
    case blueButtonGradientEnd
    case blueHeaderGradientStart
    case blueHeaderGradientEnd
    case redArrowBack
    case lightGrayBackground
    case cellSeperator
    case redGradientStart
    case redGradientEnd
    case greenGradientStart
    case greenGradientEnd
    case grayBackground
    case redGradientButtonStart
    case redGradientButtonMid
    case redGradientButtonEnd
    case blueStatsColor
    case statsSeperator
    case blackText
    case authenticationGradientStart
    case authenticationGradientEnd
    case authGradientStart
    case authGradientEnd
    case whiteStatsColor
    case lightGreenGradientStart
    case lightGreenGradientEnd
    case errorRed
    case errorRedStart
    case errorRedMid
    case errorRedEnd
    case greenStart
    case greenEnd
    case gradientGreenStart
    case gradientGreenEnd
    case redBtnGradientStart
    case redBtnGradientEnd
    case darkRedGradientStart
    case darkRedGradientMid
    case darkRedGradientEnd
    case greenThumbGradientStart
    case greenThumbGardientEnd
    case yellowGradientStart
    case yellowGradientEnd
    case placeholderColor
    case greenVeidifaeriStart
    case greenVeidifaeriEnd
    case redVeidifaeriStart
    case redVeidifaeriMid
    case redVeidifaeriEnd
    case blueVeidifaeriStart
    case blueVeidifaeriEnd
    case redCloseButton
    case infoBorder
    case infoBackground
    case brownWarning
    case custom(hexString: String, alpha: Double)
    
    func withAlpa(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
    
    var value: UIColor {
        
        var color = UIColor.clear
        
        switch self {
            
        case .green:
            color = UIColor(red:0.88, green:0.44, blue:0.22, alpha:1)
        case .white:
            color = .white
        case .blue:
            color = UIColor(red:0.2, green:0.33, blue:0.5, alpha:1)
        case .blueHeader:
            color = UIColor(red:0.13, green:0.21, blue:0.32, alpha:1)
        case .lightBlue:
            color = UIColor(red:0.09, green:0.27, blue:0.51, alpha:1)
        case .lightGrayText:
            color = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1)
        case .blueButtonGradientStart:
            color = UIColor(red:0.25, green:0.46, blue:0.75, alpha:1)
        case .blueButtonGradientEnd:
            color = UIColor(red:0.09, green:0.27, blue:0.51, alpha:1)
        case .blueHeaderGradientStart:
            color = UIColor(red:0.27, green:0.4, blue:0.54, alpha:1)
        case .blueHeaderGradientEnd:
            color = UIColor(red:0.13, green:0.21, blue:0.32, alpha:1)
        case .redArrowBack:
            color = UIColor(red:0.72, green:0.23, blue:0.25, alpha:1)
        case .cellSeperator:
            color = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1)
        case .redGradientEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .redGradientStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .greenGradientStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .greenGradientEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .grayBackground:
            color = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1)
        case .redGradientButtonStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .redGradientButtonMid:
            color = UIColor(red:0.74, green:0.25, blue:0.35, alpha:1)
        case .redGradientButtonEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .statsSeperator:
            color = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1)
        case .blueStatsColor:
            color = UIColor(red:0.28, green:0.46, blue:0.7, alpha:1)
        case .blackText:
            color = UIColor(red:0.05, green:0.14, blue:0.25, alpha:1)
        case .authenticationGradientStart:
            color = UIColor(red:0.13, green:0.28, blue:0.45, alpha:1)
        case .authenticationGradientEnd:
            color = UIColor(red:0.05, green:0.14, blue:0.25, alpha:1)
        case .authGradientStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .authGradientEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .lightGreenGradientStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .lightGreenGradientEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .whiteStatsColor:
            color = UIColor(red: 251.0/256.0, green: 251.0/256.0, blue: 251.0/256.0, alpha: 1)
        case .lightGrayBackground:
            color = UIColor(hexString: "FBFBFB")
        case .errorRed:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .errorRedStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .errorRedMid:
            color = UIColor(red:0.74, green:0.25, blue:0.35, alpha:1)
        case .errorRedEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .greenStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .greenEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .gradientGreenStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .gradientGreenEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .redBtnGradientStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .redBtnGradientEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .darkRedGradientStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .darkRedGradientMid:
            color = UIColor(red:0.74, green:0.25, blue:0.35, alpha:1)
        case .darkRedGradientEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .greenThumbGardientEnd:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .greenThumbGradientStart:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .yellowGradientStart:
            color = UIColor(red:0.93, green:0.94, blue:0.26, alpha:1)
        case .yellowGradientEnd:
            color = UIColor(red:0.93, green:0.87, blue:0.11, alpha:1)
        case .whiteBgVCColor:
            color = UIColor(red: 251.0/255.0, green: 251.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        case .placeholderColor:
            color = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1)
        case .greenVeidifaeriStart:
            color = UIColor(red:0.71, green:0.93, blue:0.32, alpha:1)
        case .greenVeidifaeriEnd:
            color = UIColor(red:0.26, green:0.58, blue:0.13, alpha:1)
        case .redVeidifaeriStart:
            color = UIColor(red:0.75, green:0.25, blue:0.35, alpha:1)
        case .redVeidifaeriMid:
            color = UIColor(red:0.74, green:0.25, blue:0.35, alpha:1)
        case .redVeidifaeriEnd:
            color = UIColor(red:0.51, green:0.09, blue:0.27, alpha:1)
        case .blueVeidifaeriStart:
            color = UIColor(red:0.27, green:0.4, blue:0.54, alpha:1)
        case .blueVeidifaeriEnd:
            color = UIColor(red:0.13, green:0.21, blue:0.32, alpha:1)
        case .redCloseButton:
            color = UIColor(red:0.89, green:0.08, blue:0.12, alpha:1)
        case .infoBorder:
            color = UIColor(red:0.3, green:0.5, blue:0.73, alpha:1)
        case .infoBackground:
            color = UIColor(red:0.05, green:0.14, blue:0.25, alpha:1)
        case .brownWarning:
            color = UIColor(red:0.36, green:0.34, blue:0.07, alpha:1)
        case .custom(let hexValue, let opacity):
            color = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return color
    }
}
