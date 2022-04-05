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
import UIKit
import Mapbox


protocol RestrictedAnnotationViewDelegate: class {
    func restrictedAnnotationViewDidSelect(_ restrictedAnnotationView: RestrictedAnnotationView)
}


class RestrictedAnnotationView: MGLAnnotationView {
    weak var delegate: RestrictedAnnotationViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        let anno = self.annotation as! RestrictedAnnotation
        var coordinates = anno.restrictedZone.coordinates.flatMap { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        let poly = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))

        let source = MGLSource.init(identifier: "asd")
        
        MGLCircleStyleLayer.init(identifier: <#T##String#>, source: <#T##MGLSource#>)
        self.addSubview(poly)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let annotation = annotation as? RestrictedAnnotation else {
            return
        }
        
        print("DID SELECT ANNOTATION WITH ID: \(annotation.id)")
        delegate?.restrictedAnnotationViewDidSelect(self)
    }
}
*/
