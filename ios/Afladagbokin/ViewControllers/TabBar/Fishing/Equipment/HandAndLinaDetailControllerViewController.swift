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

protocol HandAndLineDelegate: class{
    
    func didSelectHandfaeriWith(numberOfHandfaeri: Int, type: VCType)
    func didSelectLinaWith(numberOfOnglar: Int, numberOfBjodar: Int, type: VCType)
    func popHarbor()
}

class HandAndLinaDetailControllerViewController: UIViewController {
    
    @IBOutlet weak var viewHeader: Header!
    @IBOutlet weak var txtFieldViewTop: TextFieldView!
    @IBOutlet weak var txtFieldViewBot: TextFieldView!
    let viewModel: LinaAndHandfaeriViewModel
    @IBOutlet weak var btnSave: UIButton!
    public weak var delegate: HandAndLineDelegate?
    @IBOutlet weak var cBtnBot: NSLayoutConstraint!
    @IBOutlet weak var cBtnTop: NSLayoutConstraint!
    
    init(viewModel: LinaAndHandfaeriViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setup()
        setupBonding()
        // Do any additional setup after loading the view.
    }
    
    func style(){
        
        btnSave.styleAsSave()
        btnSave.setTitle("Næsta skref", for: .normal)
        txtFieldViewBot.txtField.keyboardAppearance = .dark
        txtFieldViewTop.txtField.keyboardAppearance = .dark
    }
    
    func setup(){
        viewHeader.setupWithBackButtonOnly()
        viewHeader.setTitle(title: self.viewModel.vcTitle.value)
        viewHeader.delegate = self
        txtFieldViewTop.txtField.delegate = self
        txtFieldViewBot.txtField.delegate = self
        
        switch self.viewModel.type {
        case .lina:
            setupAsLina()
        case .handfaeri:
            setupAsHandfaeri()
        }
        
        _ = btnSave.reactive.tap.observeNext{ _ in
            
            switch self.viewModel.type {
            case .lina:
                guard let onglaCount = self.viewModel.txtFieldTextTop.value?.count, let bjodaCount = self.viewModel.txtFieldTextBot.value?.count else {
                    //TODO: handle error
                    return
                }
                if onglaCount > 0 && bjodaCount > 0{
                    self.delegate?.didSelectLinaWith(numberOfOnglar: Int(self.viewModel.txtFieldTextTop.value!)!, numberOfBjodar: Int(self.viewModel.txtFieldTextBot.value!)!, type: .lina)
                }
                
                
            case .handfaeri:
                guard let handfaeriCount = self.viewModel.txtFieldTextTop.value?.count else {
                    //TODO: ERROR
                    return
                }
                if handfaeriCount > 0{
                    self.delegate?.didSelectHandfaeriWith(numberOfHandfaeri: Int(self.viewModel.txtFieldTextTop.value!)!, type: .handfaeri)
                }
            }
        }
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss))
        self.view.addGestureRecognizer(tapRec)
        self.registerForKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupBonding(){
        
        switch self.viewModel.type {
        case .lina:
            _ = self.txtFieldViewTop.txtField.reactive.text.observeNext{ value in
                self.viewModel.txtFieldTextTop.value = value
            }
            _ = self.txtFieldViewBot.txtField.reactive.text.observeNext{ value in
                self.viewModel.txtFieldTextBot.value = value
            }
            
            _ = self.viewModel.hasEnteteredValuesForBoth.observeNext{ [weak self] value in
                self?.btnSave.isEnabled = value
                
                if value{
                    UIView.animate(withDuration: 0.35, animations: {
                        self?.btnSave.alpha = 1
                    })
                }
                else{
                    UIView.animate(withDuration: 0.35, animations: {
                        self?.btnSave.alpha = 0.5
                    })
                }
            }
            
        case .handfaeri:
            _ = self.txtFieldViewTop.txtField.reactive.text.observeNext{ value in
                
                self.viewModel.txtFieldTextTop.value = value
            }
            
            _ = self.viewModel.txtFieldTopHasNumber.observeNext{ [weak self] value in
                self?.btnSave.isEnabled = value
                
                if value{
                    UIView.animate(withDuration: 0.35, animations: {
                        self?.btnSave.alpha = 1
                    })
                }
                else{
                    UIView.animate(withDuration: 0.35, animations: {
                        self?.btnSave.alpha = 0.5
                    })
                }
            }
        }
    }
    
    func setupAsHandfaeri(){
        txtFieldViewBot.isHidden = true
        txtFieldViewTop.setupAsHandfaeri()
    }
    
    func setupAsLina(){
        txtFieldViewTop.setupAsOnglar()
        txtFieldViewBot.setupAsBjodar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Keyboard dismiss
extension HandAndLinaDetailControllerViewController{
    
    @objc func keyboardDismiss() {
        self.view.endEditing(true)
    }
}

extension HandAndLinaDetailControllerViewController: UITextFieldDelegate{
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension HandAndLinaDetailControllerViewController: HeaderDelegate{
    
    func goBack() {
        self.delegate?.popHarbor()
    }
    
    func add() {
        
    }
}

extension HandAndLinaDetailControllerViewController{
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        cBtnTop.priority = .defaultHigh
        cBtnBot.priority = .defaultLow
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        cBtnTop.priority = .defaultLow
        cBtnBot.priority = .defaultHigh
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
