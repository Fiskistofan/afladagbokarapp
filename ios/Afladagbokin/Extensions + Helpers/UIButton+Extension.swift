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

extension UIButton{
    
    func styleAsVeidifaeri(){
        
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.layer.masksToBounds = true
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = Fonts.System.bold.of(size: 16)
        self.setTitleColor(Color.white.value, for: .normal)
        self.titleLabel?.numberOfLines = 2
    }
    
    func styleAsBack(){
        
        let image = Asset.shapeArrowRed.image
        self.setImage(image, for: .normal)
        self.setTitle(Texts.bakka, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.setTitleColor(Color.white.value, for: .normal)
    }
    
    func styleAsSave(){
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        self.setTitleColor(Color.white.value, for: .normal)
        self.layer.cornerRadius = 5
        self.backgroundColor = Color.greenGradientEnd.value
        self.setTitle(Texts.save, for: .normal)
        
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.05).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
    }
    
    func styleAsNewSMS(){
        
        self.layer.cornerRadius = 5.0
        self.backgroundColor = .white
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.setTitleColor(Color.blue.value, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        self.alpha = 0
    }
    
    func styleAsCheckbox(){
        
        self.layer.cornerRadius = 5.0
        self.alpha = 0.5
        self.layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [Color.authGradientStart.value.cgColor, Color.authGradientEnd.value.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.28, y: -0.13)
        gradient.endPoint = CGPoint(x: 0.8, y: 1.12)
        gradient.cornerRadius = 5.0
        self.layer.insertSublayer(gradient, at: 0)
        self.setImage(Asset.checkMark.image, for: .normal)
        self.bringSubview(toFront: self.imageView!)
        self.backgroundColor = Color.authGradientStart.value
    }
}
