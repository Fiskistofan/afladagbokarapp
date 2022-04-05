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

protocol LogWeightCellDelegate: class{
    
    func didLogWeight(_ weight: Int)
}

class LogWeightCell: UITableViewCell {

    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtField: UITextField!
    var viewModel: LogWeightViewModel!
    let disposeBag = DisposeBag()
    public weak var delegate: LogWeightCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setup(viewModel: LogWeightViewModel){
        
        lblTitle.styleAsTableDescription()
        lblTitle.text = Texts.weight
        if Session.manager.getIsLoggedAfliFish(){
            lblTitle.text = Texts.weight
            txtField.styleAsTableCellTextField(placeholderText: Texts.enterWeight)
        } else {
            lblTitle.text = Texts.quantity
            txtField.styleAsTableCellTextField(placeholderText: Texts.enterQuantity)
        }
        
        let weight = viewModel.animalWeight.value
        if !weight.isEmpty { txtField.text = weight }
        
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Loka", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        done.tintColor = Color.blue.value
        done.isEnabled = true
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        txtField.inputAccessoryView = doneToolbar
        txtField.keyboardType = Session.manager.getIsLoggedAfliFish() ? .decimalPad : .numberPad
        txtField.delegate = self
        
        self.viewModel = viewModel
        setupBonding()
        self.txtField.text = self.viewModel.animalWeight.value
    }
    
    @objc func doneButtonAction()
    {
        txtField.resignFirstResponder()
    }
    
    func setupBonding(){
        
        
        _ = self.txtField.reactive.text.observeNext{ [weak self] value in
            
            guard let myValue = value else{
                return
            }
            self?.viewModel.animalWeight.value = myValue.replacingOccurrences(of: ",", with: ".")
        }
    }
}


// MARK: - UITextFieldDelegate
extension LogWeightCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}
