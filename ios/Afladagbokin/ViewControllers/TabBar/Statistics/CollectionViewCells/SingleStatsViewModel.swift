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



class SingleStatsViewModel{

    
    let tourId: Int
    var fromDate: Date
    var toDate: Date
    let statsModel = Observable<TourStatsModel?>(nil)
    let dateStatsModel = Observable<TourStatsModelForDates?>(nil)
    let shouldDisplayFailLbl = Observable<Bool>(false)
    
    //When we just want to get stats for a single tour
    init(tourId: Int){
        self.tourId = tourId
        self.fromDate = Date()
        self.toDate = Date()
    }
    
    //When we want to get stats from a certain date range
    init(fromDate: Date, toDate: Date){
        
        self.fromDate = fromDate
        self.toDate = toDate
        self.tourId = 0
    }
    
    
    
    func getStatsForTour(id: Int, blockComplete: @escaping () -> ()){
        
        let service = StatisticsService()
        
        if self.tourId != 0{
            service.getStatsForTour(id: id){ [weak self] result in
                if result.success{
                    
                    if let statsModel = result.model{
                        self?.statsModel.value = statsModel
                    }
                }
                else{
                    self?.shouldDisplayFailLbl.value = true
                }
            }
        }
        else{
            service.getStatsForDates(fromDate: self.fromDate, toDate: self.toDate){ [weak self] result in
                if result.success{
                    
                    if let statsModel = result.model{
                        self?.dateStatsModel.value = statsModel
                        if self?.dateStatsModel.value?.catchSum == 0{
                            self?.shouldDisplayFailLbl.value = true
                        }
                    }
                }
                else{
                    self?.shouldDisplayFailLbl.value = true
                }
                
            }
        }
        blockComplete()
    }
    
    enum SingleCellStatsCellType{
        case forLastTripCell
        case forColorLineCell
        case forStatsSpeciesCellOther
        case forStatsSpeciesCellFish
        case undefined
    }

    static func getCellTypeFor(indexPath: IndexPath, statsModel: TourStatsModel?, statsModelDates: TourStatsModelForDates?) -> SingleCellStatsCellType{
        
        if indexPath.row == 0 {
            return .forLastTripCell
        }
        else if indexPath.row == 1 {
            if statsModel != nil{
                return .forColorLineCell
            }
            if statsModelDates != nil{
                return .forColorLineCell
            }
        }
        
        if let model = statsModel {
            if (indexPath.row > model.fishSpeciesList.count + 1){
                return .forStatsSpeciesCellOther
            }
            else{
                return .forStatsSpeciesCellFish
            }
        }
        if let dateModel = statsModelDates{
            if indexPath.row > dateModel.fishSpeciesList.count + 1{
                return .forStatsSpeciesCellOther
            }
            else{
                return .forStatsSpeciesCellFish
            }
        }
        
        return .undefined
    }
    
}
