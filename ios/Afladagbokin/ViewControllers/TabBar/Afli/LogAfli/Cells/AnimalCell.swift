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

class AnimalCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var cImgWidth: NSLayoutConstraint!
    @IBOutlet weak var cImgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgArrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(title: String, selectable: Bool){
        
        lblTitle.textColor = Color.blue.value
        lblTitle.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        lblTitle.text = title
        viewSep.backgroundColor = Color.cellSeperator.value
        if !Session.manager.getIsLoggedAfliFish(){
            self.imgView.image = Asset.mammal.image
        }
        
        if selectable {
            let image = Asset.blueArrowRight.image.withRenderingMode(.alwaysTemplate)
            imgArrow.image = image
            imgArrow.tintColor = Color.blue.value
        } else {
            imgArrow.image = nil
        }
    }
    
}
