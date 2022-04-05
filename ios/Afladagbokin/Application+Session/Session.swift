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
import SwiftKeychainWrapper
import SVProgressHUD
import StokkurUtls

/*
 * Takes care of the users session
 */
class Session {
    
    //MARK: - Properties
    static let manager = Session()
    private let keychain = KeychainWrapper.standard
    private lazy var logService = LogService()
    private let notificationCenter = NotificationCenter.default
    
    // MARK: - Keys
    static let hasRunBefore             = "hasRunBefore"
    static let baseAPIKey               = "BaseAPI"
    static let userTokenKey             = "userToken"
    static let uuidKey                  = "appUUID"
    static let defaultBoatIdKey         = "defaultBoatId"
    static let selectedBoatIdKey        = "selectedBoatId"
    static let selectedBoatNameKey      = "selectedBoatName"
    static let isFishingKey             = "isFishing"
    static let selectedEquipmentIdKey   = "selectedEquipmentId"
    static let portsKey                 = "portsKey"
    static let fishKey                  = "fishKey"
    static let otherSpeciesKey          = "otherSpecies"
    static let fishingEquipmentKey      = "fishingEquipment"
    static let netSizeKey               = "netSize"
    static let onglaCountKey            = "onglaCountKey"
    static let bjodaCountKey            = "bjodaCountKey"
    static let handfaeriCountKey        = "handfaeriCountKey"
    static let selectedHarborIdKey      = "selectedHarborIdKey"
    static let tossesKey                = "tosses"
    static let pullsKey                 = "pulls"
    static let catchesKey               = "catches"
    static let boatsKey                 = "boatsKey"
    static let tourKey                  = "tourKey"
    static let tourStatisticsKey        = "tourStatistics"
    static let currentLoggingPullKey    = "currentLoggingPull"
    static let isFishKey                = "isFish"
    static let userNameKey              = "userName"
    static let userSSNKey               = "userSSN"
    static let netCountKey              = "netCount"
    static let netHeightKey             = "netHeight"
    static let pullsToLogCatchToKey     = "pullsToLog"
    static let totalLoggedCatchWeightKey = "totalLoggedCatchWeight"
    static let catchIdToEditKey         = "catchIdToEdit"
    static let fishingEquipmentTypeIdKey = "fishingEquipmentTypeId"
    
    //MARK: GDPR Keys and constants
    static let GDPR_KEY                 = "NEEDS_GDPR_USER_APPROVAL"
    static let GDPR_SERVER_KEY          = "needsToAgree"
    static let GDPR_PPOLICY_LINK_KEY    = "GDPRPolicyLink"
    static let GDPR_PPOLICY_ID          = "GDPRPolicyID"
    static let GDPR_POLICY_KEY          = "privacyTerms"
    static let GDPR_POLICY_ID_KEY       = "id"
    static let GDPR_POLICY_URL_KEY      = "content"
    
    //MARK: Search for Harbor and Fish/Animals
    static let LAST_SELECTED_HARBOR_ID_KEY = "LAST_SELECTED_HARBOR_ID"
    static let ARR_SELECTED_HARBORS_KEY = "ARR_SELECTED_HARBORS"
    static let DICT_PREV_SELECTED_HARBORS = "DICT_SELECTED_HARBORS"
    static let DICT_PREV_SELECTED_FISHES = "DICT_SELECTED_FISHES"
    static let DICT_PREV_SELECTED_ANIMALS = "DICT_SELECTED_ANIMALS"
    
    // Can't init a singleton
    private init() { }
    
    
    //MARK: - Public methods
    /*
     * Gets the url endpoint
     */
    public func baseAPI() -> String! {
        //get the base api through the .plist file
        let baseAPI = Bundle.main.infoDictionary?[Session.baseAPIKey] as! String
        return baseAPI
    }
}

// MARK: - GDPR
extension Session {
    
    func saveGDPRPolicyURL(url: String){
        UserDefaults.standard.set(url, forKey: Session.GDPR_PPOLICY_LINK_KEY)
    }
    
    func getGDPRPolicyURL() -> String{
        guard let url = UserDefaults.standard.value(forKey: Session.GDPR_PPOLICY_LINK_KEY) as? String else{
            return ApplicationConstants.GDPR_READ_MORE_URL
        }
        return url
    }
    
    func saveGDPRPolicyID(id: Int){
        UserDefaults.standard.set(id, forKey: Session.GDPR_PPOLICY_ID)
    }
    
    func getGDPRPolicyID() -> Int{
        guard let policyId = UserDefaults.standard.value(forKey: Session.GDPR_PPOLICY_ID) as? Int else { return 1 }
        return policyId
    }
}



// MARK: - User
extension Session {
    /**
     */
    func userToken() -> String? {
        let token = UserDefaults.standard.value(forKey: Session.userTokenKey) as? String
        
        return token
    }
    
    /**
     */
    func saveUserToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: Session.userTokenKey)
    }
    
    /**
    */
    func saveUserName(_ name: String){
        UserDefaults.standard.set(name, forKey: Session.userNameKey)
    }
    
    /**
     */
    func getUserName() -> String{
        if let userName = UserDefaults.standard.value(forKey: Session.userNameKey) as? String{
            return userName
        }
        return "Ónafngreindur"
    }
    
    /**
     */
    func saveUserSSN(_ ssn: String){
        UserDefaults.standard.set(ssn, forKey: Session.userSSNKey)
    }
    
    
    /**
     */
    func getUserSSN() -> String{
        if let ssn = UserDefaults.standard.value(forKey: Session.userSSNKey) as? String{
            return ssn
        }
        return "Engin kennitala skráð"
    }
}



// MARK: - isFishing
extension Session {
    /**
     */
    func isFishing() -> Bool {
        return UserDefaults.standard.value(forKey: Session.isFishingKey) as? Bool ?? false
    }
}


// MARK: - Login/Logout
extension Session {
    /**
     */
    func isLoggedIn() -> Bool {
        let token = UserDefaults.standard.value(forKey: Session.userTokenKey) as? String
        
        return token != nil
    }
    
    /**
     */
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Session.userTokenKey)
    }
}



// MARK: - Boat
extension Session {
    /**
     */
    func saveDefaultBoatId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: Session.defaultBoatIdKey)
    }
    
    /**
     */
    func getDefaultBoatId() -> Int? {
        let boatId = UserDefaults.standard.value(forKey: Session.defaultBoatIdKey) as? Int
        
        return boatId
    }
    
    /**
     */
    func getSelectedBoatId() -> Int {
        let selectedBoatId = UserDefaults.standard.value(forKey: Session.selectedBoatIdKey) as? Int
        
        return selectedBoatId ?? 0
    }
    
    /**
     */
    func saveSelectedBoatId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: Session.selectedBoatIdKey)
    }
    
    /**
     */
    func getSelectedBoatName() -> String {
        let selectedBoatName = UserDefaults.standard.value(forKey: Session.selectedBoatNameKey) as? String
        
        return selectedBoatName ?? "Ónafngreindur"
    }
    
    /**
     */
    func saveBoats(_ boats: [ShipsModel]) {
        let boatsJSON = boats.map { $0.toJSON() }
        
        UserDefaults.standard.set(boatsJSON, forKey: Session.boatsKey)
    }
    
    /**
     */
    func getBoats() -> [ShipsModel] {
        let boats = UserDefaults.standard.value(forKey: Session.boatsKey) as? [JSON] ?? []
        
        return boats.flatMap { ShipsModel(json: $0) }
    }
}



// MARK: - Equipment
extension Session {
    /**
     */
    func saveSelectedEquipmentId(_ equipmentId: Int) {
        UserDefaults.standard.set(equipmentId, forKey: Session.selectedEquipmentIdKey)
    }
    
    /**
     */
    func getSelectedEquipmentId() -> Int? {
        let selectedEquipmentId = UserDefaults.standard.value(forKey: Session.selectedEquipmentIdKey) as? Int
        
        return selectedEquipmentId
    }
    
    /**
     */
    func saveEquipment(_ equipment: [JSON]) {
        UserDefaults.standard.set(equipment, forKey: Session.fishingEquipmentKey)
    }
    
    /**
     */
    func getEquipment() -> [JSON] {
        let equipment = UserDefaults.standard.value(forKey: Session.fishingEquipmentKey) as? [JSON]
        
        return equipment ?? []
    }
    
    /**
     */
    func saveDefaultEquipmentTypeId(_ id: Int){
        UserDefaults.standard.set(id, forKey: Session.fishingEquipmentTypeIdKey)
    }
    
    /**
    */
    func getDefaultEquipmentTypeId() -> Int{
        let id = UserDefaults.standard.value(forKey: Session.fishingEquipmentTypeIdKey) as? Int
        return id ?? 0
    }
}



// MARK: - Ports
extension Session {
    /**
     */
    func savePorts(_ ports: [JSON]) {
        UserDefaults.standard.set(ports, forKey: Session.portsKey)
    }
    
    /**
     */
    func getPorts() -> [JSON] {
        let ports = UserDefaults.standard.value(forKey: Session.portsKey) as? [JSON]
        
        return ports ?? []
    }
}



// MARK: - Harbor
extension Session {
    /**
     */
    func saveSelectedHarborId(_ id: Int) {
        UserDefaults.standard.set(id, forKey: Session.selectedHarborIdKey)
    }
    
    /**
     */
    func getSelectedHarborId() -> Int {
        let harborId = UserDefaults.standard.value(forKey: Session.selectedHarborIdKey) as? Int
        
        return harborId ?? 0
    }
    
    func saveLastSelectedHarborId(_ harborId: Int){
        
        UserDefaults.standard.set(harborId, forKey: Session.LAST_SELECTED_HARBOR_ID_KEY)
    }
    
    func loadLastSelectedHarborId() -> Int{
        
        guard let lastId = UserDefaults.standard.value(forKey: Session.LAST_SELECTED_HARBOR_ID_KEY) as? Int else{
            return 0
        }
        return lastId
    }
    
    func addToPreviouslySelectedHarborsDict(harborId: Int){
        
        let strHarborId = String(harborId)
        guard var prevSelectedHarborsDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_HARBORS) as? Dictionary<String, Int> else{
            var dictPrevSelHarb = Dictionary<String, Int>()
            dictPrevSelHarb[strHarborId] = 1
            Session.savePrevSelectedHarborsDict(dict: dictPrevSelHarb)
            return
        }
        
        guard let occuranceCount = prevSelectedHarborsDict[strHarborId] else{
            prevSelectedHarborsDict[strHarborId] = 1
            Session.savePrevSelectedHarborsDict(dict: prevSelectedHarborsDict)
            return
        }
        let newCount = occuranceCount+1
        prevSelectedHarborsDict[strHarborId] = newCount
        Session.savePrevSelectedHarborsDict(dict: prevSelectedHarborsDict)
    }
    
    static func savePrevSelectedHarborsDict(dict: Dictionary<String, Int>){
        
        UserDefaults.standard.set(dict, forKey: Session.DICT_PREV_SELECTED_HARBORS)
    }
    
    static func getPrevSelectedHarborsDict() -> Dictionary<String, Int>{
        
        guard let prevSelectedHarborsDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_HARBORS) as? Dictionary<String, Int> else{
            return Dictionary<String,Int>()
        }
        return prevSelectedHarborsDict
    }
}


// MARK: - FishSpecies
extension Session {
    /**
     */
    func saveFishSpecies(_ species: [JSON]) {
        UserDefaults.standard.set(species, forKey: Session.fishKey)
    }
    
    /**
     */
    func getFishSpecies() -> [JSON] {
        let fishSpecies = UserDefaults.standard.value(forKey: Session.fishKey) as? [JSON]
        
        return fishSpecies ?? []
    }
    
    /**
     */
    func saveOtherSpecies(_ species: [JSON]) {
        UserDefaults.standard.set(species, forKey: Session.otherSpeciesKey)
    }
    
    /**
     */
    func getOtherSpecies() -> [JSON] {
        let otherSpecies = UserDefaults.standard.value(forKey: Session.otherSpeciesKey) as? [JSON]
        
        return otherSpecies ?? []
    }
    
    /**
     */
    func getNameFromIDAndType(id: Int, type: Int) -> String{
        var name = ""
        
        if type == 0{
            var arrFish: [FishSpeciesModel] = []
            for fish in Session.manager.getFishSpecies(){
                if let fish = FishSpeciesModel(json: fish){
                    arrFish.append(fish)
                }
            }
            for fish in arrFish{
                if fish.id == id{
                    name = fish.speciesName
                    break
                }
            }
        }
        else{
            var arrSpecies: [OtherSpeciesModel] = []
            for animal in Session.manager.getOtherSpecies(){
                if let animal = OtherSpeciesModel(json: animal){
                    arrSpecies.append(animal)
                }
            }
            for animal in arrSpecies{
                if animal.id == id{
                    name = animal.speciesName
                }
            }
        }
        
        if name == ""{
            //Try again by flipping the type
            if type == 1{
                
            }
            
        }
        
        return name
    }
}



// MARK: - Net
extension Session {
    /**
     */
    func saveNetSize(_ size: Int) {
        print("[Session] - Did save netsize of: \(size)")
        UserDefaults.standard.set(size, forKey: Session.netSizeKey)
    }
    
    /**
     */
    func getNetSize() -> Int {
        let size = UserDefaults.standard.value(forKey: Session.netSizeKey) as? Int
        
        return size ?? 0
    }
    
    /**
     */
    func saveNetCount(_ count: Int){
        print("[Session] - Did save netCount of: \(count)")
        UserDefaults.standard.set(count, forKey: Session.netCountKey)
    }
    
    /**
     */
    func getNetCount() -> Int {
        
        let count = UserDefaults.standard.value(forKey: Session.netCountKey) as? Int
        return count ?? 0
    }
    
    /**
     */
    func saveNetHeight(_ height: Int) {
        print("[Session] - Did save netHeight of: \(height)")
        UserDefaults.standard.set(height, forKey: Session.netHeightKey)
    }
    
    /**
     */
    func getNetHeight() -> Int {
        let height = UserDefaults.standard.value(forKey: Session.netHeightKey) as? Int
        return height ?? 0
    }
}



// MARK: - Lina
extension Session {
    /**
     */
    func saveOnglaCount(_ count: Int) {
        print("[Session] - Did save onglaCount of: \(count)")
        UserDefaults.standard.set(count, forKey: Session.onglaCountKey)
    }
    
    /**
     */
    func getOnglaCount() -> Int{
        let onglaCount = UserDefaults.standard.value(forKey: Session.onglaCountKey) as? Int
        
        return onglaCount ?? 0
    }
    
    /**
     */
    func saveBjodaCount(_ count: Int) {
        print("[Session] - Did save bjodaCount of: \(count)")
        UserDefaults.standard.set(count, forKey: Session.bjodaCountKey)
    }
    
    /**
     */
    func getBjodaCount() -> Int {
        let bjodaCount = UserDefaults.standard.value(forKey: Session.bjodaCountKey) as? Int
        
        return bjodaCount ?? 0
    }
}



// MARK: - Handfæri
extension Session {
    /**
     */
    func saveHandfaeriCount(_ count: Int) {
        print("[Session] - Did save handfaeriCount of: \(count)")
        UserDefaults.standard.set(count, forKey: Session.handfaeriCountKey)
    }
    
    /**
     */
    func getHandfaeriCount() -> Int {
        let handfaeriCount = UserDefaults.standard.value(forKey: Session.handfaeriCountKey) as? Int
        
        return handfaeriCount ?? 0
    }
}



// MARK: Tour
extension Session {
    /**
     */
    func saveTourId(_ tourId: Int) {
        UserDefaults.standard.set(tourId, forKey: Session.tourKey)
    }
    
    /**
     */
    func getTourId() -> Int? {
        return UserDefaults.standard.value(forKey: Session.tourKey) as? Int
    }
    
    func saveTourIdForStatistics(_ tourId: Int) {
        UserDefaults.standard.set(tourId, forKey: Session.tourStatisticsKey)
    }
    
    /**
     */
    func getTourIdForStatistics() -> Int? {
        return UserDefaults.standard.value(forKey: Session.tourStatisticsKey) as? Int
    }
}


// MARK: Tosses
extension Session {
    /**
     */
    func saveToss(_ toss: Toss, andRegister: Bool = true) {
        guard let tourId = self.getTourId() else {
            return
        }
        
        if andRegister {
            let tossModel = TossModel(tourId: tourId, toss: toss)
            logService.registerToss(model: tossModel) { result in
                if result.success { toss.logSuccessful() }
                self.saveTossToSession(toss: toss)
            }
        }
        
        saveTossToSession(toss: toss)
    }
    
    /**
     */
    fileprivate func saveTossToSession(toss: Toss) {
        var tossesJSON = UserDefaults.standard.value(forKey: Session.tossesKey) as? [JSON] ?? []
        
        let tosses = tossesJSON.flatMap { TossFactory.fromJSON($0) }
        var newTosses = tosses.filter({ $0.id != toss.id })
        newTosses.append(toss)
        
        tossesJSON = newTosses.flatMap { $0.toJSON() }
        
        UserDefaults.standard.set(tossesJSON, forKey: Session.tossesKey)
        notificationCenter.post(name: .tossLogged, object: toss)
    }
    
    /**
     */
    func getTosses() -> [Toss] {
        let tossesJSON = UserDefaults.standard.value(forKey: Session.tossesKey) as? [JSON] ?? []
        
        return tossesJSON.flatMap { TossFactory.fromJSON($0) }
    }
}

extension Notification.Name {
    static var tossLogged: Notification.Name {
        return .init(rawValue: "Session.tossLogged")
    }
}




// MARK: - Pulls
extension Session {
    /**
     */
    func savePull(_ pull: Pull, andRegister: Bool = true) {
        let pullModel = PullModel(pull: pull)
        
        if andRegister {
            logService.registerPull(model: pullModel) { [weak self] result in
                guard let this = self else {
                    return
                }
                
                if result.success { pull.logSuccessful() }
                this.savePullToSession(pull: pull)
            }
        }
        self.savePullToSession(pull: pull)
    }
    
    /**
     */
    fileprivate func savePullToSession(pull: Pull) {
        let tosses = self.getTosses()
        guard let toss = tosses.first(where: { $0.id == pull.tossId }) else {
            return
        }
        toss.pulls = toss.pulls.filter { $0.id != pull.id }
        toss.pulls.append(pull)
        self.saveToss(toss, andRegister: false)
    }
    
    /**
     */
    func getPulls() -> [Pull] {
        let tosses = getTosses()
        
        return tosses.flatMap { $0.pulls }
    }
    
    /**
     */
    func saveSelectedPullsToLogCatch(_ pulls: [Pull]){
        let arrPullsAsJSON: [JSON] = pulls.flatMap{ $0.toJSON() }
        UserDefaults.standard.set(arrPullsAsJSON, forKey: Session.pullsToLogCatchToKey)
    }
    
    /**
     */
    func getSelectedPullsToLogCatch() -> [Pull]{
        
        let arrPullsJSON = UserDefaults.standard.value(forKey: Session.pullsToLogCatchToKey) as? [JSON] ?? []
        
        return arrPullsJSON.flatMap { PullFactory.fromJSON($0) }
    }
}



// MARK: - Catches
extension Session {
    /**
     */
    func saveCatch(_ _catch: Catch) {
        saveCatchToSession(_catch: _catch)
        
        let catchModel = CatchModel(_catch: _catch)
        
        switch _catch.type {
        case 0:
            logService.registerCatchedFish(model: catchModel) { [weak self] result in
                guard let this = self else {
                    return
                }
                
                if result.success {
                    _catch.logSuccessful()
                    this.saveCatchToSession(_catch: _catch, overwrite: true)
                }
            }
        case 1:
            logService.registerOtherSpecies(model: catchModel) { [weak self] result in
                guard let this = self else {
                    return
                }
                
                if result.success {
                    _catch.logSuccessful()
                    this.saveCatchToSession(_catch: _catch, overwrite: true)
                }
            }
        default:
            break
        }
    }
    
    /**
    */
    func saveCatchToSession(_catch: Catch, overwrite: Bool = false) {
        let pulls = self.getPulls()
        
        guard let pull = pulls.first(where: { $0.id == _catch.pullId }) else {
            return
        }
        
        if overwrite {
            pull.catches = pull.catches
                .filter({ $0.timestamp != _catch.timestamp })
        }

        pull.addCatch(_catch)
        self.savePull(pull, andRegister: false)
    }
    
    /**
     */
    func getCatches(uniqueIds: Bool = false) -> [Catch] {
        let pulls = getPulls()
        let catches = pulls.flatMap { $0.catches }.sorted(by: { $0.timestamp < $1.timestamp })
        var unique: [Catch] = []
        for c in catches {
            unique = unique.filter { $0.id != c.id }
            unique.append(c)
        }
        
        return uniqueIds ? Array(unique) : catches
    }
    
    /**
     */
    func saveCurrentLogginPull(_ pull: Toss){
        let pull = pull.toJSON()
        UserDefaults.standard.set(pull, forKey: Session.currentLoggingPullKey)
    }
    
    /**
     */
    func getCurrentLoggingPull() -> PullModel?{
        guard let pull = UserDefaults.standard.value(forKey: Session.currentLoggingPullKey) as? JSON else{
            return nil
        }
        
        return PullModel(json: pull) ?? nil
    }
    
    /**
    */
    func setTotalLoggedCatchWeight(_ weight: Double){
        UserDefaults.standard.set(weight, forKey: Session.totalLoggedCatchWeightKey)
    }
    
    func getTotalLoggedCatchWeight() -> Double{
        let weight = UserDefaults.standard.value(forKey: Session.totalLoggedCatchWeightKey) as? Double
        return weight ?? 0
    }
    
    /**
     */
    func saveCatchIdToEdit(_ id: String?){
        UserDefaults.standard.set(id, forKey: Session.catchIdToEditKey)
    }
    
    /**
     */
    func getCatchIdToEdit() -> String?{
        let id = UserDefaults.standard.value(forKey: Session.catchIdToEditKey) as? String
        return id ?? nil
    }
}

//MARK: - Register if afli is of type fish or not
extension Session {
    /**
     */
    func saveIsLoggedAfliFish(_ isFish: Bool){
        UserDefaults.standard.set(isFish, forKey: Session.isFishKey)
    }
    
    /**
     */
    func getIsLoggedAfliFish() -> Bool{
        let isFish = UserDefaults.standard.value(forKey: Session.isFishKey) as? Bool
        return isFish ?? true
    }
    
    func addToPreviouslySelectedFishDict(fishId: Int){
        
        let strFishId = String(fishId)
        guard var prevSelectedFishDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_FISHES) as? Dictionary<String, Int> else{
            var dictPrevSelFishes = Dictionary<String, Int>()
            dictPrevSelFishes[strFishId] = 1
            Session.savePrevSelectedFishDict(dict: dictPrevSelFishes)
            return
        }
        
        guard let occuranceCount = prevSelectedFishDict[strFishId] else{
            prevSelectedFishDict[strFishId] = 1
            Session.savePrevSelectedFishDict(dict: prevSelectedFishDict)
            return
        }
        let newCount = occuranceCount+1
        prevSelectedFishDict[strFishId] = newCount
        Session.savePrevSelectedFishDict(dict: prevSelectedFishDict)
    }
    
    func addToPreviouslySelectedAnimalDict(animalId: Int){
        
        let strAnimalId = String(animalId)
        guard var prevSelectedAnimalDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_ANIMALS) as? Dictionary<String, Int> else{
            var dictPrevSelAnimals = Dictionary<String, Int>()
            dictPrevSelAnimals[strAnimalId] = 1
            Session.savePrevSelectedAnimalDict(dict: dictPrevSelAnimals)
            return
        }
        
        guard let occuranceCount = prevSelectedAnimalDict[strAnimalId] else{
            prevSelectedAnimalDict[strAnimalId] = 1
            Session.savePrevSelectedAnimalDict(dict: prevSelectedAnimalDict)
            return
        }
        let newCount = occuranceCount+1
        prevSelectedAnimalDict[strAnimalId] = newCount
        Session.savePrevSelectedAnimalDict(dict: prevSelectedAnimalDict)
    }
    
    static func savePrevSelectedFishDict(dict: Dictionary<String, Int>){
        
        UserDefaults.standard.set(dict, forKey: Session.DICT_PREV_SELECTED_FISHES)
    }
    
    static func savePrevSelectedAnimalDict(dict: Dictionary<String, Int>){
        
        UserDefaults.standard.set(dict, forKey: Session.DICT_PREV_SELECTED_ANIMALS)
    }
    
    static func getPrevSelectedFishDict() -> Dictionary<String, Int>{
        
        guard let prevSelectedFishDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_FISHES) as? Dictionary<String, Int> else{
            return Dictionary<String,Int>()
        }
        return prevSelectedFishDict
    }
    
    static func getPrevSelectedAnimalDict() -> Dictionary<String, Int>{
        
        guard let prevSelectedAnimalDict = UserDefaults.standard.value(forKey: Session.DICT_PREV_SELECTED_ANIMALS) as? Dictionary<String, Int> else{
            return Dictionary<String,Int>()
        }
        return prevSelectedAnimalDict
    }
}


// MARK: - Loading Indicator
extension Session {
    /**
     */
    func configureLoadingIndicator() {
        SVProgressHUD.setForegroundColor(Color.white.value)
        SVProgressHUD.setBackgroundColor(Color.blue.value)
    }
}


// MARK: - Clear
extension Session {
    /**
     */
    func clearSession() {
        _ = [Session.tourKey,
         Session.selectedEquipmentIdKey,
         Session.bjodaCountKey,
         Session.onglaCountKey,
         Session.handfaeriCountKey,
         Session.netSizeKey,
         Session.netHeightKey,
         Session.netCountKey,
         Session.tossesKey,
         Session.pullsKey,
         Session.catchesKey,
         Session.currentLoggingPullKey,
         Session.isFishingKey,
         Session.totalLoggedCatchWeightKey
            ].map { UserDefaults.standard.removeObject(forKey: $0) }
        print("[Session] - Cleared session keys")
    }
    
    /**
     */
    func confirmTour() {
        _ = [Session.tourKey,
             Session.tossesKey,
             Session.pullsKey,
             Session.catchesKey,
             Session.currentLoggingPullKey,
             Session.isFishingKey,
             Session.totalLoggedCatchWeightKey
             ].map { UserDefaults.standard.removeObject(forKey: $0) }
        print("[Session] - Confirmed tour")
    }
}



// MARK: - Device
extension Session {
    /*
     * Returns the device id used by the backend
     */
    public func deviceId() -> String {
        //check if we have it stored and return that
        if let storedUUID = keychain.string(forKey: Session.uuidKey) {
            return storedUUID
        }
        //check if we can generate it and save it
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            keychain.set(uuid, forKey: Session.uuidKey)
            return uuid
        }
        //should not happen
        return ""
    }
}

