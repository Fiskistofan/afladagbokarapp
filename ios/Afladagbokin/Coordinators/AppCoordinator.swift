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
import FirebaseAuth

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    public var tabBarController: TabBarController?
    private var reachabilityManager: ReachabilityManager!
    
    //MARK: Initialization
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        print("[AppCoordinator] - Did deinit")
    }
    
    //MARK: - Public funtions
    
    public func start() {
        let hasRunBefore = UserDefaults.standard.bool(forKey: Session.hasRunBefore)
        
        if !hasRunBefore {
            UserDefaults.standard.set(false, forKey: Session.isFishingKey)
        }
        
        let isLoggedIn = Session.manager.isLoggedIn()
       
        if isLoggedIn {
            self.mainFlow()
        } else {
            self.authenticatorFlow()
        }
    }
    
    fileprivate func onboardingFlow() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        addChildCoordinator(childCoordinator: onboardingCoordinator)
        
        onboardingCoordinator.start()
    }
    
    fileprivate func authenticatorFlow() {
        
        let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
       authenticationCoordinator.start()
        authenticationCoordinator.authenticationDelegate = self
        self.addChildCoordinator(childCoordinator: authenticationCoordinator)
    }
    
    fileprivate func mainFlow() {
        self.reachabilityManager = ReachabilityManager.sharedInstance
        
        let authService = AuthenticationService()
        authService.getUserCredentials() { [weak self] (result) in
            guard let this = self else {
                return
            }
            
            guard let model = result.model else {
                print("[AppCoordinatorError] - Could not get user profile")
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    fatalError("No AppDelegate?")
                }
                
                appDelegate.logOut()
                
                let alert = UIAlertController(title: "Villa", message: "Símanúmer er ekki skrá, vinsamlegast hafðu samband við þína útgerð.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                }))
                this.navigationController.present(alert, animated: true, completion: nil)
                return
            }
            
            print("[AppCoordinator] - Did get user profile")
            this.saveResult(model: model)
        
            let mainCoord = MainCoordinator(navigationController: this.navigationController)
            mainCoord.delegate = self
            mainCoord.start()
            this.addChildCoordinator(childCoordinator: mainCoord)
        }
    }
    
    fileprivate func saveResult(model: MeModel){
        Session.manager.savePorts(model.arrOfPortsAsDict)
        Session.manager.saveOtherSpecies(model.arrOtherSpeciesAsDict)
        Session.manager.saveFishSpecies(model.arrFishSpeciesAsDict)
        Session.manager.saveEquipment(model.arrOfFishingEquipmentsAsDict)
        
        if let ships = model.ships {
            if let ship = ships.first {
                let boatId = ship.id
                Session.manager.saveDefaultBoatId(boatId)
                Session.manager.saveSelectedBoatId(boatId)
            }
            Session.manager.saveBoats(ships)
        }
    }
}

extension AppCoordinator: AuthenticationCoordinatorDelegate {
    func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator) {
        self.removeChildCoordinator(childCoordinator: authenticationCoordinator)
        
        let hasRunBefore = UserDefaults.standard.bool(forKey: Session.hasRunBefore)
        
        if hasRunBefore {
            self.mainFlow()
        } else {
            self.onboardingFlow()
        }
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidFinishWithLogout(_ mainCoordinator: MainCoordinator) {
        Session.manager.logOut()
        FireBaseManager.sharedInstance.logOut()
        self.removeChildCoordinator(childCoordinator: mainCoordinator)
        self.authenticatorFlow()
    }
}

extension AppCoordinator: OnboardingCoordinatorDelegate {
    func onboardingCoordinatorDidFinish(_ onboardingCoordinator: OnboardingCoordinator) {
        UserDefaults.standard.set(true, forKey: Session.hasRunBefore)
        
        mainFlow()
        removeChildCoordinator(childCoordinator: onboardingCoordinator)
    }
}

