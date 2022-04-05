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


enum ControllerType{
    
    case time
    case animals
}

enum Animal{
    
    case fish
    case mammalsAndBirds
}

class AddAfliViewModel{
    
    let descritpion = Observable<String>("")
    let title = Observable<String>("")
    let type: ControllerType
    let btnIsSelected = Observable<Bool>(true)
    var arrPullsToLog = Observable<[Pull]>([])
    let arrData = Observable<[CheckboxCellViewModel]>([])
    let btnTitle = Observable<String>("ÁFRAM")
    
    init(type: ControllerType){
        
        self.type = type
        if type == .time{
            descritpion.value = Texts.fromWhere
            title.value = Texts.skraAfla
        }
        else{
            descritpion.value = Texts.chooseType
            title.value = Texts.estimatedFishing
        }
        fillData()
        setupBonding()
    }
    
    func setupBonding(){
        
        _ = self.arrData.observeNext{ [weak self] value in
            
            guard let this = self else{
                return
            }
            
            let arrVMsToLog = this.arrData.value.filter{ $0.isSelected.value }
            this.arrPullsToLog.value = arrVMsToLog.map { $0.pull }
            this.btnTitle.value = "Áfram " + "(" + String(this.arrPullsToLog.value.count) + " DRÖG VALIN)"
        }
    }
    
    func fillData(){
        
        let arrPulls = Session.manager.getPulls()
        _ = arrPulls.sorted(by: { $0.date > $1.date })
        
        for pull in arrPulls{
            
            let checkBoxVM = Observable<CheckboxCellViewModel>(CheckboxCellViewModel(pull: pull))
            
            _ = checkBoxVM.value.isSelected.observeNext{ [weak self] value in
                
                guard let this = self else{
                    return
                }
                
                this.updateCount()
            }
            arrData.value.append(checkBoxVM.value)
        }
        
        if type == .animals{
            descritpion.value = "Veldu tegund"
            return
        }
        
        if arrData.value.isEmpty{
            descritpion.value = "Þú hefur ekki dregið inn neinn afla."
        }
        else{
            var equipment = ""
            if let equipmentType = Session.manager.getSelectedEquipmentId() {
                equipment = EquipmentType(rawValue: equipmentType)?.name ?? ""
            }
            descritpion.value = "Skráðu afla á " + equipment
        }
    }
    
    func updateCount(){
        
        let arrVMsToLog = arrData.value.filter{ $0.isSelected.value }
        arrPullsToLog.value = arrVMsToLog.map { $0.pull }
        
        if arrPullsToLog.value.count == 1{
            btnTitle.value = "Áfram " + "(" + String(self.arrPullsToLog.value.count) + " DRAG VALIÐ)"
        }
        else{
            btnTitle.value = "Áfram " + "(" + String(self.arrPullsToLog.value.count) + " DRÖG VALIN)"
        }
    }
    
    func changeTo(value: Bool){
        _ = arrData.value.map{ $0.isCheckVisible.value = value }
    }
    
    func savePullsToLogTo(){
        //Check which viewmodels have selected status/
        //And then save the mall to the session manager
        let arrVMsToLog = arrData.value.filter{ $0.isSelected.value }
        arrPullsToLog.value = arrVMsToLog.flatMap { $0.pull }
        Session.manager.saveSelectedPullsToLogCatch(arrPullsToLog.value)
    }
    
    func didSelectAtIndexPath(_ indexPathRow: Int){
        //Clear everything because we only want 1 element when we select from the list
        arrPullsToLog.value = []
        let pull = arrData.value[indexPathRow].pull
        arrPullsToLog.value.append(pull)
        Session.manager.saveSelectedPullsToLogCatch(arrPullsToLog.value)
    }
    
    func didLogPull(pull: Pull){
        
        arrPullsToLog.value = []
        arrPullsToLog.value.append(pull)
        Session.manager.saveSelectedPullsToLogCatch(arrPullsToLog.value)
    }
    
    
    
    func getNumberOfCells() -> Int{
        
        if self.type == .time{
            return arrData.value.count
        }
        //Fish + OtherSpecies
        else{ return 2 }
    }
    
    func changeSelectedState(){
        let isAllSelected = arrData.value.allSatisfy { $0.isSelected.value }
        
        if (isAllSelected) {
            arrData.value.forEach { $0.isSelected.value = false }
            arrPullsToLog.value = []
            Session.manager.saveSelectedPullsToLogCatch([])
        } else {
            arrData.value.forEach { $0.isSelected.value = true }
            let pulls = arrData.value.map { $0.pull }
            arrPullsToLog.value = pulls
            Session.manager.saveSelectedPullsToLogCatch(pulls)
        }
    }
}
