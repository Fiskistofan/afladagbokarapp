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

class EquipmentCell: UITableViewCell {

    @IBOutlet weak var imgViewEq: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cImgEqHeight: NSLayoutConstraint!
    @IBOutlet weak var cImgViewEqWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var lblSelectedEquipment: UILabel!
    
    
    //MARK: Init
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


//MARK: Common setup
extension EquipmentCell{
    
    func commonSetup(){
        // TITLE
        lblTitle.font = Fonts.System.regular.of(size: 20)
        lblTitle.textColor = Color.blue.value
        
        // ARROW
        imgViewArrow.image = Asset.blueArrowRight.image
        
        // SELECTEDEQUIPMENT
        lblSelectedEquipment.isHidden = true
        lblSelectedEquipment.font = Fonts.System.regular.of(size: 12)
        lblSelectedEquipment.textColor = Color.lightGrayText.value
        lblSelectedEquipment.text = "Skráð á þennan bát"
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
}

//MARK: Type setup
extension EquipmentCell{
    
    fileprivate func setupAsNet(){
        
        imgViewEq.image = Asset.net.image
        cImgViewEqWidth.constant = 50
        cImgEqHeight.constant = 50
    }
    
    func setupAsSkotuselsNet(){
        
        lblTitle.text = "Skötuselsnet"
        setupAsNet()
        commonSetup()
    }
    
    func setupAsTorskNet(){
        
        lblTitle.text = "Þorksfisknet"
        setupAsNet()
        commonSetup()
    }
    
    func setupAsGrasleppunet(){
        
        lblTitle.text = "Grásleppunet"
        setupAsNet()
        commonSetup()
    }
    
    func setupAsRaudmaganet(){
        lblTitle.text = "Rauðmaganet"
        setupAsNet()
        commonSetup()
    }
    
    func setupAsLina(){
        removeGradient()
        applyGradient()
        lblTitle.text = "Lína"
        imgViewEq.image = Asset.fishingLine.image
        cImgViewEqWidth.constant = 24
        cImgEqHeight.constant = 64
        commonSetup()
    }
    
    func setupAsLandbeittLina(){
        
        setupAsLina()
        lblTitle.text = "Landbeitt Lína"
    }
    
    func setupAsLinutrekt(){
        setupAsLina()
        lblTitle.text = "Línutrekt"
    }
    
    func setupAsHandfaeri(){
        lblTitle.text = "Handfæri"
        imgViewEq.image = Asset.fishHook.image
        cImgViewEqWidth.constant = 30
        cImgEqHeight.constant = 48
        commonSetup()
    }
    
    func setupAsSelected() {
        lblSelectedEquipment.isHidden = false
    }
    
}

//MARK: Gradient
extension EquipmentCell{
    
    func applyGradient(){
        let gradientHelper = GradientHelper()
        let rectGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 135)
        gradientHelper.addGradientTo(view: self.contentView, frame: rectGradient, colors: [UIColor.white.cgColor, Color.lightGrayBackground.value.cgColor], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    }
    
    func removeGradient(){
        for layer in self.contentView.layer.sublayers!{
            
            if layer.isKind(of: CAGradientLayer.self){
                layer.removeFromSuperlayer()
            }
        }
    }
}
