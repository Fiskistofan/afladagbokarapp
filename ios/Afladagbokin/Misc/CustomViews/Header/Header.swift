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

protocol HeaderDelegate:class{
    
    func goBack()
    func add()
}


class Header: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblToTop: NSLayoutConstraint!
    @IBOutlet weak var lblTotalWeightStatic: UILabel!
    @IBOutlet weak var lblTotalWeightDynamic: UILabel!
    @IBOutlet weak var lblAmountKg: UILabel!
    var goBackClosure:  ( () -> () )? = nil
    
    public weak var delegate: HeaderDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        Bundle.main.loadNibNamed("Header", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .clear
        lblTitle.textColor = Color.white.value
        btnAdd.titleLabel?.textColor = Color.white.value
        lblToTop.constant = 35
        if UIDevice.current.iPhoneX{
            lblToTop.constant = 45
        }
        lblTotalWeightStatic.font = Fonts.System.regular.of(size: 11)
        lblTotalWeightDynamic.font = Fonts.System.bold.of(size: 16)
        lblAmountKg.font = Fonts.System.regular.of(size: 11)
        lblTotalWeightDynamic.textColor = Color.white.value
        lblTotalWeightStatic.textColor = Color.white.value
        lblAmountKg.textColor = Color.white.value
        lblAmountKg.text = "kg."
        lblTotalWeightDynamic.text = "0"
        lblTotalWeightStatic.text = "Heildarafli:"
        self.addGradientToHeader()
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
    }
    
    func setupWithAddButton(){
        
        lblTitle.text = Texts.dagbok
        lblTitle.styleAsTitle()
        btnBack.isHidden = true
        let gradientHelper = GradientHelper()
        gradientHelper.addGradientTo(view: btnAdd, frame: CGRect(x: 0, y: 0, width: btnAdd.frame.size.width, height: btnAdd.frame.size.height), colors: [Color.blueButtonGradientStart.value.cgColor, Color.blueButtonGradientEnd.value.cgColor], startPoint: CGPoint(x: 0.22, y: 0.01), endPoint: CGPoint(x: 0.67, y: 1), locations: [NSNumber(value:0), NSNumber(value:1)])
        btnAdd.layer.cornerRadius = btnAdd.frame.size.height/2.0
        btnAdd.layer.masksToBounds = true
        btnAdd.backgroundColor = .clear
        lblAmountKg.isHidden = true
        lblTotalWeightDynamic.isHidden = true
        lblTotalWeightStatic.isHidden = true
    }
    
    func setupWithBackButtonOnly(goBackClouse: (() -> ())? = nil){
        
        self.goBackClosure = goBackClouse
        btnAdd.isHidden = true
        btnBack.styleAsBack()
        lblTitle.styleAsTitle()
        btnBack.setTitle(Texts.bakka, for: .normal)
        
        lblAmountKg.isHidden = true
        lblTotalWeightDynamic.isHidden = true
        lblTotalWeightStatic.isHidden = true
    }
    
    func setTitle(title: String){
        
        lblTitle.text = title
    }
    
    func setupWithBackButton(text: String){
        
        btnAdd.isHidden = true
        btnBack.styleAsBack()
        lblTitle.styleAsTitle()
        lblTitle.text = text
        btnBack.setTitle(Texts.bakka, for: .normal)
        
        lblAmountKg.isHidden = true
        lblTotalWeightDynamic.isHidden = true
        lblTotalWeightStatic.isHidden = true
    }
    
    func setupWithTextOnly(){
        btnBack.isHidden = true
        btnAdd.isHidden = true
        lblTitle.styleAsTitle()
        lblTitle.text = Texts.tolfraedi
        
        lblAmountKg.isHidden = true
        lblTotalWeightDynamic.isHidden = true
        lblTotalWeightStatic.isHidden = true
    }
    
    func setupForAddAfli(){
        
        setupWithBackButtonOnly()
        setTitle(title: "Skrá afla")
        
        lblAmountKg.isHidden = false
        lblTotalWeightDynamic.isHidden = false
        lblTotalWeightStatic.isHidden = false
    }
    
    func updateAfli(){
        
        let roundedAfli = Session.manager.getTotalLoggedCatchWeight().rounded()
        
        lblTotalWeightDynamic.text = String(roundedAfli)
    }
    
    func setBackText(text: String){
        self.btnBack.setTitle(text, for: .normal)
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.delegate?.add()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        
        guard let goBack = self.goBackClosure else{
            self.delegate?.goBack()
            return
        }
        goBack()
    }
    
    
}
