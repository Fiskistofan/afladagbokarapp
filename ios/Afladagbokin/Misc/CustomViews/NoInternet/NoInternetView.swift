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

protocol NoInternetViewDelegate:class{
    func close()
}

class NoInternetView: UIView {
    enum SuccessType {
        case net(pulled: Int, total: Int)
        case lina
        case handfaeri(pulled: Int, total: Int)
    }
    

    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgX: UIImageView!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    public weak var delegate: NoInternetViewDelegate?
    @IBOutlet weak var cTextToTopSView: NSLayoutConstraint!
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("NoInternetView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setupAsErrorWithText(errorText: String){

        cTextToTopSView.constant = 80
        self.gradientCleanup()
        applyErrorGradient()
        lblMsg.textColor = Color.white.value
        btnOk.backgroundColor = Color.white.value
        btnOk.setTitleColor(Color.errorRed.value, for: .normal)
        btnOk.titleLabel?.font = Fonts.System.bold.of(size: 18)
        btnOk.isHidden = false
        lblMsg.font = Fonts.System.regular.of(size: 18)
        imgWidth.constant = 28
        imgHeight.constant = 28
        imgX.isHidden = true
        lblMsg.text = errorText
        self.contentView.clipsToBounds = true
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func setupAsGreenViewWith(successType: SuccessType) {

        cTextToTopSView.constant = 95
        self.clipsToBounds = true
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.layer.mask = rectShape
        
        btnOk.backgroundColor = Color.white.value
        btnOk.setTitleColor(Color.errorRed.value, for: .normal)
        btnOk.titleLabel?.font = Fonts.System.bold.of(size: 18)
        btnOk.isHidden = true
        lblMsg.font = Fonts.System.regular.of(size: 18)
        lblMsg.textColor = Color.white.value
        imgWidth.constant = 33
        imgWidth.constant = 34
        imgX.isHidden = false
        imgX.image = Asset.thumbsUp.image

        switch successType {
        case let .net(count, total):
            let mismatch = total - count
            let text1 = total > 1 ? "veiðarfærum voru dregin" : "veiðarfæri var dregið"
            let text2 = mismatch == 1 ? "er" : "eru"
            lblMsg.text = "\(count) af \(total) \(text1).\nÞað \(text2) \(mismatch) eftir í þessari lögn."
        case let .handfaeri(count, total):
            let mismatch = total - count
            let text1 = total > 1 ? "veiðarfærum voru dregin" : "veiðarfæri var dregið"
            let text2 = mismatch == 1 ? "er" : "eru"
            lblMsg.text = "\(count) af \(total) \(text1).\nÞað \(text2) \(mismatch) eftir í þessari lögn."
        case .lina:
            lblMsg.text = "Lína dregin."
        }
        
        self.gradientCleanup()
        self.applyOkGradient()

        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func applyErrorGradient(){
        
        let gradientHelper = GradientHelper()
        gradientHelper.addErrorGradient(view: self)
    }
    
    func applyOkGradient(){
        let gradientHelper = GradientHelper()
        gradientHelper.addOKGradient(view: self)
    }
    
    @IBAction func btnOkClicked(_ sender: Any) {
        self.delegate?.close()
    }
    

}
