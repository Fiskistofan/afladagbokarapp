// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/*
 * Returns the app assets through the image property
 */
enum Asset: String {
    
    //MARK: - Application
    case bird               = "Bird"
    case bookLarge          = "Book-Large"
    case book               = "Book"
    case redArrrowBack      = "Caret-Back-red"
    case whiteArrowLeft     = "Caret-Left"
    case blueArrowRight     = "Caret-right-blue"
    case catchIcon          = "Catch"
    case error              = "Error"
    case fish               = "Fish"
    case fishHook           = "FishingHook"
    case logo               = "Logo"
    case mammal             = "Mammal"
    case map                = "Map"
    case more               = "More"
    case net                = "Net"
    case shapeArrowRed      = "Shape"
    case start              = "Start"
    case statistics         = "Statistics"
    case stop               = "Stop"
    case thumbsUp           = "ThumbsUp"
    case statisticsTab      = "StatisticsTab"
    case boats              = "Boats"
    case fishingLine        = "FishingLine"
    case shapeDown          = "ShapeDown"
    case checkMark          = "Check"
    case checkBoxOff        = "CheckboxOFF"
    case checkBoxOn         = "CheckboxON"
    case smallCheckOff      = "CheckboxSmallOFF"
    case smallCheckOn       = "CheckboxSmallON"
    case greenCheck         = "GreenCheck"
    case anchor             = "Anchor"
    case iceland            = "Iceland"
    case onboarding1        = "Onboarding1"
    case onboarding2        = "Onboarding2"
    case onboarding3        = "Onboarding3"
    case onboarding4        = "Onboarding4"
    case onboarding5        = "Onboarding5"
    case background         = "Background"
    
    
    var image: UIImage {
        return UIImage(asset: self)
    }
}

extension UIImage {
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
