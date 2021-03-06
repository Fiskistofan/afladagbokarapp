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
import CoreLocation

protocol Toss: class, JSONInitable, JSONReturnable, Fridjonable {
    var id: String { get }
    var date: Date { get }
    var coordinates: CLLocationCoordinate2D { get }
    var type: EquipmentType { get }
    var tossCount: Int { get }
    var pulls: [Pull] { get set }
    var initialPulls: Int { get }
    
    func remainingTosses() -> Int
    func isFullyPulled() -> Bool
    func addPull(_ pull: Pull)
    //func getAnnotationView() -> TossAnnotationView
}


extension Toss {
    func remainingTosses() -> Int {
        return tossCount - (initialPulls + pulls.map { $0.count }.reduce(0, +))
    }
    
    func isFullyPulled() -> Bool {
        return remainingTosses() <= 0
    }
    
    func addPull(_ pull: Pull) {
        pulls.append(pull)
    }
}



