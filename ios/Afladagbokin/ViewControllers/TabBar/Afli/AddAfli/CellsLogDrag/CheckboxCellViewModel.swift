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

class CheckboxCellViewModel{
    
    
    let date = Observable<Date>(Date())
    let lastLoggedDate = Observable<Date?>(nil)
    let detailText = Observable<String>("")
    let isSelected = Observable<Bool>(false)
    let type = Observable<EquipmentType>(.lina)
    let strHour =  Observable<String>("")
    let strMinute = Observable<String>("")
    let strHourLastLogged = Observable<String>("")
    let strMinuteLastLogged = Observable<String>("")
    let combinedInitialDate = Observable<String>("")
    let weightLogged = Observable<Int>(0)
    let strWeightLogged = Observable<String>("")
    let isCheckVisible = Observable<Bool>(false)
    let pull: Pull
    
    init(pull: Pull){
        
        self.date.value = pull.date
        self.pull = pull
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateStyle = .long
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self.date.value)
        if let hour = comp.hour, let minute = comp.minute{
            
            var strMinute = ""
            //what the fuck dateformatter
            if minute < 10{
                strMinute = "0" + String(minute)
            }
            else{
                strMinute = String(minute)
            }
            
            self.strHour.value = String(hour)
            self.strMinute.value = strMinute
            let combined = "Afli kl " + self.strHour.value + ":" + self.strMinute.value
            self.combinedInitialDate.value = combined
        }
        
        
        if let lastLoggedDate = self.lastLoggedDate.value{
            
            let comp = calendar.dateComponents([.hour, .minute], from: lastLoggedDate)
            if let hour = comp.hour, let minute = comp.minute{
                self.strHourLastLogged.value = String(hour)
                self.strMinuteLastLogged.value = String(minute)
                let combined = self.strHourLastLogged.value + self.strMinuteLastLogged.value
                self.combinedInitialDate.value = combined
            }
        }
        
        // Detail Text
        let catchText = pull.catches.isEmpty
            ? "Enginn afli skráður"
            : "Afli skráður" + pull.catches
                .map({ (Session.manager.getNameFromIDAndType(id: $0.speciesId, type: $0.type), $0.weight) })
                .map( { "\n\($0) — \($1)"})
                .joined(separator: "")
        self.detailText.value = "Net dregin: \(pull.count) - \(catchText)"
        
        
        let tosses = Session.manager.getTosses()
        
        for toss in tosses{
            for somePull in toss.pulls{
                if pull.id == somePull.id{
                    self.type.value = toss.type
                    break
                }
            }
        }
    }
    
    
    typealias ImageDimension = (width: CGFloat, height: CGFloat)
    func getImageDimensionsFromType(_ type: EquipmentType.BaseType) -> ImageDimension {
        
        switch type {

        case .lina:
            return (24, 64)
        case .net:
            return (30, 30)
        case .handfaeri:
            return (30, 48)
        }
        
    }
    
    func btnTap(){
        
        self.isSelected.value = !self.isSelected.value
    }
    
    func setLogDate(_ date: Date, loggedWeight: Int){
        self.lastLoggedDate.value = date
        self.weightLogged.value = loggedWeight
    }
}
