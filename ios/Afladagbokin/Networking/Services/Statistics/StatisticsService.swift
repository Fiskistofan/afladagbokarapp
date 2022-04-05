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

class StatisticsService: NetworkingService{
    
    public func getStats(result: @escaping (_ result: Result<TourModelList>) -> () ){
        let shipId = Session.manager.getSelectedBoatId()
        let endpoint = NetworkEndpoint.Get.toursHistory(shipId: shipId)
        let request = NetworkRequest(url: endpoint.path, method: .get)
        
        networking.request(request){ (json, error) in
            let resultWrapper: Result<TourModelList> = self.resultFromJSON(json, error)
            print("[StatisticsService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
    
    public func getStatsForTour(id: Int, result: @escaping (_ result: Result<TourStatsModel>) -> () ){
        let endpoint = NetworkEndpoint.Get.tourHistory(tourId: id)
        let request = NetworkRequest(url: endpoint.path, method: .get)
        
        networking.request(request){ (json, error) in
            let resultWrapper: Result<TourStatsModel> = self.resultFromJSON(json, error)
            print("[StatisticsService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
    
    public func getStatsForDates(fromDate: Date, toDate: Date, result: @escaping (_ result: Result<TourStatsModelForDates>) -> () ){
        let shipId = Session.manager.getSelectedBoatId()
        let endpoint = NetworkEndpoint.Get.catchStatistic(from: fromDate, to: toDate, shipId: shipId)
        let request = NetworkRequest(url: endpoint.path, method: .get)
        
        networking.request(request){ (json, error) in
            let resultWrapper: Result<TourStatsModelForDates> = self.resultFromJSON(json, error)
            print("[StatisticsService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
}
