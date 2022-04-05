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

class ButtonCell: UITableViewCell {

    @IBOutlet weak var lblEnabled: UILabel!
    @IBOutlet weak var lblDisabled: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewSwitch: UIView!
    var viewModel: BtnCellViewModel? = nil
    @IBOutlet weak var subViewSleppt: UIView!
    @IBOutlet weak var subViewLandad: UIView!
    @IBOutlet weak var viewBackgroundWithColor: UIView!
    let animationDuration: Double = 0.25
    let viewColorOffset: CGFloat = 7.5
    @IBOutlet weak var cTrailing: NSLayoutConstraint!
    @IBOutlet weak var cLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(viewModel: BtnCellViewModel){
    
        self.viewModel = viewModel
        lblTitle.styleAsTableDescription()
        setupSwitch()
        setupBindings()
    }
    
    func setupSwitch(){
        
        viewSwitch.layer.borderWidth = 1
        viewSwitch.layer.borderColor = Color.cellSeperator.value.cgColor
        
        subViewLandad.backgroundColor = .clear
        subViewSleppt.backgroundColor = .clear
        viewSwitch.layer.cornerRadius = viewSwitch.frame.size.height/2.0
        viewSwitch.layer.masksToBounds = true
        lblEnabled.backgroundColor = .clear
        lblDisabled.backgroundColor = .clear
        
        viewBackgroundWithColor.backgroundColor = Color.redGradientStart.value
        viewBackgroundWithColor.layer.cornerRadius = viewBackgroundWithColor.frame.size.height/2.0
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(changeToEnabled))
        subViewLandad.isUserInteractionEnabled = true
        subViewLandad.addGestureRecognizer(tapRec)
        
        let tapRecSleppt = UITapGestureRecognizer(target: self, action: #selector(changeToDisabled))
        subViewSleppt.isUserInteractionEnabled = true
        subViewSleppt.addGestureRecognizer(tapRecSleppt)
        
        
        
        guard let viewModel = self.viewModel else{
            return
        }
        
        switch viewModel.type {
        case .gutted:
            lblTitle.text = "Slægður?"
        case .sleppt:
            lblTitle.text = "Sleppt eða landað?"
        case .undirmal:
            lblTitle.text = "Er aflinn undirmál?"
        }
    }
    
    @objc func changeToEnabled(){
        self.viewModel?.changeToEnabled()
    }
    
    @objc func changeToDisabled(){
        self.viewModel?.changeToDisabled()
    }
    
    func setupBindings(){
        
        guard let viewModel = self.viewModel else{
            return
        }
        _ = self.viewModel?.btnLeftText.bind(to: lblDisabled.reactive.text)
        _ = self.viewModel?.btnRightText.bind(to: lblEnabled.reactive.text)
        
        _ = viewModel.isBtnSelected.observeNext{ [weak self] value in
            
            guard let this = self else{
                return
            }
            
            if value{
                
                this.lblDisabled.font = Fonts.System.regular.of(size: 18)
                this.lblEnabled.font = Fonts.System.bold.of(size: 18)
                this.lblDisabled.textColor = Color.blue.value
                this.lblEnabled.textColor = Color.white.value
                UIView.animate(withDuration: (self?.animationDuration)!, animations: {
                    this.viewBackgroundWithColor.backgroundColor = Color.blue.value
                    this.cLeading.priority = .defaultLow
                    this.cTrailing.priority = .defaultHigh
                    this.contentView.setNeedsLayout()
                    this.contentView.layoutIfNeeded()
                })
            }
            else{
                this.lblDisabled.font = Fonts.System.bold.of(size: 18)
                this.lblEnabled.font = Fonts.System.regular.of(size: 18)
                this.lblDisabled.textColor = Color.white.value
                this.lblEnabled.textColor = Color.blue.value
                UIView.animate(withDuration: (self?.animationDuration)!, animations: {
                    self?.viewBackgroundWithColor.backgroundColor = Color.redGradientStart.value
                    this.cLeading.priority = .defaultHigh
                    this.cTrailing.priority = .defaultLow
                    self?.contentView.setNeedsLayout()
                    self?.contentView.layoutIfNeeded()
                })
            }
        }
    }
}

extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}
