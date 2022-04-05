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
import Alamofire


/*
 * The endpoints of the api
 */
enum NetworkEndpoint {
    enum Get {
        case tourHistory(tourId: Int)
        case toursHistory(shipId: Int)
        case catchStatistic(from: Date, to: Date, shipId: Int)
        case me
        case restrictedZones(when: Date)
        case GDPR
        case gdpr(termsID: Int)
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            switch self {
                
            case let .tourHistory(tourId):
                return "/v1/tours/" + "\(tourId)" + "/history"
                
            case let .toursHistory(shipId):
                return "/v1/history?page=0&size=10" + "&shipId=" + "\(shipId)"
                
            case let .catchStatistic(from, to, shipId):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let dateFrom = formatter.string(from: from)
                let dateTo = formatter.string(from: to)
                
                return "/v1/statistics?" + "dateFrom=" + dateFrom + "&" + "dateTo=" + dateTo + "&shipId=" + "\(shipId)"
                
            case .me:
                return "/v1/profiles/me"
                
            case let .restrictedZones(when):
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let whenDate = formatter.string(from: when)
                
                return "/v1/restrictedZones?date=" + whenDate
                
            case .GDPR:
                return "/v1/terms"
                
            case let .gdpr(termsID):
                return "/v1/terms/" + "\(termsID)" + "/accept/"
            }
        }
    }
    
    enum Post {
        case login
        case startTour
        case confirmTour(tourId: Int)
        
        var method: HTTPMethod {
            return .post
        }
        
        var path: String {
            switch self {
                
            case .login:
                return "/v1/login"
                
            case .startTour:
                return "/v1/tours"
                
            case let .confirmTour(tourId):
                return "/v1/tours/" + "\(tourId)" + "/confirm"
            }
        }
    }
    
    enum Put {
        case toss(tourId: Int, tossId: String)
        case pull(tourId: Int, pullId: String)
        case catchedFish(tourId: Int, catchId: String)
        case catchedMammalsAndBirds(tourId: Int, otherSpeciesCatchId: String)
        
        var method: HTTPMethod {
            return .put
        }
        
        var path: String {
            switch self {
                
            case let .toss(tourId, tossId):
                return "/v1/tours/" + "\(tourId)" + "/toss/" + "\(tossId)"
                
            case let .pull(tourId, pullId):
                return "/v1/tours/" + "\(tourId)" + "/pull/" + "\(pullId)"
                
            case let .catchedFish(tourId, catchId):
                return "/v1/tours/" + "\(tourId)" + "/catch/" + "\(catchId)"
                
            case let .catchedMammalsAndBirds(tourId, otherSpeciesCatchId):
                return "/v1/tours/" + "\(tourId)" + "/catchMammalsAndBirds/" + "\(otherSpeciesCatchId)"
            }
        }
    }
}

