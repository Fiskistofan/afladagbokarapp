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

struct StartTourModel{
    
    static let tourKey = "tour"
    static let tossesKey = "tosses"
    static let fishingEquipmentKey = "fishingEquipment"
    
    public var tourStartModel: TourStartModel?
    public var arrTosses: [TossesModel]
    public var fishingEquipment: FishingEquipmentModel?
}

extension StartTourModel: JSONInitable{
    
    init?(json: JSON) {
        
        guard let tourStartModel = json[StartTourModel.tourKey] as? JSON else{
            return nil
        }
        guard let tosses = json[StartTourModel.tossesKey] as? [JSON] else{
            return nil
        }
        guard let fishingEq = json[StartTourModel.fishingEquipmentKey] as? JSON else{
            return nil
        }
        
        print(tosses)
        
        self.tourStartModel = TourStartModel(json: tourStartModel)
        self.arrTosses = tosses.flatMap { TossesModel(json: $0) }
        self.fishingEquipment = FishingEquipmentModel(json: fishingEq)
        
        //clear the total logged weight of catches
        Session.manager.setTotalLoggedCatchWeight(0)
        
        if let tour = json["tour"] as? JSON{
            
            if let tourId = tour["tourId"] as? String{
                if let tourIdAsInt = Int(tourId){
                    Session.manager.saveTourId(Int(tourIdAsInt))
                }
            }
        }
        
        
        print("Did recieve \(self.arrTosses.count) tosses from Friðjón")
        
        for tossModel in self.arrTosses {
            if let toss = TossFactory.fromTossModel(tossModel) {
                Session.manager.saveToss(toss, andRegister: false)
            }
        }
    }
}
