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
import StokkurUtls

protocol ConfirmTourViewDelegate: class {
    func confirmTourViewDidFinishWithConfirm(_ confirmTourView: ConfirmTourView)
    func confirmDragLog(_ confirmTourView: ConfirmTourView)
    func confirmTourViewDidFinishWithCancel(_ confirmTourView: ConfirmTourView)
}


class ConfirmTourView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrompt: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    var isForLogging: Bool = false
    @IBOutlet weak var cHeightWhiteBox: NSLayoutConstraint!
    @IBOutlet weak var cBotTextToMid: NSLayoutConstraint!
    weak var delegate: ConfirmTourViewDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ConfirmTourView", owner: self, options: nil)
        style()
    }
    
    private func style() {
        let gradientHelper = GradientHelper()
        
        self.backgroundColor = .clear
        self.alpha = 0
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .clear
        self.addSubview(contentView)
        
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width/2.0
        imageContainerView.layer.masksToBounds = true
        gradientHelper.addBlueGradient(view: imageContainerView)
        imgView.image = UIImage(named: "Start")
        imgView.tintColor = Color.white.value
        
        labelContainerView.layer.cornerRadius = 5
        labelContainerView.backgroundColor = Color.white.value
        
        lblTitle.font = Fonts.System.bold.of(size: 22)
        lblTitle.textColor = Color.blue.value
        lblTitle.text = "Ljúka veiðum"
        
        _ = [lblPrompt, lblConfirm].map {
            $0?.font = Fonts.System.regular.of(size: 18);
            $0?.textColor = Color.lightGrayText.value
        }
        
        lblPrompt.text = "Vilt þú ljúka veiðum og skila inn aflaskráningu?"
        lblConfirm.text = "Það er ekki hægt að breyta skráningu eftir að þú hefur skilað inn áætlaðum afla."
        
        _ = [btnConfirm, btnCancel].map {
            $0?.layer.cornerRadius = 5
            $0?.layer.shadowOffset = CGSize.zero
            $0?.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor
            $0?.layer.shadowOpacity = 1
            $0?.layer.shadowRadius = 15
            $0?.layer.masksToBounds = true
            $0?.titleLabel?.textAlignment = .center
            $0?.titleLabel?.font = Fonts.System.bold.of(size: 16)
            $0?.setTitleColor(Color.white.value, for: .normal)
        }
        
        btnConfirm.setTitle("LJÚKA VEIÐUM", for: .normal)
        btnCancel.setTitle("HÆTTA VIÐ", for: .normal)
        
        gradientHelper.addGradientTo(view: btnConfirm,
                                     frame: CGRect(x: 0, y:0, width: btnConfirm.bounds.width, height: 64),
                                     colors: [Color.greenVeidifaeriStart.value.cgColor,
                                              Color.greenVeidifaeriEnd.value.cgColor],
                                     startPoint: CGPoint(x: 0.4, y: -0.29),
                                     endPoint: CGPoint(x: 0.4, y: 1.91))
        gradientHelper.addGradientTo(view: btnCancel,
                                     frame: CGRect(x: 0, y:0, width: btnCancel.bounds.width, height: 64),
                                     colors: [Color.redVeidifaeriStart.value.cgColor, Color.redVeidifaeriMid.value.cgColor,
                                              Color.redVeidifaeriEnd.value.cgColor],
                                     startPoint:CGPoint(x: 0.53, y: -0.72),
                                     endPoint: CGPoint(x: 0.59, y: 1.45))
        isForLogging = false
    }
    
    func setupForLogView(){
        
        lblPrompt.text = ""
        lblConfirm.text = "Viltu skrá aflann núna?"
        lblTitle.text = "Aflaskráning"
        btnConfirm.setTitle("Já", for: .normal)
        btnCancel.setTitle("Nei", for: .normal)
        isForLogging = true
    }
    
    func setupForGDPR(){
        
        setupGDPRLabels()
        setupGDPRButtons()
        cHeightWhiteBox.constant = 300
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setupGDPRLabels(){
        lblTitle.text = Texts.GDPR_SUBTITLE
        lblConfirm.font = Fonts.System.regular.of(size: 15);
        lblPrompt.text = Texts.GDPR_MSG
        lblPrompt.numberOfLines = 0
        lblPrompt.font = Fonts.System.regular.of(size: 15);
        lblConfirm.text = ""
        cBotTextToMid.constant = 10
        lblConfirm.numberOfLines = 0
        lblConfirm.minimumScaleFactor = 0.5
        lblConfirm.adjustsFontSizeToFitWidth = true
    }
    
    func setupGDPRButtons(){
        btnConfirm.setTitle(Texts.GDPR_READ_MORE_BTN, for: .normal)
        btnCancel.setTitle(Texts.GDPR_ACCEPT_BTN, for: .normal)
        removeGradients()
        DispatchQueue.main.after(when: 0.1) {
            
            
            let gradientHelper = GradientHelper()
            gradientHelper.addGradientTo(view: self.btnCancel,
                                         frame: CGRect(x: 0, y:0, width: self.btnCancel.bounds.width, height: 64),
                                         colors: [Color.greenVeidifaeriStart.value.cgColor,
                                                  Color.greenVeidifaeriEnd.value.cgColor],
                                         startPoint: CGPoint(x: 0.4, y: -0.29),
                                         endPoint: CGPoint(x: 0.4, y: 1.91))
            
            gradientHelper.addGradientTo(view: self.btnConfirm,
                                         frame: CGRect(x: 0, y:0, width: self.btnConfirm.bounds.width, height: 64),
                                         colors: [Color.blueVeidifaeriStart.value.cgColor,
                                                  Color.blueVeidifaeriEnd.value.cgColor],
                                         startPoint:CGPoint(x: 0.53, y: -0.72),
                                         endPoint: CGPoint(x: 0.59, y: 1.45))
            self.btnConfirm.clipsToBounds = true
            self.btnCancel.clipsToBounds = true
        }
    }
    
    func setupForGDPRWithError(){
        
        UIView.transition(with: lblConfirm,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.lblConfirm.text = Texts.GDPR_ERROR
        }) { _ in }
    }
    
    func removeGradients(){
        
        guard let layers = self.btnCancel.layer.sublayers else { return }
        guard let layersConfirm = self.btnConfirm.layer.sublayers else { return }
        for layer in layers{
            guard let caLayer = layer as? CAGradientLayer else { continue }
            caLayer.removeFromSuperlayer()
        }
        for layer in layersConfirm{
            guard let caLayer = layer as? CAGradientLayer else { continue }
            caLayer.removeFromSuperlayer()
        }
    }
}


// MARK: - Button Action Handle
extension ConfirmTourView {
    @IBAction func didClickConfirm(_ sender: Any) {
        if isForLogging{
            delegate?.confirmDragLog(self)
        }
        else{
            delegate?.confirmTourViewDidFinishWithConfirm(self)
        }
    }
    
    @IBAction func didClickCancel(_ sender: Any) {
        delegate?.confirmTourViewDidFinishWithCancel(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}




