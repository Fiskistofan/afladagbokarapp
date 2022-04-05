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
import UIKit
import ReactiveKit
import Bond


enum StatisticsType{
    
    case standard
    case pushed
}

class StatisticsViewModel{
    
    let type: StatisticsType
    let lblContainerHeight: CGFloat
    let activePage = Observable<Int>(0)
    let tourList = Observable<[TourModel]>([])
    let newestTour = Observable<TourModel?>(nil)
    let statsModel = Observable<TourStatsModel?>(nil)
    
    let strFromDate = Observable<String>("Frá dagsetningu")
    let strToDate = Observable<String>("Til dagsetningar")
    let fromDate = Observable<Date>(Date().dateBySubtractingMonths(6))
    let toDate = Observable<Date>(Date())
    
    let isFromDateActive = Observable<Bool>(true)
    
    init(type: StatisticsType){
        self.type = type
        if type == .standard{
            lblContainerHeight = 57
            
        }
        else{
            lblContainerHeight = 0
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        strFromDate.value = dateFormatter.string(from: fromDate.value)
        strToDate.value = dateFormatter.string(from: toDate.value)
    }
    
    func getCollectionviewHeight(screenHeight: CGFloat, headerHeight: CGFloat, containerHeight:CGFloat) -> CGFloat{
        
        return (screenHeight - headerHeight - containerHeight)
    }
    
    func getNumberOfItemsForCollectionView() -> Int{
        if type == .standard{
            //Three scrollable items
            return 3
        }
        //One item when the controller is pushed from "Fyrri ferðir"
        return 1
    }
    
    func setActivePage(activePage: Int){
        if activePage > -1 && activePage < 4{
            self.activePage.value = activePage
        }
    }
    
    func getStatsForTour(id: Int,_ completion: @escaping (Result<TourStatsModel>) -> ()){
        
        let service = StatisticsService()
        
        service.getStatsForTour(id: id){ [weak self] result in
            
            if result.success{
                
                if let statsModel = result.model{
                    self?.statsModel.value = statsModel
                }
            }
            else{
                print("fail")
            }
        }
        
    }
    
    public func getStats(_ completion: @escaping (Result<TourModelList>) -> ()){
        
        let service = StatisticsService()
        service.getStats{ [weak self] result in
            
            if result.success{
                
                if let tourList = result.model?.historyList{
                    self?.tourList.value = tourList
                    if tourList.count > 0{
                        self?.newestTour.value = tourList[0]
                        Session.manager.saveTourIdForStatistics(tourList[0].id)
                        self?.getStatsForTour(id: (self?.newestTour.value?.id)!){ _ in
                            
                            print("derp")
                        }
                    }
                }
                
                completion(result)
            }
            else{
                completion(result)
            }
        }
    }
}
