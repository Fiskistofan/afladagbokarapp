// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

enum EquipmentType: Int {
    case skotuselsNet = 1
    case þorskfiskNet = 2
    case grasleppuNet = 3
    case raudmagaNet = 4
    case lina = 12
    case landbeittLina = 13
    case handfaeri = 14
    case linutrekt = 21
        
    var name: String {
        switch self {
        case .skotuselsNet: return "Skötuselsnet"
        case .þorskfiskNet: return "Þorskfisknet"
        case .grasleppuNet: return "Grásleppunet"
        case .raudmagaNet: return "Rauðmaganet"
        case .lina: return "Lína"
        case .landbeittLina: return "Landbeitt lína"
        case .handfaeri: return "Handfæri"
        case .linutrekt: return "Línutrekt"
        }
    }
    
    var baseType: BaseType {
        switch self {
        case .lina, .landbeittLina, .linutrekt:
            return .lina
        case .grasleppuNet, .raudmagaNet, .skotuselsNet, .þorskfiskNet:
            return .net
        case .handfaeri:
            return .handfaeri
        }
    }
    
    enum BaseType: String {
        case lina = "LINE"
        case net = "NET"
        case handfaeri = "HAND"
        
        var img: UIImage{
            
            switch self {
            case .lina:
                return Asset.fishingLine.image
            case .handfaeri:
                return Asset.fishHook.image
            case .net:
                return Asset.net.image
            }
        }
    }
    
    
}
