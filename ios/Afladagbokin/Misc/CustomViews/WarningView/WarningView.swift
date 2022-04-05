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

protocol WarningViewDelegate: class{
    
    func hide()
}

class WarningView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
    public weak var delegate: WarningViewDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("WarningView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.viewCircle.layer.cornerRadius = self.viewCircle.frame.size.height/2.0
        self.viewCircle.layer.masksToBounds = true
        lblTitle.font = Fonts.System.bold.of(size: 22)
        lblSubtitle.font = Fonts.System.regular.of(size: 18)
        self.contentView.backgroundColor = .clear
        self.viewContainer.layer.cornerRadius = 5
        self.viewContainer.layer.masksToBounds = true
        self.viewContainer.layer.borderColor = Color.infoBorder.value.cgColor
        self.viewContainer.layer.borderWidth = 1
        self.backgroundColor = .clear
        btnClose.setTitle("LOKA", for: .normal)
        btnClose.titleLabel?.font = Fonts.System.bold.of(size: 18)
        btnClose.setTitleColor(Color.blue.value, for: .normal)
        lblTitle.textColor = Color.blue.value
        lblSubtitle.textColor = Color.lightGrayText.value
    }
    
    func setupAsWarning(title: String, subtitle: String){
        
        lblTitle.text = title
        lblSubtitle.text = subtitle
        self.gradientCleanup()
        let gradientHelper = GradientHelper()
        gradientHelper.addRedGradient(view: viewCircle)
        imgViewWidth.constant = 40
        imgViewHeight.constant = 35
        imgView.image = UIImage(named: "Warning")
        imgView.tintColor = Color.white.value
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func setupAsErrorWith(boat: String){
        
        lblTitle.text = "Úps"
        lblSubtitle.text = "Þú ert ekki skráður skiptjóri á þessum bát, þú ert skráður á " + boat
        
        self.gradientCleanup()
        let gradientHelper = GradientHelper()
        gradientHelper.addRedGradient(view: viewCircle)
        imgViewWidth.constant = 40
        imgViewHeight.constant = 35
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func setupAsEncouragement(){
        
        lblTitle.text = "Mjög mikil veiði"
        lblSubtitle.text = "Síðasti sólarhringur hrefur skilað miklum afla frá þessu svæði, endilega skellið út nokkrum netum hér."
        self.gradientCleanup()
        let gradientHelper = GradientHelper()
        gradientHelper.addGreenGradient(view: viewCircle)
        imgViewWidth.constant = 33
        imgViewHeight.constant = 34
        self.imgView.image = Asset.thumbsUp.image
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
    }

    @IBAction func btnCloseTapped(_ sender: Any) {
        self.delegate?.hide()
    }
    
}
