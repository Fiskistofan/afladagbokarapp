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
import ReactiveKit
import Bond
import CoreLocation

class FishingViewModel{
    enum FishingViewModelError {
        case startTourFailed
        case confirmTourFailed
        case registerLocalStorageFailed
    }
    
    let equipmentInput = Observable<String?>("")
    var startTourModel: StartTourModel?
    var equipmentType: EquipmentType? = nil
    let fishService = FishingService()
    let registerService = RegistrationService()
    let locationManager = CLLocationManager()
    
    func startFishing(postModel: PostFishingEquipmentModel, completion: @escaping (_ result: Result<StartTourModel>) -> () ){
        fishService.startFishing(model: postModel){ (result) in
            if result.code == .ok{
                if let model = result.model{
                    self.startTourModel = model
                }
            }
            
            completion(result)
        }
    }
    
    func stopFishing(_ completion: @escaping (FishingViewModelError?) -> ()) {
        guard let tourId = Session.manager.getTourId() else {
            print("[FishingViewModel] - No TourId")
            completion(FishingViewModelError.confirmTourFailed)
            return
        }
        
        registerService.registerLocalStorage() { [weak self] (registerSuccess) in
            guard let this = self else {
                return
            }

            if registerSuccess {
                this.fishService.confirmTour(tourId: tourId) { (confirmSuccess) in
                    confirmSuccess ? completion(nil) : completion(FishingViewModelError.confirmTourFailed)
                    return
                }
            } else {
                completion(FishingViewModelError.registerLocalStorageFailed)
                return
            }
        }
    }
}
