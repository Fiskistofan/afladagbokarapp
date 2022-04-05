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

class TextFieldView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("TextFieldView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        txtField.font = Fonts.System.regular.of(size: 28)
        lblDescription.font = Fonts.System.bold.of(size: 18)
        lblDescription.textColor = Color.blue.value
        contentView.backgroundColor = Color.whiteBgVCColor.value
        lblUnit.font = Fonts.System.regular.of(size: 22)
        txtField.font = Fonts.System.regular.of(size: 28)
        txtField.textColor = Color.blue.value
        txtField.keyboardType = .numberPad
        lblUnit.textColor = Color.placeholderColor.value
        txtField.keyboardAppearance = .dark
    }
    
    func setupAsNet(){
        
        lblDescription.text = "Fjöldi neta"
        lblUnit.text = "net"
        txtField.text = "\(Session.manager.getNetCount())"
    }
    
    func setupAsHeightMoski(){
        lblDescription.text = "Hæð nets"
        lblUnit.text = "möskvar"
        txtField.text = "\(Session.manager.getNetHeight())"
    }
    
    func setupAsSizeMoskvi(){
        
        lblDescription.text = "Stærð möskva"
        lblUnit.text = "mm"
        txtField.text = "\(Session.manager.getNetSize())"
    }
    
    func setupAsOnglar(){
        
        lblDescription.text = "Fjöldi öngla"
        lblUnit.text = "önglar"
        txtField.text = "\(Session.manager.getOnglaCount())"
    }
    
    func setupAsBjodar(){
        
        lblDescription.text = "Fjöldi bjóða"
        lblUnit.text = "bjóð"
        txtField.text = "\(Session.manager.getBjodaCount())"
    }
    
    func setupAsHandfaeri(){
        
        lblDescription.text = "Fjöldi færa"
        lblUnit.text = "handfæri"
        txtField.text = "\(Session.manager.getHandfaeriCount())"
    }

}
