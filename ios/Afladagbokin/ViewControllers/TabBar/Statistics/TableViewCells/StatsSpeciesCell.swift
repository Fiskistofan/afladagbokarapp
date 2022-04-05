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

class StatsSpeciesCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    var strColor: String = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func setupWith(species: String, amount: String, strColor: String){
        
        self.strColor = strColor
        styleCell()
        lblAmount.text = amount + " kg"
        lbl.text = species
    }
    
    func setupWith(speciesName: String, count: String){
        
        self.strColor = "#000000"
        styleCell()
        lblAmount.text = count + " stk"
        lbl.text = speciesName
    }
    
    func styleCell(){
        
        self.lbl.textColor = Color.blackText.value
        self.lblAmount.textColor = Color.lightGrayText.value
        
        self.lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.lblAmount.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        self.viewColor.layer.cornerRadius = self.viewColor.frame.size.height/2.0
        let color = UIColor(hexString: self.strColor).withAlphaComponent(CGFloat(1))
        self.viewColor.backgroundColor = color
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5    
    }
}
