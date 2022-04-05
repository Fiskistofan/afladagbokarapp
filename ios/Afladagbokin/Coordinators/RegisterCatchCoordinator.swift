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
import UIKit

protocol RegisterCatchCoordinatorDelegate: class {
    func registerCatchCoordinatorWantsToShowTabbar(_ registerCatchCoordinator: RegisterCatchCoordinator)
    func registerCatchCoordinatorWantsToHideTabbar(_ registerCatchCoordinator: RegisterCatchCoordinator)
}

class RegisterCatchCoordinator: Coordinator {
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    let navController = AfliNavigationController()
    weak var delegate: RegisterCatchCoordinatorDelegate?
    
    func start() {
        let catchController = AfliViewController(delegate: self)
        catchController.tabBarItem.title = "Afli"
        catchController.tabBarItem.image = Asset.book.image
        navController.pushViewController(catchController, animated: false)
    }
}


// MARK: - AfliViewControllerDelegate
extension RegisterCatchCoordinator: AfliViewControllerDelegate {
    /**
     */
    func addAfli() {
        let addCatchVM = AddAfliViewModel(type: .time)
        let addCatchController = AddAfliViewController(delegate: self, viewModel: addCatchVM)
        navController.pushViewController(addCatchController)
    }
    
    /**
     */
    func showTab(){
        delegate?.registerCatchCoordinatorWantsToShowTabbar(self)
    }
    
    /**
     */
    func editAfli(catchToEdit: Catch){
        let isFish = catchToEdit.type == 0
        Session.manager.saveIsLoggedAfliFish(isFish)
        
        let logVM = LogAfliViewModel()
        let logCatchController = LogAfliViewController(delegate: self, viewModel: logVM)
        logVM.setupForEditWithCatch(catchToEdit)
        navController.pushViewController(logCatchController, completion: nil)
    }
}


// MARK: - LogAfliViewControllerDelegate
extension RegisterCatchCoordinator: LogAfliViewControllerDelegate {
    /**
     */
    func updateWeightByAdding(catchWeight: Double){
        let oldTotalWeight = Session.manager.getTotalLoggedCatchWeight()
        let newTotalWeight = catchWeight + oldTotalWeight
        Session.manager.setTotalLoggedCatchWeight(newTotalWeight)
    }
    
    /**
     */
    fileprivate func handleLogging(_ _catch: Catch, updatePull pull: Pull) {
        if let editId = Session.manager.getCatchIdToEdit() {
            _catch.id = editId
        }
        
        Session.manager.saveCatch(_catch)
        
        pull.lastWeightLogDate = Date()
        //Session.manager.savePull(pull, andRegister: false)
        updateWeightByAdding(catchWeight: Double(_catch.weight))
        
        navController.popToRootViewController(animated: true)
    }
    
    /**
     */
    typealias CatchWeight = (pull: Pull, weight: Double)
    fileprivate func calculateWeights(pulls: [Pull], totalWeight: Double, forType type: Int) -> [CatchWeight] {
        let weightBase = totalWeight / Double(pulls.count)
        
        if type == 0 {
            return pulls.map { ($0, weightBase) }
        }
        
        var weightLeft = Int(totalWeight)
        let newWeightBase = Int(weightBase.rounded(.up))
        var catchWeights: [CatchWeight] = []
        
        for pull in pulls {
            let weight = Double(min(newWeightBase, weightLeft))
            
            let catchWeight = (pull, weight)
            catchWeights.append(catchWeight)
            
            weightLeft -= newWeightBase
            if weightLeft < 1 {
                break
            }
        }
        
        return catchWeights
    }
    
    /**
     */
    func didFinishLogging(animal: AnimalProtocol, isReleased: Bool, isSmallFish: Bool, isGutted: Bool, weight: Double, type: Int) {
        
        let arrPullsToLogTo = Session.manager.getSelectedPullsToLogCatch()
        let catchWeights = calculateWeights(pulls: arrPullsToLogTo, totalWeight: weight, forType: type)
            
        for catchWeight in catchWeights {
            let myCatch = Catch(pullId: catchWeight.pull.id,
                                gutted: isGutted,
                                released: isReleased,
                                smallFish: isSmallFish,
                                weight: catchWeight.weight,
                                speciesId: animal.id,
                                hasBeenLogged: false,
                                type: type)
                
            handleLogging(myCatch, updatePull: catchWeight.pull)
        }
    }
}


// MARK: - AddAfliViewControllerDelegate
extension RegisterCatchCoordinator: AddAfliViewControllerDelegate {
    /**
     */
    func didSelect(type: ControllerType, isFish: Bool) {
        if type == .animals{
            Session.manager.saveIsLoggedAfliFish(isFish)
            let logVM = LogAfliViewModel()
            let logAfliVC = LogAfliViewController(delegate: self, viewModel: logVM)
            navController.pushViewController(logAfliVC, completion: nil)
        }
        else if type == .time{
            let addCatchVM = AddAfliViewModel(type: .animals)
            let addCatchController = AddAfliViewController(delegate: self, viewModel: addCatchVM)
            navController.pushViewController(addCatchController)
        }
    }
    
    /**
     */
    func goBack() {
        navController.popViewController()
    }
    
    /**
     */
    func hideTabBar() {
        delegate?.registerCatchCoordinatorWantsToHideTabbar(self)
    }
}
