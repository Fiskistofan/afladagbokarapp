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
import ReactiveKit
import Bond

class AfliViewModel{
    
    let arrData = Observable<[Catch]>([])
    
    init(){
        
        fillData()
    }
    
    func fillData(){
        
        print("")
        self.arrData.value = Session.manager.getCatches(uniqueIds: true)
        
        _ = self.arrData.value.sorted(by: { $0.pullId > $1.pullId })
        
        print("")
    }
    
    func getPullLogDateFromCatchPullId(_ catchPullId: String) -> String{
        
        let arrPulls = Session.manager.getPulls()
        let arrPullsThatContainCatch = arrPulls.filter{ $0.id == catchPullId }
        
        if !arrPullsThatContainCatch.isEmpty{
            
            if let pull = arrPullsThatContainCatch.first, let logDate = pull.lastWeightLogDate{
                
                let returnString = getLastPullDateAsString(date: logDate)
                return returnString
            }
        }
        return ""
    }
    
    func getLastPullDateAsString(date: Date) -> String{
        let formatter = DateFormatter(withFormat: "dd. MMMM yyyy", locale: "is_IS")
        
        return formatter.string(from: date)
    }
}

public extension String{
    
    func getIcelandicName() -> String{
        
        if self == "January"{
            return "Janúar"
        }
        if self == "February"{
            return "Febrúar"
        }
        if self == "March"{
            return "Mars"
        }
        if self == "April"{
            return "Apríl"
        }
        if self == "May"{
            return "Maí"
        }
        if self == "June"{
            return "Juní"
        }
        if self == "July"{
            return "Julí"
        }
        if self == "August"{
            return "Ágúst"
        }
        if self == "September"{
            return "September"
        }
        if self == "October"{
            return "Október"
        }
        if self == "November"{
            return "Nóvember"
        }
        if self == "December"{
            return "Desember"
        }
        return self
    }
}
