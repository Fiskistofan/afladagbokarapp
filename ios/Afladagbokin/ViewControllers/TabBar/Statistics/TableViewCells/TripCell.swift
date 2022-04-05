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

class TripCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHarbor: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupWith(date: String, name: String, weight: String){
        
        styleCell()
        lblDate.text = date
        lblHarbor.text = name
        lblWeight.text = weight + " kg"
        
    }
    
    func styleCell(){
        
        imgView.image = imgView.image!.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = Color.redArrowBack.value
        lblDate.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        lblHarbor.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        lblWeight.font = UIFont.systemFont(ofSize: 19, weight: .light)
        
        self.selectionStyle = .none
        
        lblDate.textColor = Color.blue.value
        lblHarbor.textColor = Color.blue.value
        lblWeight.textColor = Color.blue.value
        imgView.tintColor = Color.redArrowBack.value
        
        viewContainer.backgroundColor = Color.grayBackground.value.withAlphaComponent(0.53)
        viewContainer.layer.borderColor = Color.lightGrayText.value.cgColor
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.cornerRadius = 5
        viewContainer.layer.masksToBounds = true
    }
    
    
    
}
