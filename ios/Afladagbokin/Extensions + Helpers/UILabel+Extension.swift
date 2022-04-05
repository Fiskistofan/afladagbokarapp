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

extension UILabel{
    
    func styleAsTitle(){
        
        self.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.textColor = .white
    }
    
    func styleForAnimalCell(){
        
        self.textColor = Color.blue.value
        self.font = UIFont.systemFont(ofSize: 31, weight: .light)
    }
    
    func styleAsTableDescription(){
        
        self.textColor = Color.blue.value
        self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    func styleAsBoxLabelActive(){
        
        self.textColor = Color.blue.value
        self.backgroundColor = Color.white.value
        self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    func styleAsBoxLabelInActive(){
        
        self.textColor = Color.lightGrayText.value
        self.backgroundColor = Color.grayBackground.value
        self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    func addLineSpacingWithText(linespace: CGFloat, textString: String, alignment: NSTextAlignment){
        
        let attrText = NSMutableAttributedString(string: textString)
        let textRange = NSRange(location: 0, length: attrText.length)
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = linespace
        attrText.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
        self.attributedText = attrText
    }
    
    func styleAsStatsStatic(){
        
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.textColor = Color.blueStatsColor.value
    }
    
    func styleAsStats(){
        self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        self.textColor = Color.lightGrayText.value
    }
    
    func styleAsLoggedFish(){
        
        self.textColor = Color.blackText.value
        self.font = Fonts.System.regular.of(size: 18)
    }
    
    func styleAsLoggedWeight(){
        
        self.textColor = Color.blue.value
        self.font = Fonts.System.bold.of(size: 18)
    }
    
    func styleAsCustomLabel(withText text: String, font: UIFont, color: UIColor){
        
        self.styleWith(backgroundColor: .clear, cornerRad: 0)
        self.font = font
        self.text = text
        self.textColor = color
    }
    
    
    func styleAsCustomLabel(with font: UIFont, color: UIColor){
        
        self.styleWith(backgroundColor: .clear, cornerRad: 0)
        self.font = font
        self.textColor = color
    }
}
