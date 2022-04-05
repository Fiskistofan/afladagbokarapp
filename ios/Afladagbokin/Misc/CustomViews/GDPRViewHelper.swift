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

class GDPRHelper{
    
    let animationDuration = 1.0
    let gdprView: ConfirmTourView
    let windowView: UIView
    let window: UIWindow
    
    init(withGDPRResponseDelegate delegate: ConfirmTourViewDelegate){
        
        gdprView = ConfirmTourView(frame: CGRect(x: 20, y: 110, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height))
        gdprView.delegate = delegate
        
        window = UIApplication.shared.delegate!.window as! UIWindow
        windowView = UIView(frame: window.frame)
    }
    
    func setupViews(){
        gdprView.setupForGDPR()
        gdprView.alpha = 0
        
        windowView.backgroundColor = Color.blueHeader.withAlpa(0.5)
        window.addSubview(windowView);
    }
    
    func showGDPRDialog(){
        windowView.addSubview(gdprView)
        UIView.animate(withDuration: animationDuration) {
            self.gdprView.alpha = 1
        }
    }
    
    func removeDialog(){
        windowView.removeFromSuperview()
    }
    
    func showWithError(){
        gdprView.setupForGDPRWithError()
    }
    
    func saveGDPR(policyID: Int, policyURL: String){
        
        let sessionManager = Session.manager
        sessionManager.saveGDPRPolicyID(id: policyID)
        sessionManager.saveGDPRPolicyURL(url: policyURL)
    }
}
