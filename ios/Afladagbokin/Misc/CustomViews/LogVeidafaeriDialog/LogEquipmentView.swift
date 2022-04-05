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

protocol LogEquipmentTxtDelegate: class{
    
    func textDidChange(text: String)
}

class LogEquipmentView: UIView{
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet public weak var txtField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    public weak var delegate: LogEquipmentTxtDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("LogEquipmentView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        txtField.keyboardType = .numberPad
        txtField.font = Fonts.System.regular.of(size: 50)
        txtField.textColor = Color.blue.value
        self.viewCircle.layer.cornerRadius = self.viewCircle.frame.size.height/2.0
        self.viewCircle.layer.masksToBounds = true
        lblTitle.font = Fonts.System.bold.of(size: 22)
        lblTitle.textColor = Color.blue.value
        self.contentView.backgroundColor = .clear
        self.viewContainer.layer.cornerRadius = 5
        self.viewContainer.layer.masksToBounds = true
        self.backgroundColor = .clear
        txtField.delegate = self
        txtField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        txtField.keyboardAppearance = .dark
    }
    
    func setupForNet(){
        
        lblTitle.text = "Hversu mörg net?"
        imgView.image = Asset.net.image
    }
}

extension LogEquipmentView: UITextFieldDelegate{
    
    @objc func textFieldDidChange(textField: UITextField){
        
        if let txt = textField.text{
            self.delegate?.textDidChange(text: txt)
        }
    }
}
