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

class GradientHelper{
    
    func addGradientTo(view: UIView, frame: CGRect, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint){
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addGradientTo(view: UIView, frame: CGRect, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint, locations: [NSNumber]){
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = locations
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addErrorGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [Color.redGradientButtonStart.value.cgColor, Color.redGradientButtonEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.53, y: -0.72)
        gradient.endPoint = CGPoint(x: 0.59, y: 1.45)
        gradient.locations = [0.0, 1] as [NSNumber]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addOKGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view.frame.size.height)
        gradient.colors = [Color.greenStart.value.cgColor, Color.greenEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.52, y: -0.61)
        gradient.endPoint = CGPoint(x: 0.52, y: 1.35)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addStartTripGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.greenGradientStart.value.cgColor, Color.greenGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addEndTripGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.redBtnGradientStart.value.cgColor, Color.redBtnGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addRedGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.darkRedGradientStart.value.cgColor, Color.darkRedGradientMid.value.cgColor, Color.darkRedGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.53, y: -0.72)
        gradient.endPoint = CGPoint(x: 0.59, y: 1.45)
        gradient.locations = [0, 0.027350556, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addGreenGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.greenThumbGradientStart.value.cgColor, Color.greenThumbGardientEnd.value.cgColor, Color.darkRedGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addYellowGradient(view: UIView){
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.yellowGradientStart.value.cgColor, Color.yellowGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.37, y: -0.23)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func addBlueGradient(view: UIView) {
        
        //start = UIColor(red:0.25, green:0.46, blue:0.75, alpha:1).cgColor,
        //end = UIColor(red:0.09, green:0.27, blue:0.51, alpha:1).cgColor
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [Color.blueButtonGradientStart.value.cgColor, Color.blueButtonGradientEnd.value.cgColor]
        gradient.startPoint = CGPoint(x: 0.37, y: -0.23)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
}
