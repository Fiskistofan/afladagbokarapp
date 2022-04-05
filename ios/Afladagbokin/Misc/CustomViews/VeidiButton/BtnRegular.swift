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

class BtnRegular: UIView {

    @IBOutlet var contentView: UIButton!
    @IBOutlet weak var imgFromTop: NSLayoutConstraint!
    @IBOutlet weak var cImgWidth: NSLayoutConstraint!
    @IBOutlet weak var cImgHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var cLblToImg: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    

    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("BtnRegular", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        lblTitle.textColor = Color.white.value
        if UIDevice.current.iPhoneX{
            lblTitle.font = Fonts.System.bold.of(size: 13)
            
        }
        else{
            lblTitle.font = Fonts.System.bold.of(size: 11)
        }

        
    }
    
    public func setupAsRegular(){
        self.imgView.tintColor = Color.lightGrayText.value
        contentView.backgroundColor = .clear
        lblTitle.text = "Veiðar"
        lblTitle.textColor = Color.blue.value
        setIconToStartFishing()
        
//        if UIDevice.current.iPhoneX{
            imgFromTop.constant = 7.333333
            cLblToImg.constant = 48
//        }
//        else{
//            imgFromTop.constant = 3
//            cImgWidth.constant = 30
//            cImgHeight.constant = 30
//            cLblToImg.constant = 35.33333
//        }
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    public func setupAsRed(){

        setIconToStopFishing()
        lblTitle.text = "Ljúka veiðum"
        self.imgView.tintColor = Color.white.value
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        if UIDevice.current.iPhoneX{
            imgFromTop.constant = 10
            cLblToImg.constant = 53
        }
        else{
            imgFromTop.constant = 10
            cLblToImg.constant = 53
        }
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    public func setupAsGreen(){
        setIconToStartFishing()
        lblTitle.text = "Hefja veiðar"
        lblTitle.textColor = Color.white.value
        self.imgView.tintColor = Color.white.value
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        if UIDevice.current.iPhoneX{
            imgFromTop.constant = 6.333333
            cLblToImg.constant = 53
        }
        else{
            imgFromTop.constant = 14
            cLblToImg.constant = 53
        }
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func setIconToStartFishing(){
        imgView.image = Asset.start.image
        cImgWidth.constant = 34
        cImgHeight.constant = 34
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
    
    func setIconToStopFishing(){
        imgView.image = Asset.stop.image
        cImgWidth.constant = 31
        cImgHeight.constant = 31
        contentView.setNeedsLayout()
        contentView.layoutIfNeeded()
    }
}
