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

protocol AnimalProtocol{
    
    var id: Int { get }
    var speciesName: String { get }
    var type: Int { get }
}

struct FishSpeciesModel: AnimalProtocol{
    
    static let idKey = "id"
    static let speciesNameKey = "speciesName"
    static let typeKey = "type"
    
    public var id = 0
    public var speciesName = ""
    public var type = 0
}

extension FishSpeciesModel: JSONInitable{
    
    init?(json: JSON) {
        
        guard let id = json[FishSpeciesModel.idKey] as? Int else{
            return nil
        }
        guard let speciesName = json[FishSpeciesModel.speciesNameKey] as? String else{
            return nil
        }
        
        self.id = id
        self.speciesName = speciesName
        self.type = 0
    }
}

extension FishSpeciesModel: JSONReturnable{
    
    func toJSON() -> JSON {
        return [FishSpeciesModel.idKey : id, FishSpeciesModel.speciesNameKey: speciesName, FishSpeciesModel.typeKey : type]
    }
}

struct AnimalSpeciesModel: AnimalProtocol{
    
    static let idKey = "id"
    static let speciesNameKey = "species_name"
    
    public var id = 0
    public var speciesName = ""
    var type = 1
}

extension AnimalSpeciesModel: JSONInitable{
    
    init?(json: JSON) {
        
        guard let id = json[AnimalSpeciesModel.idKey] as? Int else{
            return nil
        }
        guard let speciesName = json[AnimalSpeciesModel.speciesNameKey] as? String else{
            return nil
        }
        
        self.id = id
        self.speciesName = speciesName
    }
}

extension AnimalSpeciesModel: JSONReturnable{
    
    func toJSON() -> JSON {
        return [AnimalSpeciesModel.idKey : id, AnimalSpeciesModel.speciesNameKey: speciesName]
    }
}
