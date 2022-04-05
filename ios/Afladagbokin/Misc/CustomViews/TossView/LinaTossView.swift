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

protocol LinaTossViewDelegate: class {
    func linaTossViewDidFinishWithInput(_ linaTossView: LinaTossView, onglaCount: Int, bjodarCount: Int)
}

class LinaTossView: TossView {
    weak var delegate: LinaTossViewDelegate?
    
    var inputOption: InputOption = .onglaCount
    var onglaCount = 0
    var bjodarCount = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lblPromt.text = "Hversu margir önglar?"
        imgEquipment.image = Asset.fishingLine.image
        confirmationButton.title = "NÆSTA SKREF"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func doneButtonAction() {
        switch inputOption {
        case .onglaCount:
            linaInputflow()
        case .bjodarCount:
            bjodaInputFlow()
        }
    }
    
    fileprivate func linaInputflow() {
        guard let input = txtfldInput.text, let number = Int(input) else {
            return
        }
        
        self.inputOption = .bjodarCount
        self.onglaCount = number
        lblPromt.text = "Hversu mörg bjóð?"
        confirmationButton.title = "LEGGJA"
        txtfldInput.clear()
    }
    
    fileprivate func bjodaInputFlow() {
        guard let input = txtfldInput.text, let number = Int(input) else {
            return
        }
        
        self.bjodarCount = number
        txtfldInput.resignFirstResponder()
        delegate?.linaTossViewDidFinishWithInput(self, onglaCount: onglaCount, bjodarCount: bjodarCount)
    }
    
    
    // MARK: - InputOption
    enum InputOption {
        case onglaCount
        case bjodarCount
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
