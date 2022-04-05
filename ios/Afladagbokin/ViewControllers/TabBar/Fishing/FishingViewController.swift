// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import SVProgressHUD
import ReactiveKit
import Bond
import Lottie
import CoreLocation


protocol FishingViewControllerDelegate: class {
    func fishingViewControllerDidStopTour(_ fishingViewController: FishingViewController)
    func fishingViewControllerDidStartTour(_ fishingViewController: FishingViewController)
    func didWantLogging()
}

class FishingViewController: BaseViewController {
    enum NotificationHeight: CGFloat {
        case normal = 150
        case large = 200
    }
    
    @IBOutlet weak var cNotificationHeight: NSLayoutConstraint!
    @IBOutlet weak var cErrorViewToTop: NSLayoutConstraint!
    @IBOutlet weak var noInternetView: NoInternetView!
    let animationDuration = 0.5
    @IBOutlet weak var fishingView: FishingView!
    @IBOutlet weak var viewWarning: WarningView!
    @IBOutlet weak var viewTossInfo: TossInfoView!
    @IBOutlet weak var cViewWarningHeight: NSLayoutConstraint!
    @IBOutlet weak var viewEquipment: LogEquipmentView!
    let viewModel: FishingViewModel
    let disposeBag = DisposeBag()
    var progressView: UIProgressView!
    @IBOutlet weak var viewVeidarfaeri: UIView!
    @IBOutlet weak var btnLeggja: UIButton!
    @IBOutlet weak var btnDraga: UIButton!
    @IBOutlet weak var cBtnFromTop: NSLayoutConstraint!
    
    var keyboardViewIntersections: [(UIView, CGFloat)] = []
    var animationView: LOTAnimationView?
    var delegate: FishingViewControllerDelegate?
    
    let locationManager = CLLocationManager()
    var userCoordinates: CLLocationCoordinate2D?
    
    
    //MARK: Lifecycle & init
    init(viewModel: FishingViewModel){
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    
        setup()
        setupBindings()
        setupLottie()
        style() 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        setupGradients()
        if let equipmentType = Session.manager.getSelectedEquipmentId() {
            self.viewModel.equipmentType = EquipmentType(rawValue: equipmentType)
        }
    }
    
}



// MARK: - Setup
extension FishingViewController {
    @objc func tossLogged(_ notification: Notification) {
        guard let toss = notification.object as? Toss else {
            print("Notification.Error — Invalid Toss object")
            return
        }
        
        let tosses = Session.manager.getTosses().count
        btnDraga.isEnabled = tosses > 0
        btnDraga.alpha = tosses > 0 ? 1.0 : 0.5
    }
    
    /**
     */
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowFishing), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideFishing), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self,
              selector: #selector(tossLogged),
              name: .tossLogged,
              object: nil
          )
        
        self.dismissKeyboardOnViewTap()
        
        fishingView.delegate = self
        
        noInternetView.delegate = self
        noInternetView.clipsToBounds = true
        self.view.bringSubview(toFront: noInternetView)
        
        viewWarning.delegate = self
        viewWarning.alpha = 0
        
        viewEquipment.alpha = 0
        
        viewTossInfo.delegate = self
        viewTossInfo.alpha = 0
        
        btnDraga.setTitle("DRAGA\nVEIÐARFÆRI", for: .normal)
        btnLeggja.setTitle("LEGGJA\nVEIÐARFÆRI", for: .normal)
        
        _ = btnLeggja.reactive.tap.observeNext{ _ in
            guard let type = self.viewModel.equipmentType else {
                // Display no equipment error?
                return
            }
            
            self.addTossOfType(type)
        }
        
        _ = btnDraga.reactive.tap.observeNext { _ in
            // Show list of current tosses?
            // Save to session?
            let tosses = Session.manager.getTosses()
            let dragView = DragView()
            dragView.setAnnotation(tosses)
            dragView.delegate = self
            
            dragView.translatesAutoresizingMaskIntoConstraints = false
            
            self.showView(dragView, whileDisabling: self.btnDraga, self.btnLeggja)
            
            let margins = self.view.layoutMarginsGuide
            dragView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 12).isActive = true
            dragView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -12).isActive = true
            dragView.topAnchor.constraint(equalTo: self.viewVeidarfaeri.bottomAnchor, constant: 30).isActive = true
            dragView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        }
        
    }
    
    /**
     */
    func setupGradients() {
        let gradientHelper = GradientHelper()
        gradientHelper.addGradientTo(view: btnDraga, frame: CGRect(x: 0, y:0, width: btnDraga.bounds.width, height: 64), colors: [Color.redVeidifaeriStart.value.cgColor, Color.redVeidifaeriMid.value.cgColor, Color.redVeidifaeriEnd.value.cgColor], startPoint:CGPoint(x: 0.53, y: -0.72), endPoint: CGPoint(x: 0.59, y: 1.45))
        
        gradientHelper.addGradientTo(view: btnLeggja, frame: CGRect(x: 0, y:0, width: btnLeggja.bounds.width, height: 64), colors: [Color.greenVeidifaeriStart.value.cgColor, Color.greenVeidifaeriEnd.value.cgColor], startPoint: CGPoint(x: 0.4, y: -0.29), endPoint: CGPoint(x: 0.4, y: 1.91))
        
        gradientHelper.addGradientTo(view: self.viewVeidarfaeri, frame: self.viewVeidarfaeri.frame, colors: [Color.blueVeidifaeriStart.value.cgColor, Color.blueVeidifaeriEnd.value.cgColor], startPoint: CGPoint(x: 0.5, y: -2.07), endPoint: CGPoint(x: 0.5, y: 1))
    }
    
    /**
     */
    func style() {
        btnDraga.styleAsVeidifaeri()
        btnLeggja.styleAsVeidifaeri()
        
        if UIDevice.current.iPhoneX{
            cBtnFromTop.constant += 13
        }
        
        let tosses = Session.manager.getTosses().count
        btnDraga.isEnabled = tosses > 0
        btnDraga.alpha = tosses > 0 ? 1.0 : 0.5
    }
    
    /**
     */
    func setupBindings() {
        self.viewModel.equipmentInput.bidirectionalBind(to: self.viewEquipment.txtField.reactive.text)
        
        _ = UserDefaults.standard.reactive
            .keyPath(Session.isFishingKey, ofType: Optional<Bool>.self, context: .immediateOnMain)
            .observeNext{ [weak self] value in
                
                guard let myValue = value else {
                    return
                }
                if myValue {
                    self?.hideStartFishing()
                    UIView.animate(withDuration: 0.25, animations: {
                        self?.viewVeidarfaeri.alpha = 1
                        self?.viewVeidarfaeri.isHidden = false
                    })
                }
                else {
                    self?.showStartFishing()
                    UIView.animate(withDuration: 0.25, animations: {
                        self?.viewVeidarfaeri.alpha = 0
                        self?.viewVeidarfaeri.isHidden = true
                    })
                }
        }
    }
    
}



// MARK: - Add/Remove Toss
extension FishingViewController {
    /**
     */
    func addTossOfType(_ equipment: EquipmentType) {
        
        
        guard let currLocation = locationManager.location?.coordinate else {
            showLocationError()
            return
        }
        
        let margin: CGFloat = 15.0
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 2 * margin, height: 300)
        
        switch equipment.baseType {
        case .lina:
            let onglar = Session.manager.getOnglaCount()
            let bjodar = Session.manager.getBjodaCount()
            let toss = Lina(coordinates: currLocation, type: equipment, onglaCount: onglar, bjodaCount: bjodar)
            logToss(toss)
            
        case .handfaeri:
            let tossView = HandfaeriTossView(frame: frame)
            tossView.center = self.view.center
            tossView.delegate = self
            self.showView(tossView, whileDisabling: btnDraga, btnLeggja)
            
        case .net:
            let tossView = NetTossView(frame: frame)
            tossView.center = self.view.center
            tossView.delegate = self
            self.showView(tossView, whileDisabling: btnDraga, btnLeggja)
        }
    }
}


// MARK: - Log Toss/Pull
extension FishingViewController {
    /**
     */
    func logToss(_ toss: Toss) {
        Session.manager.saveToss(toss)
        
        let tosses = Session.manager.getTosses()
        print("tosses: \(tosses.count)")
    }
    
    /**
     */
    func logPull(_ pull: Pull) {
        Session.manager.savePull(pull)
        
        let pulls = Session.manager.getPulls()
        print("pulls: \(pulls.count)")
    }
}


// MARK: - Show/Hide/Disable View {
extension FishingViewController {
    /**
     */
    func showView(_ view: UIView, whileDisabling views: UIView...) {
        self.view.addSubview(view)
        
        _ = views.map { self.disableView($0) }
        
        UIView.animate(withDuration: animationDuration) {
            view.alpha = 1
        }
    }
    
    /**
     */
    func removeView(_ view: UIView, whileEnabling views: UIView...) {
        _ = views.map { self.enableView($0) }
        UIView.animate(withDuration: animationDuration, animations: {
            view.alpha = 0
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }
    
    /**
     */
    func enableView(_ view: UIView) {
        UIView.animate(withDuration: animationDuration) {
            view.alpha = 1
            view.isUserInteractionEnabled = true
        }
    }
    
    /**
     */
    func disableView(_ view: UIView) {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: animationDuration) {
            view.alpha = 0.8
        }
    }
    
}



// MARK: - ErrorView
extension FishingViewController {
    /**
     */
    func showErrorWithText(text: String) {
        cNotificationHeight.constant = 233
        noInternetView.setupAsErrorWithText(errorText: text)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration) {
            self.cErrorViewToTop.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     */
    func hideError() {
        UIView.animate(withDuration: animationDuration) {
            self.cErrorViewToTop.constant = -250
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}



// MARK: - WarningView
extension FishingViewController {
    /**
     */
    func showWarning(warningText: String) {
        viewWarning.setupAsErrorWith(boat: warningText)
        UIView.animate(withDuration: 0.5) {
            self.viewWarning.alpha = 1
        }
    }
    
    /**
     */
    func showYellowWarning() {
        UIView.animate(withDuration: 0.5) {
            self.viewWarning.alpha = 1
        }
    }
    
    /**
     */
    func showEncourgement() {
        viewWarning.setupAsEncouragement()
        UIView.animate(withDuration: 0.5) {
            self.viewWarning.alpha = 1
        }
    }
    
    /**
     */
    func hideWarning() {
        UIView.animate(withDuration: 0.5) {
            self.viewWarning.alpha = 0
        }
    }

}


// MARK: - EquipmentView
extension FishingViewController {
    /**
     */
    func showEquipmentView() {
        UIView.animate(withDuration: animationDuration) {
            self.viewEquipment.alpha = 1
        }
    }
    
    /**
     */
    func hideEquipmentView() {
        UIView.animate(withDuration: animationDuration) {
            self.viewEquipment.alpha = 0
        }
    }
}



// MARK: - TossInfoView
extension FishingViewController {
    /**
     */
    func showTossInfoView() {
        _ = [btnDraga, btnLeggja].map { self.disableView($0) }
        UIView.animate(withDuration: animationDuration) {
            //self.mapView.alpha = 0.5
            self.viewTossInfo.alpha = 1
        }
    }
    
    /**
     */
    func hideTossInfoView() {
        _ = [btnDraga, btnLeggja].map { self.enableView($0) }
        UIView.animate(withDuration: animationDuration) {
            //self.mapView.alpha = 1
            self.viewTossInfo.alpha = 0
        }
    }
}


// MARK: - NoInternetView
extension FishingViewController {
    /**
     */
    func showDragSuccess(forType type: NoInternetView.SuccessType) {
        switch type {
        case .handfaeri, .lina:
            self.cNotificationHeight.constant = NotificationHeight.normal.rawValue
        default:
            self.cNotificationHeight.constant = NotificationHeight.large.rawValue
        }
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        noInternetView.setupAsGreenViewWith(successType: type)
        UIView.animate(withDuration: 0.8, animations: {
            self.cErrorViewToTop.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.hideDragSuccess()
                self.askToLog()
            })
        })
    }
    
    /**
     */
    func hideDragSuccess() {
        UIView.animate(withDuration: 0.8) {
            self.cErrorViewToTop.constant = -self.noInternetView.frame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
}



// MARK: - NoInternetViewDelegate
extension FishingViewController: NoInternetViewDelegate {
    /**
     */
    func close() {
        hideError()
    }
}



// MARK: - WarningViewDelegate
extension FishingViewController: WarningViewDelegate {
    /**
     */
    func hide() {
        self.hideWarning()
    }
}



// MARK: - LinaTossViewDelegate
extension FishingViewController: LinaTossViewDelegate {
    /**
     */
    func linaTossViewDidFinishWithInput(_ linaTossView: LinaTossView, onglaCount: Int, bjodarCount: Int) {
        guard let currLocation = locationManager.location?.coordinate else {
            showLocationError()
            return
        }
        
        guard let type = self.viewModel.equipmentType else {
            // Show no equipment error?
            return
        }
        
        let toss = Lina(coordinates: currLocation, type: type, onglaCount: onglaCount, bjodaCount: bjodarCount)
        logToss(toss)
        
        removeView(linaTossView, whileEnabling: btnLeggja, btnDraga)
    }
}



// MARK: - NetTossViewDelegate
extension FishingViewController: NetTossViewDelegate {
    /**
     */
    func netTossViewDidFinishWithInput(_ netTossView: NetTossView, netCount: Int) {
        guard let currLocation = locationManager.location?.coordinate else {
            showLocationError()
            return
        }
        
        guard let type = self.viewModel.equipmentType else {
            // Show no equipment error?
            return
        }
        
        let toss = Net(coordinates: currLocation, type: type, tossCount: netCount)
        logToss(toss)
        
        removeView(netTossView, whileEnabling: btnDraga, btnLeggja)
    }
}



// MARK: - HandfaeriTossViewDelegate
extension FishingViewController: HandfaeriTossViewDelegate {
    /**
     */
    func handfaeriTossViewDidFinishWithInput(_ handfaeriTossView: HandfaeriTossView, handfaeriCount: Int) {
        guard let currLocation = locationManager.location?.coordinate else {
            showLocationError()
            return
        }
        
        guard let type = self.viewModel.equipmentType else {
            // Show no equipment error?
            return
        }
        
        let toss = Handfaeri(coordinates: currLocation, type: type, tossCount: handfaeriCount)
        logToss(toss)

        removeView(handfaeriTossView, whileEnabling: btnLeggja, btnDraga)
    }
}



// MARK: - TossInfoViewDelegate
extension FishingViewController: TossInfoViewDelegate {
    /**
     */
    func tossInfoViewDidFinishWithClose(_ tossInfoView: TossInfoView) {
        self.hideTossInfoView()
    }
    
    /**
     */
    func tossInfoViewDidFinishWithDrag(_ tossInfoView: TossInfoView, annotation: Toss) {
        self.hideTossInfoView()
        
        let margin: CGFloat = 15.0
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 2 * margin, height: 300)
        
        
        let toss = annotation
        
        switch toss.type.baseType {
        case .net:
            let dragView = NetDragView(frame: frame, annotation: annotation)
            dragView.styleForType(toss.type.baseType)
            dragView.center = self.view.center
            dragView.delegate = self
            
            showView(dragView, whileDisabling: btnLeggja, btnDraga)
        case .handfaeri:
            let count = toss.remainingTosses()
            let pull = Pull(tossId: toss.id, count: count)
            let type = NoInternetView.SuccessType.handfaeri(pulled: count, total: count)
            showDragSuccess(forType: type)
            toss.addPull(pull)
            logPull(pull)
        case .lina:
            let type = NoInternetView.SuccessType.lina
            let pull = Pull(tossId: toss.id)
            showDragSuccess(forType: type)
            toss.addPull(pull)
            logPull(pull)
        }
    }
    
    func askToLog(){
        
        let confirmTourView = ConfirmTourView()
        confirmTourView.delegate = self
        confirmTourView.translatesAutoresizingMaskIntoConstraints = false
        confirmTourView.setupForLogView()
        self.showView(confirmTourView, whileDisabling: self.btnDraga, self.btnLeggja)
        
        let margins = view.layoutMarginsGuide
        confirmTourView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 12).isActive = true
        confirmTourView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -12).isActive = true
        confirmTourView.topAnchor.constraint(equalTo: self.viewVeidarfaeri.bottomAnchor, constant: 45).isActive = true
        confirmTourView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
    }
    
}



//// MARK: - EquipmentAnnotationViewDelegate
//extension FishingViewController: TossAnnotationViewDelegate {
//    func tossAnnotationViewDidSelect(_ equipmentAnnotationView: TossAnnotationView) {
//        guard let annotation = equipmentAnnotationView.annotation as? Toss else {
//            print("[EquipmentAnnotationViewError] — Property ´annotation´ is not of type ´EquipmentAnnotation´")
//            return
//        }
//
//        viewTossInfo.populateView(annotation: annotation)
//        showTossInfoView()
//    }
//}



// MARK: - DragViewDelegate
extension FishingViewController: DragViewDelegate {
    func dragViewDidSelectAnnotation(_ dragView: DragView, annotation: Toss) {
        removeView(dragView)
        viewTossInfo.populateView(annotation: annotation)
        showTossInfoView()
    }
}



// MARK: - NetDragViewDelegate
extension FishingViewController: NetDragViewDelegate {
    func netDragViewDelegateDidFinishWithInput(_ netDragView: NetDragView, dragCount: Int, annotation: Toss, type: EquipmentType.BaseType) {
        let toss = annotation
        
        switch type {
        case .handfaeri:
            let type = NoInternetView.SuccessType.handfaeri(pulled: dragCount, total: toss.remainingTosses())
            showDragSuccess(forType: type)
        case .net:
            let type = NoInternetView.SuccessType.net(pulled: dragCount, total: toss.remainingTosses())
            showDragSuccess(forType: type)
        default:
            break
        }
        
        let pull = Pull(tossId: toss.id, count: dragCount)
        toss.addPull(pull)
        logPull(pull)
        
        
        Session.manager.getTosses().count > 0 ? removeView(netDragView, whileEnabling: btnDraga, btnLeggja) : removeView(netDragView, whileEnabling: btnLeggja)
    }
}


// MARK: - Keyboard
extension FishingViewController {
    
    @objc func keyboardWillShowFishing(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let views = self.view.subviews
        
        var keyboardViewIntersec: [(UIView, CGFloat)] = []
        
        for view in views {
            let frame = view.frame
            
            guard !(view is FishingView) else {
                continue
            }
            
            let intersection = keyboardFrame.intersection(frame)
            
            guard !intersection.isNull else {
                continue
            }
            
            let height = intersection.height
            
            keyboardViewIntersec.append((view, height))
        }
        
        for (view, height) in keyboardViewIntersec {
            view.frame.origin.y -= height
        }
        
        self.keyboardViewIntersections = keyboardViewIntersec
    }
    
    @objc func keyboardWillHideFishing(notification: NSNotification) {
        for (view, height) in keyboardViewIntersections {
            view.frame.origin.y += height
        }
    }
}

// MARK: - Loading Indicator
extension FishingViewController{
    
    
    func setupLottie(){
        
        animationView = LOTAnimationView(name: "dataDefault")
        animationView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        animationView?.contentMode = .scaleAspectFit
        animationView?.clipsToBounds = true
        animationView?.animationSpeed = 0.8
        animationView?.loopAnimation = true
        animationView?.play()
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        animationView?.clipsToBounds = true
        animationView?.alpha = 0
        if let aView = self.animationView{
            self.view.addSubview(aView)
            aView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            aView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func showLottie(){
        animationView?.alpha = 1
    }
    
    func hideLottie(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            // your code here
            UIView.animate(withDuration: 0.25, animations: {
                self.animationView?.alpha = 0
            })
        }
    }
    
    func showStartFishing() {
        fishingView.isButtonVisible = true
    }
    
    func hideStartFishing() {
        fishingView.isButtonVisible = false
    }
}



// MARK: - Touch listener
extension FishingViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let subviews = self.view.subviews
        
        for view in subviews {
            if let tossView = view as? TossView {
                Session.manager.getTosses().count > 0 ? removeView(tossView, whileEnabling: btnDraga, btnLeggja) : removeView(tossView, whileEnabling: btnLeggja)
            }
            
            if let netDragView = view as? NetDragView {
                Session.manager.getTosses().count  > 0 ? removeView(netDragView, whileEnabling: btnDraga, btnLeggja) : removeView(netDragView, whileEnabling: btnLeggja)
            }
            
            if let dragView = view as? DragView {
                Session.manager.getTosses().count  > 0 ? removeView(dragView, whileEnabling: btnDraga, btnLeggja) : removeView(dragView, whileEnabling: btnLeggja)
            }
            
            if let confirmTourView = view as? ConfirmTourView {
                Session.manager.getTosses().count > 0 ? removeView(confirmTourView, whileEnabling: btnDraga, btnLeggja) : removeView(confirmTourView, whileEnabling: btnLeggja)
            }
        }
    
    }
}



// MARK: - StopTour
extension FishingViewController {
    /**
     */
    func stopTour() {
        let confirmTourView = ConfirmTourView()
        confirmTourView.delegate = self
        confirmTourView.translatesAutoresizingMaskIntoConstraints = false
    
        self.showView(confirmTourView, whileDisabling: self.btnDraga, self.btnLeggja)
        
        let margins = view.layoutMarginsGuide
        confirmTourView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 12).isActive = true
        confirmTourView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -12).isActive = true
        confirmTourView.topAnchor.constraint(equalTo: self.viewVeidarfaeri.bottomAnchor, constant: 45).isActive = true
        confirmTourView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -20).isActive = true
    }
    
}


// MARK: - ConfirmTourViewDelegate
extension FishingViewController: ConfirmTourViewDelegate {
    func confirmTourViewDidFinishWithConfirm(_ confirmTourView: ConfirmTourView) {
        Session.manager.getTosses().count  > 0 ? removeView(confirmTourView, whileEnabling: btnDraga, btnLeggja) : removeView(confirmTourView, whileEnabling: btnLeggja)
        delegate?.fishingViewControllerDidStopTour(self)
        
    }
    
    func confirmDragLog(_ confirmTourView: ConfirmTourView){
        
        delegate?.didWantLogging()
        Session.manager.getTosses().count  > 0 ? removeView(confirmTourView, whileEnabling: btnDraga, btnLeggja) : removeView(confirmTourView, whileEnabling: btnLeggja)
    }
    
    func confirmTourViewDidFinishWithCancel(_ confirmTourView: ConfirmTourView) {
        Session.manager.getTosses().count  > 0 ? removeView(confirmTourView, whileEnabling: btnDraga, btnLeggja) : removeView(confirmTourView, whileEnabling: btnLeggja)
    }
}


// MARK: - FishingViewDelegate
extension FishingViewController: FishingViewDelegate {
    func fishingViewDidPressStart(_ fishingView: FishingView) {
        delegate?.fishingViewControllerDidStartTour(self)
    }
}


// MARK: - Location Disabled
extension FishingViewController {
    func showLocationError() {
        let alertController = UIAlertController (title: "Ekki tókst að greina staðsetningu",
                                                 message: "Til þess að leggja veiðarfæri þarftu að leyfa aðgengi að staðsetningu í stillingum fyrir appið",
                                                 preferredStyle: .alert)

                let settingsAction = UIAlertAction(title: "Stillingar", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            
            let cancelAction = UIAlertAction(title: "Loka", style: .cancel, handler: nil)
        
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)

            present(alertController, animated: true, completion: nil)
    }
}


// MARK: - CLLocationManagerDelegate
extension FishingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse { return }
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}






