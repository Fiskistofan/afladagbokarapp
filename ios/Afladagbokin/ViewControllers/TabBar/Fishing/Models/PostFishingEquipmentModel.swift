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

struct PostFishingEquipmentModel{
    
    static let shipIdKey = "shipId"
    static let portIdKey = "portId"
    static let fishingEquipmentKey = "fishingEquipment"
    static let idKey = "id"
    static let fishingEquipmentTypeIdKey = "fishingEquipmentTypeId"
    static let numberOfBjodOnLineKey = "numberOfBjodOnLine"
    static let numberOfHooksOnLineKey = "numberOfHooksOnLine"
    static let numberOfNetsKey = "numberOfNets"
    static let heightOfMoskviOnNetKey = "heightOfMoskviOnNet"
    static let sizeOfMoskviOnNetKey = "sizeOfMoskviOnNet"
    static let numberOfHandEquipmentKey = "numberOfHandEquipment"
    
    public var shipId = ""
    public var portId = 0
    public var id: Int = 0
    public var fishingEquipmentTypeId = 0
    public var numberOfBjodOnLine: Int = 0
    public var numberOfHooksOnLine: Int = 0
    public var numberOfNets: Int = 0
    public var heightOfMoskviOnNet: Int = 0
    public var sizeOfMoskviOnNet: Int = 0
    public var numberOfHandEquipment:Int = 0
    public var fishingEquipment: [String:Any]
    
    init(shipId: String, portId: Int, fishingEquipmentTypeId: Int, numberOfBjodOnLine: Int?, numberOfHooksOnLine: Int?, numberOfNets: Int?, heightOfMoskviOnNet: Int?, sizeOfMoskviOnNet: Int?, numberOfHandEquipment: Int?){
        
        self.shipId = shipId
        self.portId = portId
        self.fishingEquipmentTypeId = fishingEquipmentTypeId
        
        if let numberOfBjod = numberOfBjodOnLine{
            if numberOfBjod != 0{
                self.numberOfBjodOnLine = numberOfBjod
            }
        }
        
        if let hooks = numberOfHooksOnLine{
            if hooks != 0{
                self.numberOfHooksOnLine = hooks
            }
        }
        
        if let nets = numberOfNets {
            if nets != 0{
                self.numberOfNets = nets
            }
        }
        
        if let heightMoskvi = heightOfMoskviOnNet{
            if heightMoskvi != 0{
                self.heightOfMoskviOnNet = heightMoskvi
            }
        }
        
        if let sizeMoskviOnNet = sizeOfMoskviOnNet{
            if sizeMoskviOnNet != 0{
                self.sizeOfMoskviOnNet = sizeMoskviOnNet
            }
        }
        
        if let handEq = numberOfHandEquipment{
            if handEq != 0{
                self.numberOfHandEquipment = handEq
            }
        }
        
        self.fishingEquipment = [PostFishingEquipmentModel.idKey: self.id,
                                 PostFishingEquipmentModel.shipIdKey : self.shipId,
                                 PostFishingEquipmentModel.fishingEquipmentTypeIdKey : self.fishingEquipmentTypeId,
                                 PostFishingEquipmentModel.numberOfBjodOnLineKey : self.numberOfBjodOnLine,
                                 PostFishingEquipmentModel.numberOfHooksOnLineKey : self.numberOfHooksOnLine,
                                 PostFishingEquipmentModel.numberOfNetsKey : self.numberOfNets,
                                 PostFishingEquipmentModel.heightOfMoskviOnNetKey : self.heightOfMoskviOnNet,
                                 PostFishingEquipmentModel.sizeOfMoskviOnNetKey : self.sizeOfMoskviOnNet,
                                 PostFishingEquipmentModel.numberOfHandEquipmentKey : self.numberOfHandEquipment]
        
    }
}

extension PostFishingEquipmentModel: JSONReturnable{

    func toJSON() -> JSON {
        return [PostFishingEquipmentModel.shipIdKey : self.shipId, PostFishingEquipmentModel.portIdKey : self.portId, PostFishingEquipmentModel.fishingEquipmentKey : self.fishingEquipment]
    }
}

