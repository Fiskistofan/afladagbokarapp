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

class HarborCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWith(name: String){
        
        lblTitle.font = Fonts.System.regular.of(size: 19)
        lblTitle.textColor = Color.blue.value
        lblTitle.text = name
        clipsToBounds = true
        layer.masksToBounds = true
        selectionStyle = .none
    }
    
    func applyGradient(height: CGFloat){
//        let gradientHelper = GradientHelper()
//        let rectGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
//        gradientHelper.addGradientTo(view: self.contentView, frame: rectGradient, colors: [UIColor.white.cgColor, Color.lightGrayBackground.value.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    }
    
    func removeGradient(){
//        for layer in self.contentView.layer.sublayers!{
//            if layer.isKind(of: CAGradientLayer.self){
//                layer.removeFromSuperlayer()
//            }
//        }
    }
    
}
