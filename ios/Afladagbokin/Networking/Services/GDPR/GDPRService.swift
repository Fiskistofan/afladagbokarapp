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

class GDPRService: NetworkingService{
    
    func fetchGDPRCompliance( with result: @escaping (_ result: Bool, _ policyId: Int?, _ policyURL: String?) -> ()){
        
        let endpoint = NetworkEndpoint.Get.GDPR
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method)
        
        networking.request(request) { (json, error) in
            
            print("[GDPRService] — Did make request: \(request.url)")
            guard let serverJSON = json else {
                result(false, nil, nil)
                return
            }
            guard let needsAcceptance = serverJSON[Session.GDPR_SERVER_KEY] as? Bool else {
                result(false,nil,nil)
                return
            }
            guard let privacyTerms = serverJSON[Session.GDPR_POLICY_KEY] as? JSON else {
                result(false,nil,nil)
                return
            }
            guard let privacyId = privacyTerms[Session.GDPR_POLICY_ID_KEY] as? Int else{
                result(false,nil,nil)
                return
            }
            guard let privacyURL = privacyTerms[Session.GDPR_POLICY_URL_KEY] as? String else{
                result(false,nil,nil)
                return
            }
            needsAcceptance ? result(true, privacyId, privacyURL) : result(false, nil, nil)
        }
    }
    
    func postGDPRAcceptance(success: @escaping (Bool) -> ()){
        
        let policyID = Session.manager.getGDPRPolicyID()
        let endpoint = NetworkEndpoint.Get.gdpr(termsID: policyID)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method)
        
        networking.request(request) { (json, error) in
            
            print("[GDPRService] — Did make request: \(request.url)")
            if let error = error {
                print(error)
                success(false)
            }
            success(error == nil)
        }
    }
}
