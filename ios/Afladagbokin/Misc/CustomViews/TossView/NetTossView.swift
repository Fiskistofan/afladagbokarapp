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

protocol NetTossViewDelegate: class {
    func netTossViewDidFinishWithInput(_ netTossView: NetTossView, netCount: Int)
}

class NetTossView: TossView {
    weak var delegate: NetTossViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lblPromt.text = "Hversu mörg net?"
        imgEquipment.image = Asset.net.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func doneButtonAction() {
        guard let input = txtfldInput.text, let number = Int(input) else {
            return
        }
        
        txtfldInput.resignFirstResponder()
        delegate?.netTossViewDidFinishWithInput(self, netCount: number)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
