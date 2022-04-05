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

class FishingService: NetworkingService{
    /**
     */
    func startFishing(model: PostFishingEquipmentModel, with result: @escaping (_ result: Result<StartTourModel>) -> ()){
        let endpoint = NetworkEndpoint.Post.startTour
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: model.toJSON())
        
        networking.request(request) { (json, error) in
            let resultWrapper:Result<StartTourModel> = self.resultFromJSON(json, error)
            print("[FishingService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
    
    /**
     */
    func confirmTour(tourId: Int, success: @escaping (Bool) -> ()) {
        let endpoint = NetworkEndpoint.Post.confirmTour(tourId: tourId)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: [:])
        
        networking.request(request) { (json, error) in
            if let error = error { print(error) }
            print("[FishingService] — Did make request: \(request.url)")
            success(error == nil)
        }
    }
    
    /**
     */
    func restrictedZones(date: Date, with result: @escaping ([RestrictedZone]) -> ()) {
        let endpoint = NetworkEndpoint.Get.restrictedZones(when: date)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method)
        
        networking.request(request) { (json, error) in
            if let error = error { print(error) }
            print("[FishingService] — Did make request: \(request.url)")
            guard let json = json, let response = json["response"] as? [JSON] else {
                result([])
                return
            }
            
            let restrictedZones = response.compactMap { RestrictedZone(json: $0) }
            result(restrictedZones)
        }
    }
 
}
