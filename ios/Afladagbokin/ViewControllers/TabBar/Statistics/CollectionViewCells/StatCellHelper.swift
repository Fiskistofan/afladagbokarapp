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

enum lastTripIndexPathType{
    
    case forLastTripCell
    case forEmptyCell
    case forColorLine
    case forStatsSpeciesOther
    case forStatsSpeciesFish
}

enum periodIndexPathType{
    
    case forClearCell
    case forDateCellFrom
    case forDateCellTo
    case forDateBtnCell
}

enum pastTripIndexPathType{
    
    case forDefaultCell
    case forTripCell
    case forEmptyCell
}

struct StatCellHelper{
    
    static func getCellType(indexPath: IndexPath, model: TourStatsModel?, arrSpecies: [FishSpeciesCatch], arrOtherSpecies: [AnimalsSpeciesCatch]) -> lastTripIndexPathType{
        
        if indexPath.row == 0 {
            
            guard model != nil else{
                return .forEmptyCell
            }
            return .forLastTripCell
        }
        else if indexPath.row == 1 {
            return .forColorLine
        }
        else if (indexPath.row > arrSpecies.count + 1){
            return .forStatsSpeciesOther
        }
        else{
            return .forStatsSpeciesFish
        }
    }
    
    static func getPeriodCellType(indexPath: IndexPath) -> periodIndexPathType{
        
        if indexPath.row == 0 {
            return .forClearCell
        }
        else if indexPath.row == 1{
            return .forDateCellFrom
        }
        else if indexPath.row == 2{
            return .forDateCellTo
        }
        return .forDateBtnCell
    }
    
    static func getPastTripType(indexPath: IndexPath, model: TourStatsModel?) -> pastTripIndexPathType{
        
        guard model != nil else{
            return .forEmptyCell
        }
        if indexPath.row == 0{
            return .forDefaultCell
        }
        return .forTripCell
    }
}
