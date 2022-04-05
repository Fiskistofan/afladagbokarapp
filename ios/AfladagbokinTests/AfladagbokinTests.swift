// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import XCTest
@testable import Afladagbokin

class AfladagbokinTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTxtFieldLength3(){
        
        let authVM = AuthenticationViewModel()
        let str = "123"
        let replacementStr = ""
        XCTAssertTrue(authVM.shouldChangeCharactersInRangeForText(textfieldText: str, replacementString: replacementStr))
    }
    
    func testTxtFieldLength8(){
        
        let authVM = AuthenticationViewModel()
        let str = "858 7982"
        let replacementStr = ""
        XCTAssertTrue(authVM.shouldChangeCharactersInRangeForText(textfieldText: str, replacementString: replacementStr))
    }
    
    func testTxtFieldLength8AndRepalcementStr(){
        
        let authVM = AuthenticationViewModel()
        let str = "858 7982"
        let replacementStr = "9"
        XCTAssertFalse(authVM.shouldChangeCharactersInRangeForText(textfieldText: str, replacementString: replacementStr))
    }
    
    func testSaveAndLoadUserToken(){
        
        let token = "someFuckingToken"
        Session.manager.saveUserToken(token)
        let loadedToken = Session.manager.userToken()
        XCTAssertEqual(token, loadedToken)
    }
    
    func testAddAfliViewModelInitialization(){
        
        let addAfliVMAnimal = AddAfliViewModel(type: .animals)
        let addAfliVMTime = AddAfliViewModel(type: .time)
        XCTAssertEqual(addAfliVMAnimal.type, .animals)
        XCTAssertEqual(addAfliVMTime.type, .time)
    }
    
    func testStatisticsVMInitialization(){
        
        let statsVM = StatisticsViewModel(type: .pushed)
        let statsVMNormal = StatisticsViewModel(type: .standard)
        
        XCTAssertEqual(statsVM.getNumberOfItemsForCollectionView(), 1)
        XCTAssertEqual(statsVMNormal.getNumberOfItemsForCollectionView(), 3)
    }
    
    func testSetActivePage(){
        
        let statsVM = StatisticsViewModel(type: .pushed)
        statsVM.setActivePage(activePage: -5)
        XCTAssertTrue(statsVM.activePage.value > -1)
        statsVM.setActivePage(activePage: 0)
        XCTAssertEqual(statsVM.activePage.value, 0)
        statsVM.setActivePage(activePage: 6)
        XCTAssertTrue(statsVM.activePage.value < 6)
    }
    
    //MARK: LogAfliViewModelTest
    func testcheckSelectedAnimalId(){
        
        let vM = prepareMockForAfli()
        
        XCTAssertEqual(vM.checkSelectedAnimalId(animalId: 0), .nothingSelected, "Should ")
        XCTAssertEqual(vM.checkSelectedAnimalId(animalId: 1), .isFishOrOtherSpecies)
        XCTAssertEqual(vM.checkSelectedAnimalId(animalId: 21), .isLuda)
    }
    
    func testAfliVMReset(){
        
        let vM = prepareMockForAfli()
        XCTAssertTrue(vM.loggedAnimalHasName())
        XCTAssertTrue(vM.canLogAnimal(strWeight: vM.weightViewModel.animalWeight.value))
        
        vM.arrFilteredData.value = []
        vM.reset()
        XCTAssertTrue(vM.arrFilteredData.value.first?.id == 1)
        XCTAssertTrue(vM.arrFilteredData.value[1].id == 2)
    }
    
    func prepareMockForAfli() -> LogAfliViewModel{
        
        let thorskur = FishSpeciesModel.init(id: 1, speciesName: "Þorskur", type: 1)
        let ysa = FishSpeciesModel.init(id: 2, speciesName: "Ýsa", type: 1)
        let arrFish = [thorskur, ysa]
        let mockedViewModel = LogAfliViewModel()
        mockedViewModel.arrAnimalData.value = arrFish
        Session.manager.saveIsLoggedAfliFish(true)
        mockedViewModel.selectedAnimalId.value = 1
        mockedViewModel.selectedAnimalName = "Þorskur"
        mockedViewModel.weightViewModel.animalWeight.value = "50"
        return mockedViewModel
    }
}
