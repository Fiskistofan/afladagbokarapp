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

struct TourStatsModel{
    
    static let catchStatisticsKey = "catchStatistics"
    static let catchSumKey = "catchSum"
    static let smallCatchSumKey = "smallCatchSum"
    static let speciesCountKey = "speciesCount"
    static let totalPullsKey = "totalPulls"
    static let fishSpeciesTotalCatchListKey = "fishSpeciesTotalCatchList"
    static let otherAnimalsCatchListKey = "mammalAndBirdsTotalCatchList"
    static let otherSpeciesKey = "otherSpecies"
    static let fishSpeciesKey = "fishSpecies"
    static let landingPortKey = "landingPort"
    static let landingDateKey = "landingDate"
    static let tourCatchDetailDtoKey = "tourCatchDetailDto"
    static let colorCodeKey = "colorCode"
    
    
    public var catchSum = 0.0
    public var smallCatchSum = 0.0
    public var speciesCount = 0
    public var totalPulls = 0
    public var fishSpeciesList: [FishSpeciesCatch]
    public var landingPort = ""
    public var landingDate = ""
    public var otherSpeciesList: [AnimalsSpeciesCatch]
}

extension TourStatsModel: JSONInitable{
    
    init?(json: JSON) {
        let formatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "is_IS")
        
        guard let tourCatchDetailDto = json[TourStatsModel.tourCatchDetailDtoKey] as? JSON else {
            return nil
        }
        
        guard let catchSum = tourCatchDetailDto[TourStatsModel.catchSumKey] as? Double else{
            return nil
        }
        guard let smallCatchSum = tourCatchDetailDto[TourStatsModel.smallCatchSumKey] as? Double else{
            return nil
        }
        guard let speciesCount = tourCatchDetailDto[TourStatsModel.speciesCountKey] as? Int else{
            return nil
        }
        guard let totalPulls = tourCatchDetailDto[TourStatsModel.totalPullsKey] as? Int else{
            return nil
        }
        
        guard let landingPort = tourCatchDetailDto[TourStatsModel.landingPortKey] as? String else{
            return nil
        }
        
        guard let landingDate = tourCatchDetailDto[TourStatsModel.landingDateKey] as? String, let date = formatter.date(from: landingDate) else{
            return nil
        }
        
        let fishSpeciesList = tourCatchDetailDto[TourStatsModel.fishSpeciesTotalCatchListKey] as? [JSON] ?? []
        
        let otherSpeciesList = tourCatchDetailDto[TourStatsModel.otherAnimalsCatchListKey] as? [JSON] ?? []
        
        formatter.dateFormat = "dd. MMMM yyyy"
        
        self.landingPort = landingPort
        self.landingDate = formatter.string(from: date)
        self.smallCatchSum = smallCatchSum
        self.speciesCount = speciesCount
        self.totalPulls = totalPulls
        self.catchSum = catchSum
        self.fishSpeciesList = fishSpeciesList.compactMap{ FishSpeciesCatch(json: $0) }
        self.otherSpeciesList = otherSpeciesList.compactMap{ AnimalsSpeciesCatch(json: $0) }
    }
}

struct FishSpeciesCatch{
    
    static let fishSpeciesKey = "fishSpecies"
    static let idKey = "id"
    static let speciesNameKey = "speciesName"
    static let weightKey = "weight"
    static let colorCodeKey = "colorCode"
    static let guttedKey = "gutted"
    static let releasedKey = "released"
    static let smallFishKey = "smallFish"
    
    var fishSpecies: FishSpeciesModel?
    var weight = 0.0
    var gutted = false
    var released = false
    var smallFish = false
    var colorCode = ""
}

extension FishSpeciesCatch: JSONInitable{
    
    init?(json: JSON) {
        
        guard let fishSpecies = json[FishSpeciesCatch.fishSpeciesKey] as? JSON else{
            return nil
        }
        
        guard let weight = json[FishSpeciesCatch.weightKey] as? Double else{
            return nil
        }
        
        guard let colorCode = json[FishSpeciesCatch.colorCodeKey] as? String else{
            return nil
        }
        
        guard let released = json[FishSpeciesCatch.releasedKey] as? Bool else{
            return nil
        }
        
        guard let smallFish = json[FishSpeciesCatch.smallFishKey] as? Bool else{
            return nil
        }
        
        guard let gutted = json[FishSpeciesCatch.guttedKey] as? Bool else{
            return nil
        }
        
        self.colorCode = colorCode
        self.fishSpecies = FishSpeciesModel(json: fishSpecies)
        self.weight = weight
        self.released = released
        self.smallFish = smallFish
        self.gutted = gutted
    }
}

struct AnimalsSpeciesCatch{
    
    static let otherSpeciesKey = "otherSpecies"
    static let speciesNameKey = "speciesName"
    static let countKey = "count"
    
    var otherSpecies: AnimalSpeciesModel
    var count = 0
}

extension AnimalsSpeciesCatch: JSONInitable{
    
    init?(json: JSON) {
        
        guard let otherSpecies = json[AnimalsSpeciesCatch.otherSpeciesKey] as? JSON else{
            return nil
        }
        
        guard let count = json[AnimalsSpeciesCatch.countKey] as? Int else {
            return nil
        }

        guard let species = AnimalSpeciesModel(json: otherSpecies) else{
            return nil
        }
        self.otherSpecies = species
        self.count = count
    }
}
