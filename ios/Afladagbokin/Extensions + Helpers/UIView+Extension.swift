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

extension UIView{
    
    func addGradientToHeader(){
        
        let gradientHelper = GradientHelper()
        
        let numberStart = NSNumber(value: 0)
        let numberEnd = NSNumber(value: 1)
        
        gradientHelper.addGradientTo(view: self, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height), colors: [Color.blueHeaderGradientStart.value.cgColor, Color.blueHeaderGradientEnd.value.cgColor], startPoint: CGPoint(x: 0.5, y: -2.07), endPoint: CGPoint(x: 0.5, y: 1), locations: [numberStart, numberEnd])
    }
    
    func addGradientWith(colors: [CGColor], positions: [Int]){
        
        let gradientHelper = GradientHelper()
        gradientHelper.addGradientTo(view: self, frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.frame.size.height), colors: colors, startPoint: CGPoint(x: 0.5, y: -2.07), endPoint: CGPoint(x: 0.5, y: 1))
    }
    
    func styleForGradientButton(){
        
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.layer.masksToBounds = true
    }
    
    func styleAsTextContainer(){
        
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.18).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 15
        self.backgroundColor = UIColor(red:0.13, green:0.28, blue:0.45, alpha:1)
        self.clipsToBounds = true
    }
    
    func styleWith(backgroundColor: UIColor, cornerRad: CGFloat) {
        
        let view = self
        view.backgroundColor = backgroundColor
        
        guard cornerRad != 0.0 else {
            return
        }
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRad
    }
    
    func gradientCleanup(){
        for layer in self.layer.sublayers!{
            if layer is CAGradientLayer{
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func rotateToOriginal(){
        self.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    func rotateByMinus90(){
        self.transform = CGAffineTransform(rotationAngle: -(.pi / 2))
    }
}
