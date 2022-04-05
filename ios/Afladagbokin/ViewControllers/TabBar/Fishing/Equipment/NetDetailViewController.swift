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

protocol NetDetailViewControllerDelegate: class{
    
    func popHarbor()
    func didLogSize(count: Int, heigth: Int, size: Int)
}

class NetDetailViewController: BaseViewController {
    
    
    @IBOutlet weak var viewHeader: Header!
    public weak var delegate: NetDetailViewControllerDelegate?
    @IBOutlet weak var txtFieldView: TextFieldView!
    @IBOutlet weak var btnSave: UIButton!
    let viewModel: NetDetailViewModel
    @IBOutlet weak var cBtnBot: NSLayoutConstraint!
    @IBOutlet weak var txtFieldViewMid: TextFieldView!
    @IBOutlet weak var txtFieldViewBot: TextFieldView!
    let originalBtnConstant: CGFloat = 27
    
    public init(viewModel: NetDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupBonding()
        // Do any additional setup after loading the view.
    }
    
    func setupBonding(){
        
        _ = self.txtFieldView.txtField.reactive.text.observeNext{ [weak self] value in
            
            
            guard let myValue = value else{
                return
            }
            
            self?.viewModel.text.value = myValue
        }
        
        _ = self.txtFieldViewMid.txtField.reactive.text.observeNext{ [weak self] value in
            
            guard let myValue = value else{
                return
            }
            self?.viewModel.textHeight.value = myValue
        }
        
        _ = self.txtFieldViewBot.txtField.reactive.text.observeNext{ [weak self] value in
            
            guard let myValue = value else{
                return
            }
            
            self?.viewModel.textSize.value = myValue
        }
        
        _ = self.viewModel.hasFilledInAllData.observeNext{ [weak self] value in
            self?.btnSave.isEnabled = value
            
            if value{
                UIView.animate(withDuration: 0.25, animations: {
                    self?.btnSave.alpha = 1
                })
            }
            else{
                UIView.animate(withDuration: 0.25, animations: {
                    self?.btnSave.alpha = 0.5
                })
            }
        }
    }
    
    func setup(){
        txtFieldView.setupAsNet()
        txtFieldViewMid.setupAsHeightMoski()
        txtFieldViewBot.setupAsSizeMoskvi()
        
        txtFieldView.txtField.delegate = self
        txtFieldViewMid.txtField.delegate = self
        txtFieldViewBot.txtField.delegate = self
        viewHeader.setupWithBackButtonOnly()
        viewHeader.setTitle(title: "Hvernig net?")
        viewHeader.delegate = self
        
        let tapRecTop = UITapGestureRecognizer(target: self, action: #selector(topKeyboardActive))
        let tapRecMid = UITapGestureRecognizer(target: self, action: #selector(midKeyboardActive))
        let tapRecBot = UITapGestureRecognizer(target: self, action: #selector(botKeyboardActive))
        
        txtFieldView.addGestureRecognizer(tapRecTop)
        txtFieldView.isUserInteractionEnabled = true
        
        txtFieldViewMid.addGestureRecognizer(tapRecMid)
        txtFieldViewMid.isUserInteractionEnabled = true
        
        txtFieldViewBot.addGestureRecognizer(tapRecBot)
        txtFieldViewBot.isUserInteractionEnabled = true
        
        btnSave.styleAsSave()
        btnSave.setTitle("Næsta skref", for: .normal)
        
        _ = btnSave.reactive.tap.observeNext{ [weak self] _ in
            
            guard let myValue = self?.viewModel.hasFilledInAllData.value else{
                return
            }
            
            guard let strCount = self?.viewModel.text.value, let intCount = Int(strCount), let strHeight = self?.viewModel.textHeight.value, let height = Int(strHeight), let strSize = self?.viewModel.textSize.value, let size = Int(strSize)  else{
                return
            }
            
            if myValue{
                self?.delegate?.didLogSize(count: intCount, heigth: height, size: size)
            }
        }
        
        self.registerForKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRec)
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Staðfesta", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        done.tintColor = Color.blue.value
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        txtFieldView.txtField.inputAccessoryView = doneToolbar
        txtFieldView.txtField.keyboardType = .numberPad
        
        txtFieldViewMid.txtField.inputAccessoryView = doneToolbar
        txtFieldViewMid.txtField.keyboardType = .decimalPad
        
        txtFieldViewBot.txtField.inputAccessoryView = doneToolbar
        txtFieldViewBot.txtField.keyboardType = .decimalPad
        
    }
    
    @objc func topKeyboardActive(){
        txtFieldView.txtField.becomeFirstResponder()
    }
    
    @objc func midKeyboardActive(){
        txtFieldViewMid.txtField.becomeFirstResponder()
    }
    
    @objc func botKeyboardActive(){
        txtFieldViewBot.txtField.becomeFirstResponder()
    }
    
    @objc func doneButtonAction()
    {
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NetDetailViewController: HeaderDelegate, UITextFieldDelegate{
    
    func goBack() {
        self.delegate?.popHarbor()
    }
    
    func add() {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 7
        
        if textField === txtFieldViewBot {
            maxLength = 4
        }
        
        //let maxLength = 4
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        print(newString.length)
        print(maxLength)
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFieldViewBot.txtField{
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: -200,
                                         width: self.view.frame.width,
                                         height:self.view.frame.size.height)
                cBtnBot.constant = 80
        }
    }
}

//MARK: - Keyboard Handling
extension NetDetailViewController{
    
    @objc func hideKeyboard(){
        
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        if let responder = findFirstResponder(inView: self.view){
            
            if responder == txtFieldViewBot.txtField{
                
                if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    self.view.frame = CGRect(x: self.view.frame.origin.x,
                                             y: -keyboardHeight,
                        width: self.view.frame.width,
                        height:self.view.frame.size.height)
                }
            }
        }
        cBtnBot.constant = originalBtnConstant
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        self.view.frame = CGRect(x: self.view.frame.origin.x,
                                 y: 0,
                                 width: self.view.frame.width,
                                 height: self.view.frame.height)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
}
