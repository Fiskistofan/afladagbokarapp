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

struct EquipmentModel{
    
    static let idKey = "id"
    static let shipIdKey = "shipId"
    static let fishingEquipmentTypeIdKey = "fishingEquipmentTypeId"
    static let numberOfBjodOnLineKey = "numberOfBjodOnLine"
    static let numberOfHooksOnLineKey = "numberOfHooksOnLine"
    static let numberOfNetsKey = "numberOfNets"
    static let heightOfMoskviOnNetKey = "heightOfMoskviOnNet"
    static let sizeOfMoskviOnNetKey = "sizeOfMoskviOnNet"
    static let numberOfHandEquipmentKey = "numberOfHandEquipment"
    
    public var id = 0
    public var shipId = 0
    public var fishingEquipmentTypeId = 0
    public var numberOfBjodOnLine = 0
    public var numberOfHooksOnLine = 0
    public var numberOfNetsKey = 0
    public var numberOfMoskviOnNet = 0
    public var heightOfMoskviOnNet = 0
    public var sizeOfMoskviOnNet = 0
    public var numberOfHandEquipment = 0
}

extension EquipmentModel: JSONInitable{
    init?(json: JSON) {
        guard let id = json[EquipmentModel.idKey] as? Int else{
            return nil
        }
        
        guard let shipId = json[EquipmentModel.shipIdKey] as? Int else{
            return nil
        }
        
        guard let fishingEquipmentTypeId = json[EquipmentModel.fishingEquipmentTypeIdKey] as? Int else{
            return nil
        }
        
        self.id = id
        self.shipId = shipId
        self.fishingEquipmentTypeId = fishingEquipmentTypeId
        Session.manager.saveDefaultEquipmentTypeId(self.fishingEquipmentTypeId)
        
        if let numberOfBjodOnLine = json[EquipmentModel.numberOfBjodOnLineKey] as? Int {
            Session.manager.saveBjodaCount(numberOfBjodOnLine)
        }
        
        if let numberOfHooksOnLine = json[EquipmentModel.numberOfHooksOnLineKey] as? Int {
            Session.manager.saveOnglaCount(numberOfHooksOnLine)
        }
        
        if let numberOfNets = json[EquipmentModel.numberOfNetsKey] as? Int {
            Session.manager.saveNetCount(numberOfNets)
        }
        
        if let heightOfMoskviOnNet = json[EquipmentModel.heightOfMoskviOnNetKey] as? Int {
            Session.manager.saveNetHeight(heightOfMoskviOnNet)
        }
        
        if let sizeOfMoskviOnNet = json[EquipmentModel.heightOfMoskviOnNetKey] as? Int {
            Session.manager.saveNetSize(sizeOfMoskviOnNet)
        }
        
        if let numberOfHandEquipment = json[EquipmentModel.numberOfHandEquipmentKey] as? Int {
            Session.manager.saveHandfaeriCount(numberOfHandEquipment)
        }
    }
}

extension EquipmentModel: JSONReturnable{
    
    func toJSON() -> JSON {
        return [EquipmentModel.idKey : self.id, EquipmentModel.shipIdKey : shipId, EquipmentModel.fishingEquipmentTypeIdKey : fishingEquipmentTypeId]
    }
    
    
}
