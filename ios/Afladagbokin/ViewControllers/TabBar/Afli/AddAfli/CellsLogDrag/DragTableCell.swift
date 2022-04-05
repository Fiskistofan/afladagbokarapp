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

class DragTableCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblAnimal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(title: String, type: ControllerType){
        
        lbl.text = title
        lbl.textColor = Color.blue.value
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .light)
        lbl.textColor = Color.blue.value
        let image = Asset.blueArrowRight.image.withRenderingMode(.alwaysTemplate)
        imgView.image = image
        imgView.tintColor = Color.blue.value
        lblAnimal.styleForAnimalCell()
        if type == .animals{
            hideTime()
        }
        else{
            hideAnimal()
        }
    }
    
    func setup(){
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.15;
        self.selectionStyle = .none
    }
    
    func hideAnimal(){
        //stackView.alpha = 0
        lblAnimal.alpha = 0
    }
    
    func hideTime(){
        lbl.alpha = 0
    }
    
    func applyImageForType(type: Animal){
        
        lblAnimal.isHidden = false
        lblAnimal.styleForAnimalCell()
        lbl.isHidden = true
        let image = Asset.blueArrowRight.image.withRenderingMode(.alwaysTemplate)
        imgView.image = image
        imgView.tintColor = Color.blue.value
        
        switch type {
        case .fish:
            let fishImage = UIImageView(image: Asset.fish.image)
            fishImage.contentMode = .scaleAspectFit
            lblAnimal.text = Texts.fish
            
            stackView.addArrangedSubview(fishImage)
        case .mammalsAndBirds:
            let birdImage = UIImageView(image: Asset.bird.image)
            birdImage.contentMode = .right
            let mamalImage = UIImageView(image: Asset.mammal.image)
            mamalImage.contentMode = .left
            lblAnimal.text = Texts.birdsAndMammals
            
            stackView.addArrangedSubview(birdImage)
            stackView.addArrangedSubview(mamalImage)
        }
        

        
        
        //self.contentView.setNeedsLayout()
        //self.contentView.layoutIfNeeded()
    }
    
    func applyGradient(){
        let gradientHelper = GradientHelper()
        let rectGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 194)
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
