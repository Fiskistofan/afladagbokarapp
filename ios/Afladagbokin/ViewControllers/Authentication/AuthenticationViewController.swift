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
import ReactiveKit
import Firebase
import Lottie

protocol AuthenticationViewControllerDelegate:class {
    func didFinishWithSuccessfulLogin()
}

class AuthenticationViewController: UIViewController {
    
    //MARK: Properties
    fileprivate var viewModel: AuthenticationViewModel!
    @IBOutlet weak var lblSkra: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var viewTxtContainer: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var cLblToTitle: NSLayoutConstraint!
    @IBOutlet weak var cTxtToLbl: NSLayoutConstraint!
    let disposeBag = DisposeBag()
    let disposeBagSMS = DisposeBag()
    let animationDuration = 0.5
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var cLogoToTop: NSLayoutConstraint!
    @IBOutlet weak var btnNewSMS: UIButton!
    let cornerRadius: CGFloat = 5
    public weak var delegate: AuthenticationViewControllerDelegate?
    var phoneCompletion: (() -> ())?
    var smsCompletion: (() -> ())?
    var rePhoneCompletion: ( () -> ())?
    var errorCompletion: ( () -> ())?
    var errorSMSCompletion: ( () -> ())?
    @IBOutlet weak var cSmsToTOp: NSLayoutConstraint!
    @IBOutlet weak var cSmsTrailing: NSLayoutConstraint!
    var animationView: LOTAnimationView?
    let btnCheckAlphaDisabled: CGFloat = 0.5
    
    //MARK: Initialization
    init(viewModel: AuthenticationViewModel){
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewCycle + Styling
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        setupBindings()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: viewTxtContainer.frame.size.width, height: viewTxtContainer.frame.size.height)
        gradientLayer.colors = [Color.authenticationGradientStart.value.cgColor, Color.authenticationGradientEnd.value.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: -0.35)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.6)
        gradientLayer.cornerRadius = cornerRadius
        viewTxtContainer.layer.addSublayer(gradientLayer)
        
        if !self.viewModel.hasSetupLottie{
            setupLottie()
        }
    }
    
    func setupLottie(){
        
        animationView = LOTAnimationView(name: "data")
        animationView?.frame = imgView.frame
        animationView?.contentMode = .scaleAspectFill
        animationView?.clipsToBounds = false
        animationView?.animationSpeed = 0.8
        animationView?.loopAnimation = true
        if let aView = self.animationView{
            self.view.addSubview(aView)
        }
        viewModel.hasSetupLottie = true
        
    }
    
    func blockUITouch(){
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func enableUITouch(){
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func setup(){
        
        self.btnCheck.isEnabled = false
        imgView.isHidden = true
        self.registerForKeyboard()
        self.dismissKeyboardOnViewTap()
        _ = btnCheck.reactive.tap.observeNext { [weak self] _ in
            self?.showKeyboard()
        }
        lbltitle.text = Texts.dagbok
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        viewTxtContainer.addGestureRecognizer(tapRec)
        viewTxtContainer.isUserInteractionEnabled = true
        
        self.phoneCompletion = {
            self.enableUITouch()
            //TODO: Add dismiss loading
            self.disposeBag.dispose()
            self.setupBindingsForSMS()
            self.styleForSMS()
            self.viewModel.sms.value = ""
            self.animationView?.stop()
            
        }
        
        self.rePhoneCompletion = {
            
            self.enableUITouch()
            //TODO: Add dismiss loading
            self.viewModel.sms.value = ""
            self.animationView?.stop()
        }
        
        self.errorCompletion = {
            self.enableUITouch()
            self.animationView?.stop()
            self.viewModel.sms.value = ""
            self.viewModel.phoneNumber.value = ""
            
            let alert = UIAlertController(title: "Villa", message: "Villa kom upp í innskráningarferli. Vinsamlegast athugaðu hvort þú hafir slegið inn rétt símanúmer og að síminn sé í netsambandi og reyndu svo aftur.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.errorSMSCompletion = {
            self.enableUITouch()
            self.animationView?.stop()
            self.viewModel.sms.value = ""
            self.viewModel.phoneNumber.value = ""
            
            let alert = UIAlertController(title: "Villa", message: "Villa kom upp í innskráningarferli. Vinsamlegast athugaðu hvort þú hafir slegið inn rétt SMS og að síminn sé í netsambandi og reyndu svo aftur.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
            self.enableUITouch()
        }
    }
    
    func style(){
        
        lbltitle.textColor = .white
        lbltitle.font = Fonts.Center.bold.of(size: 27)
        
        lblSkra.textColor = .white
        lblSkra.lineBreakMode = .byWordWrapping
        lblSkra.numberOfLines = 0
        lblSkra.textColor = UIColor.white
        
        self.addSpacingAndUnderlineToLabel()
        
        btnCheck.styleAsCheckbox()
        
        //iPhone5 adjustment for button in right corner
        if UIScreen.main.bounds.width == 320{
            cSmsTrailing.constant = 10
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        
        viewTxtContainer.styleAsTextContainer()
        txtField.styleForLogin()
        txtField.delegate = self
        btnNewSMS.layer.cornerRadius = cornerRadius
        btnNewSMS.styleAsNewSMS()
        
        if Utls.screenSize().width == 320{
            //iPhone5
            cLogoToTop.constant = 70
            cLblToTitle.constant = 40
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    
    func addSpacingAndUnderlineToLabel(){
        
        let textContent = Texts.textLogin
        let textString = NSMutableAttributedString(string: textContent, attributes: [    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
        let underlinedText = NSMutableAttributedString(string: Texts.myPages, attributes: [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        let textRangeMinarSidur = NSRange(location: 0, length: underlinedText.length)
        underlinedText.addAttributes([    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.thin)], range: textRangeMinarSidur)
        textString.append(underlinedText)
        textString.append(NSAttributedString(string: "."))
        lblSkra.attributedText = textString
    }
    
    
    func styleForSMS(){
        
        
        UIView.animate(withDuration: 0.25) {
            if UIDevice.current.iPhoneX{
                //self.cLogoToTop.constant = 60
            }
            else{
                //self.cLogoToTop.constant = 40
                //self.cSmsToTOp.constant = 40
            }
            self.btnNewSMS.alpha = 1
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            if let aView = self.animationView{
                UIView.animate(withDuration: 0.25, animations: {
                    aView.frame = self.imgView.frame
                })
            }
        }
        
        
        let textContent = Texts.confirmation + self.viewModel.phoneNumber.value! + Texts.confirmation2
        let textString = NSMutableAttributedString(string: textContent, attributes: [    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        textString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range: textRange)
        lblSkra.attributedText = textString
        self.txtField.text = ""
        self.txtField.placeholder = ""
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)
        ]
        txtField.attributedPlaceholder = NSAttributedString(string: Texts.smsConfirm, attributes: attributes)
        if Utls.screenSize().width == 320{
            //iPhone5
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13)
            ]
            txtField.attributedPlaceholder = NSAttributedString(string: Texts.smsConfirm, attributes: attributes)
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    //MARK: Keyboard
    
    @objc func showKeyboard(){
        txtField.becomeFirstResponder()
    }
    
    @objc func willResignActive(_ notification: Notification) {
        self.hideKeyboard()
    }
    
    @objc func hideKeyboard(){
        
        self.txtField.resignFirstResponder()
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: Bindings
    func setupBindings(){
        
        self.viewModel.phoneNumber.bidirectionalBind(to: txtField.reactive.text).dispose(in: disposeBag)
        _ = self.viewModel.phoneNumber.observeNext{ value in
            guard let phoneNumberLength = value?.count else {
                return
            }
            
            self.view.layoutIfNeeded()
            if phoneNumberLength >= 8{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    
                    self.btnCheck.alpha = 1
                    self.btnCheck.isEnabled = true
                    //self.imgViewCheck.alpha = 1
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
            else{
                //Dont rely on the alpha wtf ívar
                if self.btnCheck.alpha == 1{
                    
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        
                        self.btnCheck.alpha = self.btnCheckAlphaDisabled
                        self.btnCheck.isEnabled = true
                        //self.imgViewCheck.alpha = 0
                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    
    func setupBindingsForSMS(){
        
        self.viewModel.sms.bidirectionalBind(to: self.txtField.reactive.text)
        
        _ = self.viewModel.sms.observeNext{ value in
            
            if value?.count == 6{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    
                    self.btnCheck.alpha = 1
                    self.btnCheck.isEnabled = true
                    //self.imgViewCheck.alpha = 1
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
            else{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    
                    self.btnCheck.alpha = self.btnCheckAlphaDisabled
                    self.btnCheck.isEnabled = false
                    //self.imgViewCheck.alpha = 0
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    
    //MARK: User Actions
    @IBAction func btnSMSPressed(_ sender: Any) {
        
        self.animationView?.play()
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        blockUITouch()
        self.viewModel.sendPhoneNumber(blockComplete: self.rePhoneCompletion!, blockError: self.errorCompletion!)
    }
    
    @IBAction func btnCheckClicked(_ sender: Any) {
        
        self.animationView?.play()
        blockUITouch()
        if self.viewModel.hasSentPhone{
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            
            
            self.viewModel.sendPinToFirebase(completion: { [weak self] success in
                self?.enableUITouch()
                if success {
                    
                    self?.animationView?.stop()
                    self?.delegate?.didFinishWithSuccessfulLogin()
                }
                else{
                    
                }
                },
                                             blockError: self.errorSMSCompletion!)
            
        }
        else{
            
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            self.viewModel.sendPhoneNumber(blockComplete: self.phoneCompletion!, blockError: self.errorCompletion!)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: UITextFieldDelegate
extension AuthenticationViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let txtFieldText = textField.text{
            
            textField.text = self.viewModel.getTxtFieldText(strPhone: txtFieldText, replacementString: string)
        }
        
        return self.viewModel.shouldChangeCharactersInRangeForText(textfieldText: textField.text, replacementString: string)
    }
}
