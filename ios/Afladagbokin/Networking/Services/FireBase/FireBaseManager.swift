// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import FirebaseAuth

class FireBaseManager {
    enum FireBaseManagerError {
        case phoneVerificationFailed
        case smsVerificationFailed
        case anonymousLoginFailed
        case refreshTokenFailed
        case noUser
    }
    
    static let sharedInstance = FireBaseManager()
    
    fileprivate var listener: AuthStateDidChangeListenerHandle?
    fileprivate let auth = Auth.auth()
    fileprivate let phoneAuth = PhoneAuthProvider.provider()
    
    private init() { }
    
    /**
     */
    func verifyPhoneNumber(_ phoneNumber: String, result: @escaping (_ verificationId: String?, _ error: FireBaseManagerError?) -> ()) {
        phoneAuth.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            guard let id = verificationId else {
                print("[FireBaseError] - Could not verify phone number")
                print(error ?? "No id without error response")
                result(nil, FireBaseManagerError.phoneVerificationFailed)
                return
            }
            
            result(id, nil)
        }
        
    }
    
    /**
     */
    func verifySMSCode(_ SMSCode: String, verificationId: String, result: @escaping (_ token: String?, _ error: FireBaseManagerError?) -> ()) {
        let credential = phoneAuth.credential(withVerificationID: verificationId, verificationCode: SMSCode)
        auth.signIn(with: credential) { [weak self] (user, error) in
            guard let this = self else {
                return
            }
            
            guard user != nil else {
                print("[FireBaseError] - Could not verify sms code")
                print(error ?? "No user without error response")
                result(nil, FireBaseManagerError.smsVerificationFailed)
                return
            }
            
            this.refreshTokenIfNeeded() { (token, error) in
                result(token, error)
            }
        }
    }
    
    /**
     */
    func signInAnonymously(result: @escaping (_ token: String?, _ error: FireBaseManagerError?) -> ()) {
        auth.signInAnonymously() { [weak self] (user, error) in
            guard let this = self else {
                return
            }
            
            guard user != nil else {
                print("[FireBaseError] - Could not sign in anonymously")
                print(error ?? "No user without error response")
                result(nil, FireBaseManagerError.anonymousLoginFailed)
                return
            }

            this.refreshTokenIfNeeded() { (token, error) in
                result(token, error)
            }
        }
    }
    
    /**
     */
    func refreshTokenIfNeeded(result: @escaping (_ token: String?, _ error: FireBaseManagerError?) -> ()) {
        guard let user = auth.currentUser else {
            print("[FireBaseError] - No current user")
            handleNoFireBaseUser()
            result(nil, FireBaseManagerError.noUser)
            return
        }
        
        user.getIDToken() { (token, error) in
            guard let token = token else {
                print("[FireBaseError] - Could not refresh token")
                print(error ?? "No token without error response")
                result(nil, FireBaseManagerError.refreshTokenFailed)
                return
            }
            
            Session.manager.saveUserToken(token)
            result(token, nil)
        }
    }
    
    /**
     */
    func logOut() {
        do {
            try auth.signOut()
        } catch {
            print("[FireBaseError] - Could not sign out the current user")
            print(error)
        }
        
    }
    
    /**
     */
    fileprivate func setFireBaseTokenListener() {
        self.listener = auth.addIDTokenDidChangeListener() { [weak self] (auth, user) in
            print("[FireBaseManager] - Token did change")
            guard let this = self else {
                return
            }
            
            guard let user = user else {
                this.handleNoFireBaseUser()
                return
            }
            
            user.getIDToken() { (token, error) in
                guard let token = token else {
                    print("Error getting Token")
                    return
                }
                Session.manager.saveUserToken(token)
            }
         }
    }
    
    /**
     */
    fileprivate func removeFireBaseTokenListener() {
        guard let listener = listener else {
            return
        }
        auth.removeStateDidChangeListener(listener)
    }
    
    /**
     */
    fileprivate func handleNoFireBaseUser() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logOut()
    }
}
