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

class CheckboxCell: UITableViewCell {
    
    
    @IBOutlet weak var imgEqType: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var cImgWidth: NSLayoutConstraint!
    @IBOutlet weak var cImgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgArrow: UIImageView!
    var viewModel: CheckboxCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithViewModel(_ viewModel: CheckboxCellViewModel){
        
        self.viewModel = viewModel

        if let vM = self.viewModel{
            cImgWidth.constant = vM.getImageDimensionsFromType(viewModel.type.value.baseType).width
            cImgHeight.constant = vM.getImageDimensionsFromType(viewModel.type.value.baseType).height
            //self.contentView.setNeedsLayout()
            //self.contentView.layoutIfNeeded()
        }
        
        lblTime.textColor = Color.blue.value
        lblDetail.textColor = Color.lightGrayText.value
        lblDetail.font = .systemFont(ofSize: 14, weight: .regular)
        lblDetail.numberOfLines = 0
        lblDetail.text = viewModel.detailText.value
        lblDetail.lineBreakMode = .byWordWrapping
        btnCheck.layer.cornerRadius = 3
        btnCheck.layer.masksToBounds = true
        btnCheck.layer.borderWidth = 1
        setupBindings()
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.15;
        self.selectionStyle = .none
    }
    
    func setupBindings(){
        
        
        _ = self.viewModel?.isSelected.observeNext{ [weak self] value in
            let isSelected = value
            
            if isSelected {
                self?.btnCheck.layer.borderColor = Color.custom(hexString: "87C93E", alpha: 1.0).value.cgColor
                self?.btnCheck.backgroundColor = Color.custom(hexString: "87C93E", alpha: 1.0).value
                self?.btnCheck.setImage(Asset.checkMark.image, for: .normal)
                self?.btnCheck.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            } else {
                self?.btnCheck.backgroundColor = .clear
                self?.btnCheck.layer.borderColor = Color.lightGrayText.value.cgColor
            }
            //value ? self?.btnCheck.setImage(Asset.checkBoxOn.image, for: .normal) : self?.btnCheck.setImage(Asset.checkBoxOff.image, for: .normal)
        }
        
        _ = btnCheck.reactive.tap.observeNext{ [weak self] _ in
            Haptic.light()
            self?.viewModel?.btnTap()
        }
        
        _ = self.viewModel?.combinedInitialDate.observeNext{ [weak self] value in
            
            self?.lblTime.text = value
        }
        
        _ = self.viewModel?.detailText.observeNext{ [weak self] value in
            
            //self?.lblDetail.text = value
        }
        
        if let image = self.viewModel?.type.value.baseType.img{
            
            imgEqType.image = image
        }
        
        _ = self.viewModel?.isCheckVisible.observeNext{ [weak self] value in
            
            if value{
                self?.imgArrow.alpha = 0
                self?.btnCheck.alpha = 1
            }
            else{
                self?.imgArrow.alpha = 1
                self?.btnCheck.alpha = 0
            }
        }
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
