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

typealias localization = String
extension localization {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: languageBundle(),  comment: self)
    }
    
    
    func localized(withComment comment: String) -> String{
        return NSLocalizedString(self, tableName: nil, bundle: languageBundle(),  comment: comment)
    }
    
    
    func languageBundle() -> Bundle{
        
        let preferredLanguages = NSLocale.preferredLanguages
        
        if preferredLanguages.isEmpty == false{
            return Bundle(path: Bundle.main.path(forResource: preferredLanguages.first, ofType: "lproj")!)!
        }
        
        return Bundle(path: Bundle.main.path(forResource: "is", ofType: "lproj")!)!
    }
}

extension NSAttributedString {
    
    /*
     * Styles a part of a string
     */
    class func styleText(text: NSString, boldText: NSString..., font: UIFont!, boldFont: UIFont!, underline: Bool, color: UIColor?) -> NSAttributedString {
        
        let nonBoldFontAttribute = [NSAttributedStringKey.font:font!]
        let boldFontAttribute = [NSAttributedStringKey.font:boldFont!]
        let underlineAttribute = [NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
        
        let boldString = NSMutableAttributedString(string: text as String, attributes:nonBoldFontAttribute)
        
        for bold in boldText{
            
            boldString.addAttributes(boldFontAttribute, range: text.range(of: bold as String))
            
            if underline == true{
                boldString.addAttributes(underlineAttribute, range: text.range(of: bold as String))
            }
            
            if let color = color{
                let colorAttr = [NSAttributedStringKey.foregroundColor : color]
                boldString.addAttributes(colorAttr, range: text.range(of: bold as String))
            }
        }
        
        return boldString
    }
}
