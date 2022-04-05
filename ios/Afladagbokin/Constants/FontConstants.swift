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
 * Used to support font size variations of users using the iOS system.
 */
enum TextStyle: String {
    
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 25pt		  | 26pt  | 27pt   | 28pt  | 30pt   | 32pt    | 34pt
     */
    case title1
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 19pt		  | 20pt  | 21pt   | 22pt  | 24pt   | 26pt    | 28pt
     */
    case title2
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 17pt		  | 18pt  | 19pt   | 20pt  | 22pt   | 24pt    | 26pt
     */
    case title3
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 14pt		  | 15pt  | 16pt   | 17pt  | 19pt   | 21pt    | 23pt
     */
    case headline
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 12pt		  | 13pt  | 14pt   | 15pt  | 17pt   | 19pt    | 21pt
     */
    case subheadline
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 14pt		  | 15pt  | 16pt   | 17pt  | 19pt   | 21pt    | 23pt
     */
    case body
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 13pt		  | 14pt  | 15pt   | 16pt  | 18pt   | 20pt    | 22pt
     */
    case callout
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 12pt		  | 12pt  | 12pt   | 13pt  | 15pt   | 17pt    | 19pt
     */
    case footnote
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 11pt		  | 11pt  | 11pt   | 12pt  | 14pt   | 16pt    | 18pt
     */
    case caption1
    /*
     * Sizes: Extra small | Small | Medium | Large | xLarge | xxLarge | xxLarge
     * Value: 11pt		  | 11pt  | 11pt   | 11pt  | 13pt   | 15pt    | 17pt
     */
    case caption2
    
    
    var rawValue: String {
        let capitalizedString = "\(self)".capitalized
        return "UICTFontTextStyle\(capitalizedString)"
    }
}



protocol Fontable {
    var name: String { get }
    func of(style: TextStyle) -> UIFont
    func of(size: CGFloat) -> UIFont
}

extension Fontable {
    func of(style: TextStyle) -> UIFont {
        let style = style.rawValue
        let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle(rawValue: style))
        var size = font.pointSize.scaleFactor()
        let maximumSize = 24.0 as CGFloat
        if size > maximumSize { size = maximumSize }
        return UIFont(name: self.name , size: size)!
    }
    
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.name, size: size)!
    }
}

/*
 * Handles the font scheme of the app
 */
enum Fonts {
    enum Center: Fontable {
        case bold
        case light
        case medium
        case regular
        case thin
        case halfRegular
        
        var name: String {
            switch self {
            case .bold: return "CenterBold"
            case .light: return "CenterLight"
            case .medium: return "CenterMedium"
            case .regular: return "CenterRegular"
            case .thin: return "CenterThin"
            case .halfRegular: return "GLYPHICONSHalflings-Regular"
            }
        }
    }
    
    enum System: Fontable {
        case bold
        case light
        case medium
        case regular
        case thin
        
        var name: String {
            switch self {
            case .bold: return "SystemBold"
            case .light: return "SystemLight"
            case .medium: return "SystemMedium"
            case .regular: return "SystemRegular"
            case .thin: return "SystemThin"
            }
        }
        
        func of(size: CGFloat) -> UIFont {
            switch self {
            case .bold: return UIFont.systemFont(ofSize: size, weight: .bold)
            case .light: return UIFont.systemFont(ofSize: size, weight: .light)
            case .medium: return UIFont.systemFont(ofSize: size, weight: .medium)
            case .regular: return UIFont.systemFont(ofSize: size, weight: .regular)
            case .thin: return UIFont.systemFont(ofSize: size, weight: .thin)
            }
        }
    }
}

