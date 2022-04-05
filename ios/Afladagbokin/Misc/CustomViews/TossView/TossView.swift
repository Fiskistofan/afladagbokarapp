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


class TossView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewLblContainer: UIView!
    @IBOutlet weak var lblPromt: UILabel!
    @IBOutlet weak var txtfldInput: UITextField!
    @IBOutlet weak var viewImgContainer: UIView!
    @IBOutlet weak var imgEquipment: UIImageView!
    
    var confirmationButton: UIBarButtonItem!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("TossView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewLblContainer.layer.borderColor = Color.infoBorder.value.cgColor
        viewLblContainer.layer.borderWidth = 1
        style()
    }

    
    fileprivate func style() {
        // Set self
        self.backgroundColor = .clear
        self.alpha = 0
        
        // Set contentView
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .clear
        
        // Set labelContainer
        viewLblContainer.layer.cornerRadius = 5
        viewLblContainer.backgroundColor = Color.white.value
        
        //Set imageContainer
        viewImgContainer.layer.cornerRadius = viewImgContainer.frame.size.height/2.0
        viewImgContainer.layer.masksToBounds = true
        viewImgContainer.backgroundColor = Color.grayBackground.value
        
        // Set prompt
        lblPromt.font = Fonts.System.bold.of(size: 22)
        lblPromt.textColor = Color.blue.value
        
        // Set input
        txtfldInput.font = Fonts.System.light.of(size: 62)
        txtfldInput.textColor = Color.blueStatsColor.value
        txtfldInput.borderStyle = .none
        txtfldInput.keyboardType = .numberPad
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "LEGGJA", style: .done, target: self, action: #selector(self.doneButtonAction))
        self.confirmationButton = done
        
        done.tintColor = Color.blue.value
        done.isEnabled = false
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        txtfldInput.inputAccessoryView = doneToolbar
        txtfldInput.becomeFirstResponder()
        
        // Set image
        imgEquipment.contentMode = .scaleAspectFit
        
        txtfldInput.keyboardAppearance = .dark
    }
    
    
    @IBAction func editingChanged(_ sender: Any) {
        guard let input = txtfldInput.text, let number = Int(input) else {
            confirmationButton.isEnabled = false
            return
        }
        
        confirmationButton.isEnabled = number > 0 ? true : false
    }
    
    @objc func doneButtonAction()
    {

    }
}
