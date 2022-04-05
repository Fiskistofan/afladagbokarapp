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
import ReactiveKit
import Bond

protocol DateBtnCellDelegate: class{
    
    func didSelectDate()
}

class DateBtnCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    public weak var delegate: DateBtnCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        self.delegate?.didSelectDate()
    }
    
    func setup(){
        
        btn.styleAsSave()
        for layer in btn.layer.sublayers!{
            if layer is CAGradientLayer{
                layer.removeFromSuperlayer()
            }
        }

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: self.btn.frame.size.height )
        gradient.colors = [Color.lightGreenGradientStart.value.cgColor, Color.lightGreenGradientEnd.value.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.4, y: -0.29)
        gradient.endPoint = CGPoint(x: 0.4, y: 1.91)
        gradient.cornerRadius = 5
        btn.layer.insertSublayer(gradient, at: 0)
        btn.setTitle("SKOÐA TÍMABIL", for: .normal)
        self.selectionStyle = .none
    }
    
}
