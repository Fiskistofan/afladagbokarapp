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

class RegistrationService {
    private let session = Session.manager
    private lazy var logService = LogService()
    
    /**
     */
    func registerLocalStorage(_ success: ((Bool) -> ())? = nil) {
        var sentAll = true
        
        registerTosses { (tossSuccess) in
            if !tossSuccess { sentAll = false }
            
            self.registerPulls { (pullSuccess) in
                if !pullSuccess { sentAll = false }
                
                self.registerCatch { (catchSuccess) in
                    if !catchSuccess { sentAll = false }
                    success?(sentAll)
                }
            }
        }
    }
    
    /**
     */
    fileprivate func registerTosses(success: @escaping(Bool) -> ()) {
        var sentAll = true
        
        guard let tourId = Session.manager.getTourId() else {
            success(false)
            return
        }
        
        let group = DispatchGroup()
        
        let tosses = session.getTosses().filter { $0.hasBeenLogged == false }
        print("Registering \(tosses.count) tosses")
        
        _ = tosses.map { print($0.id) }
        for toss in tosses {
            group.enter()
            
            let tossModel = TossModel(tourId: tourId, toss: toss)
            logService.registerToss(model: tossModel) { result in
                if result.success {
                    toss.logSuccessful()
                    self.session.saveToss(toss, andRegister: false)
                } else {
                    sentAll = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            success(sentAll)
        }
    }
    
    /**
     */
    fileprivate func registerPulls(success: @escaping(Bool) -> ()) {
        var sentAll = true
        
        let group = DispatchGroup()
        
        let pulls = session.getPulls().filter { $0.hasBeenLogged == false }
        print("Registering \(pulls.count) pulls")
        _ = pulls.map { print($0.id) }
        for pull in pulls {
            group.enter()
            
            let pullModel = PullModel(pull: pull)
            logService.registerPull(model: pullModel) { result in
                if result.success {
                    pull.logSuccessful()
                    self.session.savePull(pull, andRegister: false)
                } else {
                    sentAll = false
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            success(sentAll)
        }
    }
    
    /**
     */
    fileprivate func registerCatch(success: @escaping(Bool) -> ()) {
        var sentAll = true
        
        let group = DispatchGroup()
        
        let catches = session.getCatches().filter { $0.hasBeenLogged == false }
        print("Registering \(catches.count) catches")
        
        for _catch in catches {
            
            print("Starting Request for: \(_catch.id) - \(_catch.weight)")
            let catchModel = CatchModel(_catch: _catch)
            
            
                group.enter()
                switch _catch.type {
                
                case 0:
                    self.logService.registerCatchedFish(model: catchModel) { result in
                        if result.success {
                            _catch.logSuccessful()
                            self.session.saveCatchToSession(_catch: _catch, overwrite: true)
                        } else {
                            sentAll = false
                        }
                        group.leave()
                    }

                case 1:
                    self.logService.registerOtherSpecies(model: catchModel) { result in
                        if result.success {
                            _catch.logSuccessful()
                            self.session.saveCatchToSession(_catch: _catch, overwrite: true)
                        } else {
                            sentAll = false
                        }
                        group.leave()
                    }

                default:
                    group.leave()
                    break

                }
        }
        
        group.notify(queue: .main) {
            print("finished requests: \(sentAll)")
            success(sentAll)
        }
    }
}
