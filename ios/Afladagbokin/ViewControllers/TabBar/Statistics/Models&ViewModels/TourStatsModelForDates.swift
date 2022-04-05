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

struct TourStatsModelForDates{
    
    static let catchStatisticsKey = "catchStatistics"
    static let catchSumKey = "catchSum"
    static let smallCatchSumKey = "smallCatchSum"
    static let speciesCountKey = "speciesCount"
    static let totalPullsKey = "totalPulls"
    static let fishSpeciesTotalCatchListKey = "fishSpeciesTotalCatchList"
    static let otherSpeciesTotalCatchListKey = "mammalAndBirdsTotalCatchList"
    static let fishSpeciesKey = "fishSpecies"
    static let otherSpeceisKey = "otherSpecies"
    static let landingPortKey = "landingPort"
    static let landingDateKey = "landingDate"
    static let tourCatchDetailDtoKey = "tourCatchDetailDto"
    static let colorCodeKey = "colorCode"
    
    public var catchSum = 0.0
    public var smallCatchSum = 0.0
    public var speciesCount = 0
    public var totalPulls = 0
    public var fishSpeciesList: [FishSpeciesCatch]
    public var otherSpeciesList: [AnimalsSpeciesCatch]
    public var landingPort = ""
    public var landingDate = ""
}

extension TourStatsModelForDates: JSONInitable{
    
    init?(json: JSON) {
        
        guard let catchStatistics = json[TourStatsModel.catchStatisticsKey] as? JSON else {
            return nil
        }
        
        guard let catchSum = catchStatistics[TourStatsModel.catchSumKey] as? Double else{
            return nil
        }
        guard let smallCatchSum = catchStatistics[TourStatsModel.smallCatchSumKey] as? Double else{
            return nil
        }
        guard let speciesCount = catchStatistics[TourStatsModel.speciesCountKey] as? Int else{
            return nil
        }
        guard let totalPulls = catchStatistics[TourStatsModel.totalPullsKey] as? Int else{
            return nil
        }
        
        guard let fishSpeciesList = catchStatistics[TourStatsModel.fishSpeciesTotalCatchListKey] as? [JSON] else{
            return nil
        }
        
        guard let otherSpeciesList = catchStatistics[TourStatsModel.otherAnimalsCatchListKey] as? [JSON] else{
            return nil
        }
        
        self.landingPort = "Á ekki við"
        self.landingDate = "Á ekki við"
        self.catchSum = catchSum
        self.smallCatchSum = smallCatchSum
        self.speciesCount = speciesCount
        self.totalPulls = totalPulls
        self.fishSpeciesList = fishSpeciesList.compactMap{ FishSpeciesCatch(json: $0) }
        self.otherSpeciesList = otherSpeciesList.compactMap{ AnimalsSpeciesCatch(json: $0) }
        print("")
    }
    
}
