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

struct AnimalProtocolHelper{
    
    static func addSelectedFishToDB(fishId: Int){
        Session.manager.addToPreviouslySelectedFishDict(fishId: fishId)
    }
    
    static func getTopFiveMostPopularFishes() -> [Dictionary<String, Int>]{
        
        let dictPrevSelectedFishes = Session.getPrevSelectedFishDict()
        let arrTopFive = AnimalProtocolHelper.getTopFiveMostPopularAnimalProtocol(dictProtocol: dictPrevSelectedFishes)
        return arrTopFive.reversed()
    }
    
    static func getTopFiveMostPopularAnimals() -> [Dictionary<String, Int>]{
        
        let dictPrevSelectedFishes = Session.getPrevSelectedAnimalDict()
        let arrTopFive = AnimalProtocolHelper.getTopFiveMostPopularAnimalProtocol(dictProtocol: dictPrevSelectedFishes)
        return arrTopFive.reversed()
    }
    
    static func getTopFiveMostPopularAnimalProtocol(dictProtocol: Dictionary<String,Int>) -> [Dictionary<String, Int>]{
        
        let sortedDict = dictProtocol.sorted(by: { $0.0 < $1.0 } )
        var arrTopFiveMostPopular = [Dictionary<String, Int>]()
        
        for (key, value) in sortedDict{
            let dict = [key : value]
            arrTopFiveMostPopular.append(dict)
        }
        //arrTopFiveMostPopular.reverse()
        let first5 = Array(arrTopFiveMostPopular.prefix(5))
        return first5
    }
    
    static func addSelectedAnimalToDB(animalId: Int){
        Session.manager.addToPreviouslySelectedAnimalDict(animalId: animalId)
    }
}
