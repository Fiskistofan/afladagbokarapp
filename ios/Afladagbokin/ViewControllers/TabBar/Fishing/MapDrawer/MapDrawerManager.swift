// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//import Mapbox
//
//protocol MapDrawerManagerDelegate: class {
//    func mapDrawerManagerDidChangeAnnotations(_ mapDrawerManager: MapDrawerManager, totalAnnotations: Int)
//}
//
//class MapDrawerManager {
//    let mapView: MGLMapView
//    var style: MGLStyle!
//    weak var delegate: MapDrawerManagerDelegate?
//    
//    
//    var restrictedZones: [String : RestrictedZone] = [:]
//    var boatPolyline: MGLShapeSource?
//    var boatCoordinates: [CLLocationCoordinate2D] {
//        willSet {
//            guard !newValue.isEmpty else {
//                return
//            }
//            var mutableCoordinates = newValue
//            let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
//            
//            boatPolyline?.shape = polyline
//        }
//    }
//    
//    private var tossAnnotations: Set<TossAnnotation> {
//        willSet {
//            delegate?.mapDrawerManagerDidChangeAnnotations(self, totalAnnotations: newValue.count)
//        }
//    }
//    
//    var tosses: [TossAnnotation] {
//        return tossAnnotations.sorted(by: { $0.toss.date > $1.toss.date })
//    }
//    
//    
//    init(mapView: MGLMapView) {
//        self.mapView = mapView
//        self.boatCoordinates = []
//        self.tossAnnotations = Set<TossAnnotation>()
//    }
//}
//
//
//// MARK - Initial Setup
//extension MapDrawerManager {
//    /**
//     Sets up the style for the boat path polyline and adds it to the map
//     */
//    func addLayerToStyle(_ style: MGLStyle) {
//        self.style = style
//        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
//        style.addSource(source)
//        self.boatPolyline = source
//        
//        // Add a layer to style our polyline.
//        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
//        layer.lineJoin = MGLStyleValue(rawValue: NSValue(mglLineJoin: .round))
//        layer.lineCap = MGLStyleValue(rawValue: NSValue(mglLineCap: .round))
//        layer.lineColor = MGLStyleValue(rawValue: UIColor.white)
//        layer.lineWidth = MGLStyleFunction(interpolationMode: .exponential,
//                                           cameraStops: [14: MGLConstantStyleValue<NSNumber>(rawValue: 5),
//                                                         18:MGLConstantStyleValue<NSNumber>(rawValue: 20)],
//                                           options: [.defaultValue : MGLConstantStyleValue<NSNumber>(rawValue: 1.0)])
//        layer.lineDashPattern = MGLStyleValue(rawValue: [0, 2])
//    
//        style.addLayer(layer)
//    }
//}
//
//
//// MARK - Draw
//extension MapDrawerManager {
//    /**
//     */
//    func addBoatCoordinate(_ coordinate: CLLocationCoordinate2D) {
//        self.boatCoordinates.append(coordinate)
//    }
//    
//    /**
//     */
//    func addAnnotation(_ annotation: TossAnnotation) {
//        tossAnnotations.insert(annotation)
//        mapView.addAnnotation(annotation)
//    }
//    
//    /**
//     */
//    func addRestrictedZone(_ restrictedZone: RestrictedZone) {
//        var coordinates = restrictedZone.coordinates.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//        let shape = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
//        let id = String(restrictedZone.id)
//        shape.title = id
//        self.restrictedZones[id] = restrictedZone
//        
//        mapView.addAnnotation(shape)
//    }
//}
//
//
//// MARK - Fetch
//extension MapDrawerManager {
//    /**
//     */
//    func fetchRestrictedZone(id: String) -> RestrictedZone? {
//        return self.restrictedZones[id]
//    }
//}
//
//
//// MARK - Remove
//extension MapDrawerManager {
//    /**
//     Removes the first stored `Toss`.
//    */
//    func removeAnnotation(_ annotation: TossAnnotation) {
//        tossAnnotations.remove(annotation)
//        mapView.removeAnnotation(annotation)
//    }
//    
//    /**
//     */
//    func clear() {
//        for toss in tossAnnotations { removeAnnotation(toss) }
//        boatCoordinates = []
//    }
//}
//
