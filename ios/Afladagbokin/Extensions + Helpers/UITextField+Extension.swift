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

extension UITextField{
    
    func styleAsTableCellTextField(placeholderText: String){
        
        self.backgroundColor = .white
        self.textColor = Color.blue.value
        self.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                               attributes: [NSAttributedStringKey.foregroundColor: Color.lightGrayText.value, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)])
        
        self.backgroundColor = UIColor.white
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.1).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.addPaddingLeft(25)
        self.keyboardType = .numberPad
        self.keyboardAppearance = .dark
    }
    
    func styleForLogin(){
        
        self.keyboardAppearance = .dark
        self.keyboardType = .phonePad
        self.textColor = .white
        self.placeholder = Texts.phoneNr
        self.setPlaceHolderTextColor(Color.white.value)
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 22)
    }
}
