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

class LogService: NetworkingService {
    /**
     */
    func registerToss(model: TossModel, with result: @escaping (_ result: Result<EmptyModel>) -> ()) {
        let tourId = model.tourId
        let tossId = model.id

        let endpoint = NetworkEndpoint.Put.toss(tourId: tourId, tossId: tossId)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: model.toJSON())
        
        networking.request(request) { (json, error) in
            let resultWrapper:Result<EmptyModel> = self.resultFromJSON(json, error)
            print("[LogService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
    
    /**
     */
    func registerPull(model: PullModel, with result: @escaping (_ result: Result<EmptyModel>) -> ()) {
        guard let tourId = Session.manager.getTourId() else {
            return
        }
        
        let pullId = model.id
        
        let endpoint = NetworkEndpoint.Put.pull(tourId: tourId, pullId: pullId)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: model.toJSON())
        
        networking.request(request) { (json, error) in
            let resultWrapper:Result<EmptyModel> = self.resultFromJSON(json, error)
            print("[LogService] — Did make request: \(request.url)")
            result(resultWrapper)
        }
    }
    
    /**
     */
    func registerCatchedFish(model: CatchModel, with result: @escaping (_ result: Result<EmptyModel>) -> ()) {
        guard let tourId = Session.manager.getTourId() else {
            return
        }
        
        let catchId = model.id
        
        let endpoint = NetworkEndpoint.Put.catchedFish(tourId: tourId, catchId: catchId)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: model.toJSON())
        
        networking.request(request) { (json, error) in
            let resultWrapper:Result<EmptyModel> = self.resultFromJSON(json, error)
            print("[LogService] — Did make request: \(request.url)")
            print("\(model.id) - \(model.weight)")
            result(resultWrapper)
        }
    }
    
    /**
     */
    func registerOtherSpecies(model: CatchModel, with result: @escaping (_ result: Result<EmptyModel>) -> ()) {
        guard let tourId = Session.manager.getTourId() else {
            return
        }
        
        let catchId = model.id
        
        let endpoint = NetworkEndpoint.Put.catchedMammalsAndBirds(tourId: tourId, otherSpeciesCatchId: catchId)
        let request = NetworkRequest(url: endpoint.path, method: endpoint.method, params: model.toJSON())
        
        networking.request(request) { (json, error) in
            let resultWrapper: Result<EmptyModel> = self.resultFromJSON(json, error)
            print("[LogService] — Did make request: \(request.url)")
            print("\(model.id) - \(model.weight)")
            result(resultWrapper)
        }
    }
}
