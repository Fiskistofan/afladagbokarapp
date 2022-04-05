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
import StokkurUtls

protocol MainCoordinatorDelegate: class {
    func mainCoordinatorDidFinishWithLogout(_ mainCoordinator: MainCoordinator)
}

class MainCoordinator: NSObject, Coordinator{
    var navigationController: UINavigationController
    
    
    public weak var delegate: MainCoordinatorDelegate?
    var gdprHelper: GDPRHelper? = nil
    
    let statisticsNavController: BaseNavigationController!
    var statsVC: StatsViewController? = nil
    
    let boatNavController: BaseNavigationController!
    var boatVC: BoatViewController? = nil
    
    let veidiNavController: BaseNavigationController!
    var veidiVC: FishingViewController? = nil
    
    //let afliNavController: BaseNavigationController!
    //var afliVC: AfliViewController? = nil
    
    let moreNavController: BaseNavigationController!
    var moreVC: MoreViewController? = nil
    
    lazy var tabBarController: TabBarController = {
        let tabBarViewModel = TabBarViewModel()
        return TabBarController(viewModel: tabBarViewModel)
    }()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.statisticsNavController = BaseNavigationController()
        self.boatNavController = BaseNavigationController()
        self.veidiNavController = BaseNavigationController()
        self.moreNavController = BaseNavigationController()
    }
    
    deinit {
        print("[MainCoordinator] - Did deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        let catchCoordinator = RegisterCatchCoordinator(navigationController: navigationController)
        catchCoordinator.delegate = self
        addChildCoordinator(childCoordinator: catchCoordinator)
        catchCoordinator.start()
        
        self.tabBarController.setViewControllers([statisticsNavController, boatNavController, veidiNavController, catchCoordinator.navController, moreNavController], animated: false)
        
        let textAdjustmentX: CGFloat = 15
        let kImageAdjustmentX: CGFloat = 5
        
        let textAdjustment: CGFloat = -15
        let kImageAdjustment: CGFloat = -5
        
        let statsVM = StatisticsViewModel(type: .standard)
        self.statsVC = StatsViewController(viewModel: statsVM, delegate: self)
        self.statsVC?.tabBarItem.title = "Tölfræði"
        self.statsVC?.tabBarItem.image = Asset.statisticsTab.image
        self.statisticsNavController.viewControllers = [self.statsVC!]
        
        let boatViewModel = BoatViewModel()
        self.boatVC = BoatViewController(viewModel: boatViewModel)
        self.boatVC?.tabBarItem.title = "Bátar"
        self.boatVC?.tabBarItem.image = Asset.boats.image
        
        self.boatVC?.delegate = self
        self.boatNavController.viewControllers = [boatVC!]
        
        let fishVM = FishingViewModel()
        self.veidiVC = FishingViewController(viewModel: fishVM)
        self.veidiVC?.delegate = self
        
        self.veidiVC?.tabBarItem.title = ""
        
        self.veidiVC?.tabBarItem.image = Asset.start.image
        self.veidiNavController.viewControllers = [self.veidiVC!]
//        
//        self.afliVC = AfliViewController(delegate: self)
//        self.afliVC?.tabBarItem.title = "Afli"
//        self.afliVC?.tabBarItem.image = Asset.book.image
//
//        self.afliNavController.viewControllers = [self.afliVC!]
        
        let moreVM = MoreViewModel()
        self.moreVC = MoreViewController(viewModel: moreVM)
        self.moreVC?.delegate = self
        self.moreVC?.tabBarItem.title = "Meira"
        self.moreVC?.tabBarItem.image = Asset.more.image
        
        self.moreNavController.viewControllers = [self.moreVC!]
        
        
//        if UIDevice.current.iPhoneX{
//            self.statsVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustmentX, 0, -kImageAdjustmentX, 0)
//            self.boatVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustmentX, 0, -kImageAdjustmentX, 0)
//            self.veidiVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustmentX, 0, -kImageAdjustmentX, 0)
//            self.moreVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustmentX, 0, -kImageAdjustmentX, 0)
//            self.statsVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustmentX)
//            self.boatVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustmentX)
//            self.veidiVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustmentX)
//            self.afliVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustmentX)
//            self.moreVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustmentX)
//        }
//        else{
//            self.statsVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustment, 0, -kImageAdjustment, 0)
//            self.boatVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustment, 0, -kImageAdjustment, 0)
//            self.veidiVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustment, 0, -kImageAdjustment, 0)
//            self.moreVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustment, 0, -kImageAdjustment, 0)
//            self.afliVC?.tabBarItem.imageInsets = UIEdgeInsetsMake(kImageAdjustment, 0, -kImageAdjustment, 0)
//            self.statsVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustment)
//            self.boatVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustment)
//            self.veidiVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustment)
//            self.afliVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustment)
//            self.moreVC?.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: textAdjustment)
//        }
        
        self.tabBarController.delegate = self
        self.tabBarController.delegateBtn = self
        self.tabBarController.selectedIndex = 2
        
        navigationController.pushViewController(tabBarController, animated: false)
        
        manageGDPR()
    }
    
    public func hideTabbar(){
        
        UIView.animate(withDuration: 0.5) {
            self.tabBarController.tabBar.alpha = 0.0
            self.tabBarController.btnRegular?.alpha = 0.0
            self.tabBarController.btnRed?.alpha = 0.0
            self.tabBarController.btnGreen?.alpha = 0.0
        }
    }
    
    public func showTabBar(){
        UIView.animate(withDuration: 0.5) {
            
            self.tabBarController.btnRegular?.alpha = 1.0
            self.tabBarController.btnRed?.alpha = 1.0
            self.tabBarController.btnGreen?.alpha = 1.0
            self.tabBarController.tabBar.alpha = 1.0
            print("")
        }
    }
}

// MARK: - GDPR
extension MainCoordinator: ConfirmTourViewDelegate{
    
    func manageGDPR(){
        
        let gdprService = GDPRService()
        self.gdprHelper = GDPRHelper(withGDPRResponseDelegate: self)
        gdprService.fetchGDPRCompliance { [weak self] (needsAccept, id, url) in
            
            guard let this = self else { return }
            guard let helper = this.gdprHelper else { return }
            if (needsAccept){
                guard let policyId = id, let policyURL = url else { return }
                helper.saveGDPR(policyID: policyId, policyURL: policyURL)
                helper.setupViews()
                helper.showGDPRDialog()
            }
        }
    }
    
    func confirmTourViewDidFinishWithConfirm(_ confirmTourView: ConfirmTourView) {
        Utls.openURL(strUrl: Session.manager.getGDPRPolicyURL())
    }
    
    func confirmDragLog(_ confirmTourView: ConfirmTourView) {
        //not reachable
    }
    
    func confirmTourViewDidFinishWithCancel(_ confirmTourView: ConfirmTourView) {
        //I know the naming of this view is unfortunate
        //But the accept button in this case is tied to the
        //Cancel delegate method
        let gdprService = GDPRService()
        gdprService.postGDPRAcceptance { [weak self] (success) in
            guard let this = self, let helper = this.gdprHelper else{
                return
            }
            success ? helper.removeDialog() : helper.showWithError()
        }
    }
}

//extension MainCoordinator: AfliViewControllerDelegate{
//
//    func addAfli() {
//
//        let addAfliVM = AddAfliViewModel(type: .time)
//        let addAfliVC = AddAfliViewController(delegate: self, viewModel: addAfliVM)
//        self.afliNavController.pushViewController(addAfliVC)
//    }
//
//    func showTab(){
//        self.showTabBar()
//    }
//
//    func editAfli(catchToEdit: Catch){
//        let isFish = catchToEdit.type == 0
//        Session.manager.saveIsLoggedAfliFish(isFish)
//
//        let logVM = LogAfliViewModel()
//        let logAfliVC = LogAfliViewController(delegate: self, viewModel: logVM)
//        logVM.setupForEditWithCatch(catchToEdit)
//        self.afliNavController.pushViewController(logAfliVC, completion: nil)
//    }
//}
//
//extension MainCoordinator: AddAfliViewControllerDelegate, LogAfliViewControllerDelegate{
//    /**
//     Sets id of the catch to if editing.
//     Saves the catch to Session.
//     Tries to send catch to Friðjón.
//     Updates pull logging date.
//     Pops ViewController.
//     */
//    fileprivate func handleLogging(_ _catch: Catch, updatePull pull: Pull) {
//        if let editId = Session.manager.getCatchIdToEdit() {
//            _catch.id = editId
//        }
//
//        Session.manager.saveCatch(_catch)
//
//        pull.lastWeightLogDate = Date()
//        //Session.manager.savePull(pull, andRegister: false)
//        updateWeightByAdding(catchWeight: Double(_catch.weight))
//
//        self.afliNavController.popToRootViewController(animated: true)
//    }
//
//    /**
//     */
//    typealias CatchWeight = (pull: Pull, weight: Double)
//    fileprivate func calculateWeights(pulls: [Pull], totalWeight: Double, forType type: Int) -> [CatchWeight] {
//        let weightBase = totalWeight / Double(pulls.count)
//
//        if type == 0 {
//            return pulls.map { ($0, weightBase) }
//        }
//
//        var weightLeft = Int(totalWeight)
//        let newWeightBase = Int(weightBase.rounded(.up))
//        var catchWeights: [CatchWeight] = []
//
//        for pull in pulls {
//            let weight = Double(min(newWeightBase, weightLeft))
//
//            let catchWeight = (pull, weight)
//            catchWeights.append(catchWeight)
//
//            weightLeft -= newWeightBase
//            if weightLeft < 1 {
//                break
//            }
//        }
//
//        return catchWeights
//    }
//
//    /**
//     */
//    func didFinishLogging(animal: AnimalProtocol, isReleased: Bool, isSmallFish: Bool, isGutted: Bool, weight: Double, type: Int) {
//
//        let arrPullsToLogTo = Session.manager.getSelectedPullsToLogCatch()
//        let catchWeights = calculateWeights(pulls: arrPullsToLogTo, totalWeight: weight, forType: type)
//
//        for catchWeight in catchWeights {
//            let myCatch = Catch(pullId: catchWeight.pull.id,
//                                gutted: isGutted,
//                                released: isReleased,
//                                smallFish: isSmallFish,
//                                weight: catchWeight.weight,
//                                speciesId: animal.id,
//                                hasBeenLogged: false,
//                                type: type)
//
//            handleLogging(myCatch, updatePull: catchWeight.pull)
//        }
//    }
//
//    /**
//     */
//    func updateWeightByAdding(catchWeight: Double){
//        let oldTotalWeight = Session.manager.getTotalLoggedCatchWeight()
//        let newTotalWeight = catchWeight + oldTotalWeight
//        Session.manager.setTotalLoggedCatchWeight(newTotalWeight)
//    }
//
//    /**
//     */
//    func didSelect(type: ControllerType, isFish: Bool) {
//
//        if type == .animals{
//            Session.manager.saveIsLoggedAfliFish(isFish)
//            let logVM = LogAfliViewModel()
//            let logAfliVC = LogAfliViewController(delegate: self, viewModel: logVM)
//            self.afliNavController.pushViewController(logAfliVC, completion: nil)
//        }
//        else if type == .time{
//
//            let addAfliVM = AddAfliViewModel(type: .animals)
//            let addAfliVC = AddAfliViewController(delegate: self, viewModel: addAfliVM)
//            self.afliNavController.pushViewController(addAfliVC)
//        }
//    }
//
//    /**
//     */
//    func goBack() {
//
//        self.afliNavController.popViewController()
//    }
//
//    /**
//     */
//    func hideTabBar() {
//        self.hideTabbar()
//    }
//}

extension MainCoordinator: StatsViewControllerDelegate, SingleStatsViewControllerDelegate{
    
    func didSelectDate(from: Date, to: Date) {
        
        let singleStatsVM = SingleStatsViewModel(fromDate: from, toDate: to)
        let singleStatsVC = SingleStatViewController()
        singleStatsVC.viewModel = singleStatsVM
        singleStatsVC.delegate = self
        self.statisticsNavController.pushViewController(singleStatsVC)
    }
    
    func didSelectTrip(id: Int){
        
        let statsVM = SingleStatsViewModel(tourId: id)
        let singleStatVC = SingleStatViewController()
        singleStatVC.viewModel = statsVM
        singleStatVC.delegate = self
        self.statisticsNavController.pushViewController(singleStatVC)
    }
    
    func pop(){
        self.statisticsNavController.popViewController()
    }
    
    func show(){
        self.showTabBar()
    }
    
    func hide(){
        self.hideTabbar()
    }
}

extension MainCoordinator: MoreViewControllerDelegate {
    
    func logOut() {
        print("[MainCoordinator] - Did logout")
        self.delegate?.mainCoordinatorDidFinishWithLogout(self)
    }
}

extension MainCoordinator: BoatViewControllerDelegate{
    
    func didSelectBoat() {
        //Select fishing
        self.tabBarController.selectedIndex = 2
        Session.manager.isFishing() ? tabBarController.showRed() : tabBarController.showGreen()
    }
}

extension MainCoordinator: MidButtonDelegate{
    
    func greenClicked() {
        
        if self.tabBarController.selectedIndex != 2{
            self.tabBarController.selectedIndex = 2
            return
        }
        
        if defaultBoatIsSelected(){
            self.selectEquipmentFlow()
        }
        else{
            let boatName = Session.manager.getSelectedBoatName()
            self.veidiVC?.showWarning(warningText: boatName)
        }
    }
    
    func redClicked() {
        if self.tabBarController.selectedIndex != 2{
            self.tabBarController.selectedIndex = 2
            return
        }
        
        veidiVC?.stopTour()
    }
    
    func regularClicked() {
        //Select the mid tab
        self.tabBarController.selectedIndex = 2
        Session.manager.isFishing() ? tabBarController.showRed() : tabBarController.showGreen()
    }
    
    func defaultBoatIsSelected() -> Bool{
        
        if let defaultBoatId = UserDefaults.standard.value(forKey: Session.defaultBoatIdKey) as? Int{
            if defaultBoatId != 0{
                if let selectedBoatId = UserDefaults.standard.value(forKey: Session.selectedBoatIdKey) as? Int{
                    if selectedBoatId != 0{
                        if defaultBoatId == selectedBoatId{
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    func startTourFlow() {
        let shipId = String(Session.manager.getSelectedBoatId())
        
        let portId = Session.manager.getSelectedHarborId()
        guard let fishingEquipmentId = Session.manager.getSelectedEquipmentId() else {
            return
        }
        
        let numberOfBjodOnLine = Session.manager.getBjodaCount()
        let numberOfHooksOnLine = Session.manager.getOnglaCount()
        
        let numberOfNets = Session.manager.getNetCount()
        let heightOfMoskvi = Session.manager.getNetHeight()
        let sizeOfMoskvi = Session.manager.getNetSize()
        
        let numberOfHandEq = Session.manager.getHandfaeriCount()
        
        let postFishingModel = PostFishingEquipmentModel(shipId: shipId, portId: portId, fishingEquipmentTypeId: fishingEquipmentId, numberOfBjodOnLine: numberOfBjodOnLine, numberOfHooksOnLine: numberOfHooksOnLine, numberOfNets: numberOfNets, heightOfMoskviOnNet: heightOfMoskvi, sizeOfMoskviOnNet: sizeOfMoskvi, numberOfHandEquipment: numberOfHandEq)
        
        self.veidiVC?.showLottie()
        self.veidiVC?.viewModel.startFishing(postModel: postFishingModel){  [weak self] (result) in
            guard let this = self else {
                return
            }
            
            self?.veidiVC?.hideLottie()
            if result.code == .ok{
                UserDefaults.standard.set(true, forKey: Session.isFishingKey)
            }
            else{
                //TODO: Handle Error
                print("HANDLE ERROR")
                UserDefaults.standard.set(false, forKey: Session.isFishingKey)
                guard let code = result.code?.rawValue else{
                    
                    return
                }
                if 404..<600 ~= code {
                    self?.veidiVC?.showErrorWithText(text: "Þjónustan virðist liggja niðri, vinsamlegast reynið aftur síðar.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self?.veidiVC?.hideError()
                    }
                }
                else{
                    self?.veidiVC?.showErrorWithText(text: result.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self?.veidiVC?.hideError()
                    }
                }
            }
            
            this.showTabBar()
        }
    }
    
    func selectEquipmentFlow() {
        self.hideTabbar()
        let equipmentVC = SelectEquipmentController()
        equipmentVC.delegate = self
        self.veidiNavController.pushViewController(equipmentVC)
    }
    
    func stopFishing() {
        print("stopped fishing")
        
        self.veidiVC?.showLottie()
        self.veidiVC?.viewModel.stopFishing() { [weak self] (error) in
            guard let this = self else {
                return
            }
            
            this.veidiVC?.hideLottie()
            
            if let error = error {
                
                switch error{
                    
                case .startTourFailed:
                    print("")
                case .confirmTourFailed:
                    self?.veidiVC?.showErrorWithText(text: "Náði ekki að senda gögn til að staðfesta túr - vertu viss um að vera í netsambandi og reyndu aftur síðar.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self?.veidiVC?.hideError()
                    }
                case .registerLocalStorageFailed:
                    self?.veidiVC?.showErrorWithText(text: "Náði ekki að senda gögn til að staðfesta túr - - vertu viss um að vera í netsambandi og reyndu aftur síðar.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self?.veidiVC?.hideError()
                    }
                }
                
                
            } else {
                Session.manager.confirmTour()
                UserDefaults.standard.set(false, forKey: Session.isFishingKey)
            }
        }
        
        
    }
    
    func hasLoggedEquipment() -> Bool{
        
        guard let selectedEquipmentTypeId = Session.manager.getSelectedEquipmentId() else {
            return false
        }
        
        switch selectedEquipmentTypeId {
        case EquipmentType.skotuselsNet.rawValue, EquipmentType.þorskfiskNet.rawValue, EquipmentType.grasleppuNet.rawValue, EquipmentType.grasleppuNet.rawValue:
            
            //Logic for nets, incomplete
            if Session.manager.getNetSize() > 0, Session.manager.getNetHeight() > 0, Session.manager.getNetCount() > 0{
                return true
            }
            return false
        case EquipmentType.lina.rawValue, EquipmentType.landbeittLina.rawValue, EquipmentType.linutrekt.rawValue:
            
            //logic for linur, incomplete
            if Session.manager.getBjodaCount() > 0, Session.manager.getOnglaCount() > 0{
                return true
            }
            return false
        case EquipmentType.handfaeri.rawValue:
            if Session.manager.getHandfaeriCount() > 0 {
                return true
            }
        default:
            print("")
        }
        
        return false
    }
}

extension MainCoordinator: SelectEquipmentControllerDelegate{
    
    
    func didSelectEquipment(equipmentId: Int) {
        
        Session.manager.saveSelectedEquipmentId(equipmentId)
        
        switch equipmentId {
        case EquipmentType.skotuselsNet.rawValue, EquipmentType.þorskfiskNet.rawValue, EquipmentType.grasleppuNet.rawValue, EquipmentType.raudmagaNet.rawValue:
            let netDetailVM = NetDetailViewModel()
            let netDetailViewController = NetDetailViewController(viewModel: netDetailVM)
            netDetailViewController.delegate = self
            self.veidiNavController.pushViewController(netDetailViewController)
        case EquipmentType.lina.rawValue, EquipmentType.landbeittLina.rawValue, EquipmentType.linutrekt.rawValue:
            let linaVM = LinaAndHandfaeriViewModel(type: .lina)
            let linaVC = HandAndLinaDetailControllerViewController(viewModel: linaVM)
            linaVC.delegate = self
            self.veidiNavController.pushViewController(linaVC)
        case EquipmentType.handfaeri.rawValue:
            let handfaeriVM = LinaAndHandfaeriViewModel(type: .handfaeri)
            let handfaeriVC = HandAndLinaDetailControllerViewController(viewModel: handfaeriVM)
            handfaeriVC.delegate = self
            self.veidiNavController.pushViewController(handfaeriVC)
            
        default:
            //Need case for unknown
            print("")
        }
        
    }
}

extension MainCoordinator: SelectHarborViewControllerDelegate, NetDetailViewControllerDelegate, HandAndLineDelegate{
    
    func didSelectHandfaeriWith(numberOfHandfaeri: Int, type: VCType) {
        Session.manager.saveHandfaeriCount(numberOfHandfaeri)
        
        //Clear other types
        Session.manager.saveOnglaCount(0)
        Session.manager.saveBjodaCount(0)
        Session.manager.saveNetSize(0)
        Session.manager.saveNetCount(0)
        Session.manager.saveNetHeight(0)
        
        let harborVM = HarborViewModel()
        let selectHarborVC = SelectHarborViewController(viewModel: harborVM)
        selectHarborVC.delegate = self
        self.veidiNavController.pushViewController(selectHarborVC)
    }
    
    func didSelectLinaWith(numberOfOnglar: Int, numberOfBjodar: Int, type: VCType) {
        Session.manager.saveOnglaCount(numberOfOnglar)
        Session.manager.saveBjodaCount(numberOfBjodar)
        
        //Clear the other types
        Session.manager.saveHandfaeriCount(0)
        Session.manager.saveNetSize(0)
        Session.manager.saveNetCount(0)
        Session.manager.saveNetHeight(0)
        
        let harborVM = HarborViewModel()
        let selectHarborVC = SelectHarborViewController(viewModel: harborVM)
        selectHarborVC.delegate = self
        self.veidiNavController.pushViewController(selectHarborVC)
    }
    
    
    func didLogSize(count: Int, heigth: Int, size: Int) {
        
        Session.manager.saveNetSize(size)
        Session.manager.saveNetHeight(heigth)
        Session.manager.saveNetCount(count)
        //Clear the other types
        Session.manager.saveHandfaeriCount(0)
        Session.manager.saveBjodaCount(0)
        Session.manager.saveHandfaeriCount( 0)
        
        let harborVM = HarborViewModel()
        let selectHarborVC = SelectHarborViewController(viewModel: harborVM)
        selectHarborVC.delegate = self
        self.veidiNavController.pushViewController(selectHarborVC)
    }
    
    
    func didSelectHarborWith(harborId: Int) {
        
        Session.manager.saveSelectedHarborId(harborId)
        self.veidiNavController.viewControllers = [self.veidiVC!]
        self.startTourFlow()
    }
    
    func popHarbor() {
        self.veidiNavController.popViewController()
        if self.veidiNavController.viewControllers[0] is FishingViewController && self.veidiNavController.viewControllers.count == 1{
            self.showTabBar()
        }
        else{
            self.hideTabbar()
        }
    }
}



// MARK: UITabBarControllerDelegate
extension MainCoordinator: UITabBarControllerDelegate {
    /**
     */
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let veidiVC = veidiVC else {
            return
        }
        
        if !(viewController.childViewControllers.contains(veidiVC)) {
            self.tabBarController.showRegular()
        }
    }
}


// MARK: FishingViewControllerDelegate
extension MainCoordinator: FishingViewControllerDelegate {
    func fishingViewControllerDidStartTour(_ fishingViewController: FishingViewController) {
        if defaultBoatIsSelected(){
            self.selectEquipmentFlow()
        }
        else{
            let boatName = Session.manager.getSelectedBoatName()
            self.veidiVC?.showWarning(warningText: boatName)
        }
    }
    
    func fishingViewControllerDidStopTour(_ fishingViewController: FishingViewController) {
        self.stopFishing()
    }
    
    func didWantLogging() {
        
        //let addAfliVM = AddAfliViewModel(type: .time)
        //let addAfliVC = AddAfliViewController(delegate: self, viewModel: addAfliVM)
        //self.afliNavController.viewControllers = [self.afliVC!, addAfliVC]
        self.tabBarController.selectedIndex = 3
        
        self.tabBarController.showRegular()
        
    }
}

// MARK: - RegisterCatchCoordinatorDelegate
extension MainCoordinator: RegisterCatchCoordinatorDelegate {
    func registerCatchCoordinatorWantsToShowTabbar(_ registerCatchCoordinator: RegisterCatchCoordinator) {
        showTabBar()
    }
    
    func registerCatchCoordinatorWantsToHideTabbar(_ registerCatchCoordinator: RegisterCatchCoordinator) {
        hideTabbar()
    }
}
