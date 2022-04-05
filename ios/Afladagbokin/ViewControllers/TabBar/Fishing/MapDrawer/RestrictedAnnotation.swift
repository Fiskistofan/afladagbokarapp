// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
/*
import Mapbox

class RestrictedAnnotation: NSObject, MGLAnnotation {
    let id: String
    let restrictedZone: RestrictedZone
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(restrictedZone: RestrictedZone) {
        self.id = UUID().uuidString
        self.restrictedZone = restrictedZone
        let numOfCoords = Double(restrictedZone.coordinates.count)
        let lat = restrictedZone.coordinates
            .map { $0.latitude }
            .reduce(0, +) / numOfCoords
        
        let lon = restrictedZone.coordinates
            .map { $0.longitude }
            .reduce(0, +) / numOfCoords
 
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RestrictedAnnotation {
    func getAnnotationView() -> RestrictedAnnotationView {
        return RestrictedAnnotationView(reuseIdentifier: "RestrictedAnnotationView")
    }
}
*/
