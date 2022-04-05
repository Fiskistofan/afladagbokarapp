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

struct MeModel{
    
    static let profileKey = "profile"
    static let shipsKey = "ships"
    static let equipmentKey = "equipment"
    static let portsKey = "ports"
    static let fishSpeciesKey = "fishSpecies"
    static let otherSpeciesKey = "otherSpecies"
    static let fishingEquipmentKey = "fishingEquipments"
    
    public var profile: ProfileModel?
    public var ships: [ShipsModel]? = []
    public var equipment: [EquipmentModel]? = []
    
    public var ports: [PortModel]? = []
    public var arrOfPortsAsDict: [[String:Any]] = []
    
    public var fishSpecies: [FishSpeciesModel]? = []
    public var arrFishSpeciesAsDict: [[String:Any]] = []
    
    public var otherSpecies: [OtherSpeciesModel]? = []
    public var arrOtherSpeciesAsDict: [[String:Any]] = []
    
    public var fishingEquipments: [FishingEquipmentModel]? = []
    public var arrOfFishingEquipmentsAsDict: [[String:Any]] = []
    
}

extension MeModel: JSONInitable{
    
    init?(json: JSON) {
        
        guard let profile = json[MeModel.profileKey] as? JSON else{
            return nil
        }
        guard let ships = json[MeModel.shipsKey] as? Array<JSON> else{
            return nil
        }
        
        guard let equipments = json[MeModel.equipmentKey] as? Array<JSON> else{
            return nil
        }
        guard let ports = json[MeModel.portsKey] as? Array<JSON> else{
            return nil
        }
        guard let fishSpecies = json[MeModel.fishSpeciesKey] as? Array<JSON> else{
            return nil
        }
        guard let otherSpecies = json[MeModel.otherSpeciesKey] as? Array<JSON> else{
            return nil
        }
        
        guard let fishingEquipments = json[MeModel.fishingEquipmentKey] as? Array<JSON> else{
            return nil
        }
        
        
        self.profile = ProfileModel(json: profile)
        for ship in ships{
            if let shipElement = ShipsModel(json: ship){
                self.ships?.append(shipElement)
            }
        }
        
        for equipment in equipments{
            if let equipmentElement = EquipmentModel(json: equipment){
                self.equipment?.append(equipmentElement)
            }
        }
        
        //Create dictionary representation of ports since we need to save them to user defaults
        for port in ports{
            if let portElement = PortModel(json: port){
                self.ports?.append(portElement)
                
                let portAsDict = portElement.toJSON()
                self.arrOfPortsAsDict.append(portAsDict)
            }
        }
        
        for fishSpecie in fishSpecies{
            if let fishSpecieElement = FishSpeciesModel(json: fishSpecie){
                self.fishSpecies?.append(fishSpecieElement)
                
                let fishAsDict = fishSpecieElement.toJSON()
                self.arrFishSpeciesAsDict.append(fishAsDict)
            }
        }
        for otherSpeci in otherSpecies{
            if let otherSpeci = OtherSpeciesModel(json: otherSpeci){
                self.otherSpecies?.append(otherSpeci)
                
                let otherSpeciAsDict = otherSpeci.toJSON()
                self.arrOtherSpeciesAsDict.append(otherSpeciAsDict)
            }
        }
        for fishEquipment in fishingEquipments{
            if let fishEquipment = FishingEquipmentModel(json: fishEquipment){
                self.fishingEquipments?.append(fishEquipment)
                
                let fishEqAsDict = fishEquipment.toJSON()
                self.arrOfFishingEquipmentsAsDict.append(fishEqAsDict)
            }
        }
    }
}


