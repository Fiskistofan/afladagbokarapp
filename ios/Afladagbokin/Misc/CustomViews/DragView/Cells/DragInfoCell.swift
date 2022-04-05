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

class DragInfoCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        style()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    fileprivate func style() {
        // Set self
        self.layer.borderWidth = 1
        self.layer.borderColor = Color.infoBorder.value.cgColor
        self.backgroundColor = .clear
        
        // Set date label
        lblDate.textColor = Color.white.value
        lblDate.font = Fonts.System.bold.of(size: 14)
        
        // Set count label
        lblCount.textColor = Color.white.value
        lblCount.font = Fonts.System.regular.of(size: 14)
    }
}


extension DragInfoCell {
    func populateView(toss: Toss) {
        lblDate.text = toss.date.toString()
        
        if let lina = toss as? Lina {
            lblCount.text = "Önglar: \(lina.onglaCount) - Bjóð: \(lina.bjodaCount)"
        }
        
        if let net = toss as? Net {
            lblCount.text = "Fjöldi neta: \(net.remainingTosses())/\(net.tossCount)"
        }
        
        if let handfaeri = toss as? Handfaeri {
            lblCount.text = "Fjöldi handfæra: \(handfaeri.remainingTosses())/\(handfaeri.tossCount)"
        }
    }
}
