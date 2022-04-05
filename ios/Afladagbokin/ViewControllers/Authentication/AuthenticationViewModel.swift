// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import Bond
import ReactiveKit
import FirebaseAuth

protocol AuthDidFinish:class {
    
    func didFinishLogin()
}

class AuthenticationViewModel{
    
    let phoneNumber = Observable<String?>("")
    let sms = Observable<String?>("")
    var hasSentPhone = false
    var verificationId: String?
    var phoneCompletion: (() -> ())!
    var smsCompletion: (() -> ())!
    var errorCompletion: (() -> ())!
    var hasSetupLottie = false
    let fireBaseManager = FireBaseManager.sharedInstance
    
    public func sendPhoneNumber(blockComplete: @escaping () -> (), blockError: @escaping () -> ()) {
        self.phoneCompletion = blockComplete
        self.errorCompletion = blockError
        
        guard let phoneNumberWithoutSpaces = phoneNumber.value?.replacingOccurrences(of: " ", with: "") else {
            return
        }
        let phoneNrWith354 = phoneNumberWithoutSpaces.first == "+" ? phoneNumberWithoutSpaces : "+354\(phoneNumberWithoutSpaces)"
        
            fireBaseManager.verifyPhoneNumber(phoneNrWith354) { [weak self] (id, error) in
                guard let this = self else {
                    return
                }
                
                if let id = id {
                    this.verificationId = id
                    this.hasSentPhone = true
                    this.phoneCompletion()
                    return
                }
                
                this.errorCompletion()
            }
    }
    
    
    public func sendPinToFirebase(completion: @escaping (_ success: Bool) -> (), blockError: @escaping () -> ()) {
        
        self.errorCompletion = blockError
        
        guard let smsCode = self.sms.value else {
            print("[AuthViewModelError] - SMS code is nil")
            self.errorCompletion()
            return
        }
        
        guard let verificationId = self.verificationId else {
            print("[AuthViewModelError] - VerificationId is nil")
            self.errorCompletion()
            return
        }
        
        
        // Dirty hack for AppStore review... sign in anonymously if phonenumber and sms are predefined values.
        guard let phoneNumber = phoneNumber.value?.replacingOccurrences(of: " ", with: "") else {
            return
        }
        
            fireBaseManager.verifySMSCode(smsCode, verificationId: verificationId) { [weak self] (token, error) in
                guard let this = self else {
                    completion(false)
                    return
                }
                
                guard token != nil else {
                    this.errorCompletion()
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
    

    /**
     */
    func saveResult(model: MeModel){
        Session.manager.savePorts(model.arrOfPortsAsDict)
        Session.manager.saveOtherSpecies(model.arrOtherSpeciesAsDict)
        Session.manager.saveFishSpecies(model.arrFishSpeciesAsDict)
        Session.manager.saveEquipment(model.arrOfFishingEquipmentsAsDict)
        
        let otherSpecies = Session.manager.getOtherSpecies()
        if !otherSpecies.isEmpty { print(otherSpecies) }
     
        let fishSpecies = Session.manager.getFishSpecies()
        if !fishSpecies.isEmpty { print(fishSpecies) }
        
        let equipment = Session.manager.getEquipment()
        if !equipment.isEmpty { print(equipment) }
        
        if let ships = model.ships{
            if ships.count > 0{
                let boatId = model.ships![0].id
                Session.manager.saveDefaultBoatId(boatId)
                Session.manager.saveSelectedBoatId(boatId)
            }
            Session.manager.saveBoats(ships)
        }
    }
    
    public func shouldChangeCharactersInRangeForText(textfieldText: String!, replacementString: String) -> Bool{
        // 8 for icelandic number (with space), 15 for foreign numbers (with + as first char)
        let maxLength = textfieldText.first == "+" ? 15 : 8
        
        if !hasSentPhone{
            if textfieldText.count < maxLength {
                return true
            }
            if textfieldText.count == maxLength && replacementString == ""{
                return true
            }
            return false
        }
        else{
            if textfieldText.count < 6 {
                return true
            }
            if textfieldText.count == 6 && replacementString == ""{
                return true
            }
        }
        return false
    }
    
    public func getTxtFieldText(strPhone: String, replacementString: String) -> String{
        guard !hasSentPhone, !(strPhone.first == "+") else {
            return strPhone
        }
        

        if strPhone.count == 3 {
            if replacementString != ""{
                return strPhone + " "
            }
        } else if strPhone.count == 5{
            if replacementString == ""{
                let firstThreeLetters = String(strPhone.prefix(4))
                return firstThreeLetters
            }
        }

        return strPhone
    }
    
}
