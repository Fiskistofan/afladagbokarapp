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

class BtnYesNoSwitch: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var lblRight: UILabel!
    @IBOutlet weak var lblLeft: UILabel!
    var viewModel: BtnYesNoSwitchViewModel?
    @IBOutlet weak var constraintLeadingSlider: NSLayoutConstraint!
    let viewColorOffset: CGFloat = 7.5
    let animationDuration: Double = 0.25
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("BtnYesNoSwitch", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        lblDescription.styleAsTableDescription()
        
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = Color.cellSeperator.value.cgColor
        lblRight.text = "Já"
        lblLeft.text = "Nei"
        lblRight.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        lblLeft.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        lblRight.textColor = Color.blue.value
        lblLeft.textColor = Color.white.value
        
        viewRight.backgroundColor = .clear
        viewLeft.backgroundColor = .clear
        viewContainer.layer.cornerRadius = viewContainer.frame.size.height/2.0
        viewContainer.layer.masksToBounds = true
        viewSlider.backgroundColor = Color.redGradientStart.value
        viewSlider.layer.cornerRadius = viewSlider.frame.size.height/2.0
        lblRight.backgroundColor = .clear
        lblLeft.backgroundColor = .clear
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(changeToRight))
        viewRight.isUserInteractionEnabled = true
        viewRight.addGestureRecognizer(tapRec)
        
        let tapRecSleppt = UITapGestureRecognizer(target: self, action: #selector(changeToLeft))
        viewLeft.isUserInteractionEnabled = true
        viewLeft.addGestureRecognizer(tapRecSleppt)
        lblDescription.text = "Hrognkelsanet?"
    }
    
    @objc func changeToLeft(){
        self.viewModel?.changeToLeft()
    }
    
    @objc func changeToRight(){
        self.viewModel?.changeToRight()
    }
    
    func setTitle(title: String){
        lblDescription.text = title
    }
    
    func setupBindings(){
        
        
        _ = self.viewModel?.leftEnabled.observeNext{ [weak self] value in
            
            if value{
                
                self?.lblLeft.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
                self?.lblRight.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                self?.lblRight.textColor = Color.blue.value
                self?.lblLeft.textColor = Color.white.value
                UIView.animate(withDuration: (self?.animationDuration)!, animations: {
                    self?.viewSlider.backgroundColor = Color.redGradientStart.value
                    self?.constraintLeadingSlider.constant = 0
                    self?.contentView.setNeedsLayout()
                    self?.contentView.layoutIfNeeded()
                })
                
            }
            else{
                self?.lblLeft.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                self?.lblRight.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
                self?.lblRight.textColor = Color.white.value
                self?.lblLeft.textColor = Color.blue.value
                UIView.animate(withDuration: (self?.animationDuration)!, animations: {
                    self?.constraintLeadingSlider.constant = (self?.viewLeft.frame.size.width)! - (self?.viewColorOffset)!
                    self?.viewSlider.backgroundColor = Color.blue.value
                    self?.contentView.setNeedsLayout()
                    self?.contentView.layoutIfNeeded()
                })
            }
        }
    }

}
