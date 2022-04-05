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

class LogAfliViewModel{
    
    let arrAnimalData = Observable<[AnimalProtocol]>([])
    let arrFilteredData = Observable<[AnimalProtocol]>([])
    let numberOfSections = Observable<Int>(1)
    let selectedAnimalId = Observable<Int>(0)
    var selectedAnimalName: String?
    var isLuda = Observable<Bool>(false)
    let weightViewModel = LogWeightViewModel()
    let title = Observable<String>("Skrá fisk")
    var catchToEdit: Catch? = nil
    var arrBtnCellViewModels:  [BtnCellViewModel] = []
    var loggedAnimal = Observable<AnimalProtocol?>(nil)
    
    let animalWeight = Observable<Int>(0)
    
    init(){
        //Move to maincoord
        if !Session.manager.getIsLoggedAfliFish(){
            title.value = "Skrá dýr"
        }
        fillData()
        setupBonding()
        Session.manager.saveCatchIdToEdit(nil)
    }
    
    func fillData(){
        
        var mostPopularAnimalProtocol: [Dictionary<String, Int>]
        if Session.manager.getIsLoggedAfliFish(){
            
            let arrFish = Session.manager.getFishSpecies()
            arrAnimalData.value = arrFish.compactMap{ FishSpeciesModel(json: $0) }
            mostPopularAnimalProtocol = AnimalProtocolHelper.getTopFiveMostPopularFishes()
        }
        else{
            let arrOtherSpecies = Session.manager.getOtherSpecies()
            arrAnimalData.value = arrOtherSpecies.compactMap{ OtherSpeciesModel(json: $0) }
            mostPopularAnimalProtocol = AnimalProtocolHelper.getTopFiveMostPopularAnimals()
        }
        var animalProtocolToReAdd: [AnimalProtocol] = []
        
        for animalProtocolItem in mostPopularAnimalProtocol{
            
            if(!animalProtocolItem.isEmpty){
                let animalProtocolKey = animalProtocolItem.keys.first
                
                for index in stride(from: arrAnimalData.value.count - 1 , to: 0, by: -1){
                    let animalProtocol = arrAnimalData.value[index]
                    if String(animalProtocol.id) == animalProtocolKey{
                        animalProtocolToReAdd.append(arrAnimalData.value.item(at: index))
                        arrAnimalData.value.remove(at: index)
                    }
                }
            }
        }
        arrAnimalData.value.insert(contentsOf: animalProtocolToReAdd, at: 0)
        arrFilteredData.value = arrAnimalData.value
    }
    
    func setupForEditWithCatch(_ _catch: Catch){
        self.catchToEdit = _catch
        switch _catch.type {
        case 0:
            print("")
            let fish = FishSpeciesModel(id: _catch.speciesId, speciesName: Session.manager.getNameFromIDAndType(id: _catch.speciesId, type: 0), type: 0)
            weightViewModel.animalWeight.value = String(_catch.weight)
            selectedAnimalName = fish.speciesName
            selectedAnimalId.value = fish.id
        case 1:
            let otherSpecie = OtherSpeciesModel(id: _catch.speciesId, speciesName: Session.manager.getNameFromIDAndType(id: _catch.speciesId, type: 1), type: 1)
            let arrSpecies = Session.manager.getOtherSpecies()
            arrAnimalData.value = arrSpecies.compactMap{ OtherSpeciesModel(json: $0) }
            weightViewModel.animalWeight.value = String(Int(_catch.weight))
            selectedAnimalName = otherSpecie.speciesName
            selectedAnimalId.value = otherSpecie.id
        default:
            print("")
        }
        Session.manager.saveCatchIdToEdit(_catch.id)
        changeToMultiple()
    }
    
    enum animalIdValueMeaning{
        case nothingSelected
        case isLuda
        case isFishOrOtherSpecies
    }
    
    func checkSelectedAnimalId(animalId: Int) -> animalIdValueMeaning{
        if animalId == 0 { return .nothingSelected}
        if (animalId == 21 && Session.manager.getIsLoggedAfliFish()) { return .isLuda }
        else { return .isFishOrOtherSpecies }
    }
    
    func setupBonding(){
        
        _ = self.isLuda.observeNext{ [weak self] value in
            
            guard let this = self else{
                return
            }
            
            //If the selected animal is Lúða, we only have one button cell
            //Which should indicate wether or not Lúða has been released or not
            //If it's not lúða, but is an animal, we do not log down further info about the animal
            //If it's not lúða, but is a fish, we need to log down if it was gutted or undirmal(aka smallFish in the backend)
            if value{
                
                let btnCellViewModelSleppt = BtnCellViewModel(type: .sleppt)
                if let myCatch = this.catchToEdit{
                    btnCellViewModelSleppt.isBtnSelected.value = myCatch.released
                }
                this.arrBtnCellViewModels = [btnCellViewModelSleppt]
            }
            else{
                if Session.manager.getIsLoggedAfliFish(){
                    let btnCellViewModelGutted = BtnCellViewModel(type: .gutted)
                    let btnCellViewModelUndirmal = BtnCellViewModel(type: .undirmal)
                    if let myCatch = this.catchToEdit{
                        btnCellViewModelGutted.isBtnSelected.value = myCatch.gutted
                        btnCellViewModelUndirmal.isBtnSelected.value = myCatch.smallFish
                    }
                    this.arrBtnCellViewModels = [btnCellViewModelGutted, btnCellViewModelUndirmal]
                }
                else{
                    this.arrBtnCellViewModels = []
                }
            }
        }
        
        _ = selectedAnimalId.observeNext {  [weak self] (value) in
            
            guard let this = self else{
                return
            }
            
            switch this.checkSelectedAnimalId(animalId: value){
                
            case .nothingSelected:
                this.selectedAnimalName = nil
                this.changeToOneSection()
                return
            case .isLuda:
                this.isLuda.value = true
                this.changeToMultiple()
            case .isFishOrOtherSpecies:
                let btnCellViewModelGutted = BtnCellViewModel(type: .gutted)
                let btnCellViewModelUndirmal = BtnCellViewModel(type: .undirmal)
                
                if let myCatch = this.catchToEdit{
                    btnCellViewModelGutted.isBtnSelected.value = myCatch.gutted
                    btnCellViewModelUndirmal.isBtnSelected.value = myCatch.smallFish
                }
                if Session.manager.getIsLoggedAfliFish(){
                    this.arrBtnCellViewModels = [btnCellViewModelGutted, btnCellViewModelUndirmal]
                }
                else{
                    this.arrBtnCellViewModels = []
                }
                this.changeToMultiple()
            }
        }
        
        _ = weightViewModel.animalWeight.observeNext{ [weak self] value in
            
            guard let this = self else { return }
            guard this.canLogAnimalWeight(strWeight: value) else {
                return
            }
            this.setLoggedAnimal()
        }
        
    }
    
    func canLogAnimal(strWeight: String) -> Bool{
        return canLogAnimalWeight(strWeight: strWeight) && loggedAnimalHasName()
    }
    
    func setLoggedAnimal(){
        
        guard let name = selectedAnimalName else { return }
        
        if Session.manager.getIsLoggedAfliFish(){
            loggedAnimal.value = FishSpeciesModel(id: selectedAnimalId.value, speciesName: name, type: 0)
        }
        else{
            loggedAnimal.value = OtherSpeciesModel(id: selectedAnimalId.value, speciesName: name, type: 1)
        }
    }
    
    func loggedAnimalHasName() -> Bool{
        guard selectedAnimalName != nil else { return false }
        return true
    }
    
    func canLogAnimalWeight(strWeight: String) -> Bool {
        guard let weightAsDouble = Double(strWeight) else{ return false }
        guard canLogWeight(weight: weightAsDouble) else { return false }
        return true
    }
    
    func canLogWeight(weight: Double) -> Bool {
        if weight > 0 { return true }
        return false
    }
    
    
    func resetListItems(){
        arrFilteredData.value = arrAnimalData.value
    }
    
    func reset(){
        
        resetListItems()
        selectedAnimalId.value = 0
        selectedAnimalName = nil
        loggedAnimal.value = nil
    }
    
    func hasSelectedAnimalId() -> Bool{
        return selectedAnimalId.value != 0
    }
    
    func changeToMultiple(){
        //FishNameCell + FishWeightCell + btnCells + empty cell
        numberOfSections.value = 3 + self.arrBtnCellViewModels.count
    }
    
    func changeToOneSection(){
        numberOfSections.value = 1
    }
    
    func shouldRespondToRowClick() -> Bool {
        
        if numberOfSections.value == 1 { return true }
        return false
    }
    
    func shouldPopScreen() -> Bool{
        
        if (selectedAnimalId.value == 0) { return true }
        return false
    }
    
    func formatSearchString(_ strSearch: String) -> String{
        return strSearch.lowercased()
    }
    
    func configureFilteredArrayBasedOnSearchText(searchText: String){
        
        let lowercaseSearch = searchText.lowercased()
        let nonIcelandicSearchText = self.replaceIcelandicCharsWithEnglishChar(strToReplace: lowercaseSearch)
        
        arrFilteredData.value = searchText.isEmpty ? arrAnimalData.value : arrAnimalData.value.filter { (item: AnimalProtocol) -> Bool in

            let lowercasedName = item.speciesName.lowercased()
            let nonIcelandicItemName = self.replaceIcelandicCharsWithEnglishChar(strToReplace: lowercasedName)
            
            return ( (listItemContainsSearchText(searchText, itemName: item.speciesName)) || listItemContainsSearchText(nonIcelandicSearchText, itemName: nonIcelandicItemName) )
            
        }
    }
    
    func listItemContainsSearchText(_ searchText: String, itemName: String) -> Bool{
        
        return (itemName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
    }
    
    func shouldShowCancelButtonForSearchText(_ searchText: String) -> Bool{
        return !searchText.isEmpty
    }
    
    func replaceIcelandicCharsWithEnglishChar(strToReplace: String) -> String{
        
        let newString = strToReplace
            .replacingOccurrences(of: "ý", with: "y")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "æ", with: "ae")
            .replacingOccurrences(of: "þ", with: "th")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "á", with: "a")
        return newString
    }
}
