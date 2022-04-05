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
import SnapKit


/* The types of notifcations available */
enum NotificationType {
    case normal
    case warning
    case error
    case push
}


/* Conform to this protocol to style the notfication */
protocol NotificationDelegate{
    
    func color(for notification: NotificationType) -> UIColor?
    func viewBackgroundColor() -> UIColor
    func height() -> CGFloat
    func paddingX() -> CGFloat
    func paddingY() -> CGFloat
    func cornerRadius() -> CGFloat?
    func borderColor() -> UIColor?
    func borderWidth() -> CGFloat?
    func titleMessage() -> UILabel!
    func tinyMessage() -> UILabel!
    func notificationDuration() -> Double
    func notificationAnimationDuration() -> Double
    
}

/* Override this class to style the notifcation */
class NotifcationCustomization: NotificationDelegate{
    
    func color(for notification: NotificationType) -> UIColor?{
        
        switch notification {
        case .normal: 	return Color.green.value
        case .warning: 	return Color.blue.value
        case .error: 	return Color.redGradientStart.value
        case .push:     return Color.redGradientStart.value
        }
    }
    
    func height() -> CGFloat {
        return 60.0
    }
    
    func paddingX() -> CGFloat {
        return 20.0
    }
    
    func paddingY() -> CGFloat {
        return 30.0
    }
    
    func borderColor() -> UIColor? {
        return .clear
    }
    
    func borderWidth() -> CGFloat? {
        return 0.0
    }
    
    func cornerRadius() -> CGFloat? {
        return CornerRadius.base.rawValue
    }
    
    func titleMessage() -> UILabel! {
        
        let label = UILabel()
        label.styleAsCustomLabel(with: Fonts.System.regular.of(size: 13), color: Color.white.value)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }
    
    func tinyMessage() -> UILabel! {
        
        let label = UILabel()
        label.styleAsCustomLabel(with: Fonts.System.bold.of(style: .caption1), color: Color.white.value)
        label.textAlignment = .center
        
        return label
    }
    
    func notificationDuration() -> Double {
        return 5.0
    }
    
    func notificationAnimationDuration() -> Double{
        return 1.2
    }
    
    func viewBackgroundColor() -> UIColor{
        return .red
    }
}


/* The notification class */
class StokkurNotification: NSObject {
    
    //backgroundView
    fileprivate var view: UIView!
    //the notification
    fileprivate var notification: UIView!
    //the type of notification
    fileprivate let type: NotificationType!
    //the owner
    fileprivate let controller:UIViewController!
    //the title
    fileprivate var titleLabel: UILabel!
    //the subtitle
    fileprivate var tinyLabel:UILabel!
    //the start position of the notification
    fileprivate let startPosY = -100 as CGFloat
    //the tap gesture to dismis sthe view
    fileprivate var viewTap:UITapGestureRecognizer!
    //the swipe gesture to dismis sthe view
    fileprivate var notificationSwipe:UISwipeGestureRecognizer!
    //the tap gesture for the notification
    fileprivate var notificationTap:UITapGestureRecognizer!
    //the queue that manages the banners
    fileprivate let queue = StokkurNotificationQueue.queue
    //the displayed title
    fileprivate let title:String
    //the displayed subtitle
    fileprivate let subtitle:String
    //the delegate to customize
    fileprivate let delegate: NotificationDelegate!
    
    public var onSelection: (()->())?
    
    init(with type: NotificationType, title: String, subtitle: String, delegate: NotificationDelegate = NotifcationCustomization(), for controller: UIViewController) {
        
        self.controller = controller
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.delegate = delegate
        
        super.init()
        
        setup()
        //add it to the queue
        self.queue.addNotification(self)
    }
    
    
    deinit {
        
        print("deallocated notification")
        clear()
    }
    
    
    public func start(){
        show()
    }
    
    
    private func setup(){
        
        self.view = UIView()
        self.view.backgroundColor = .clear
        self.view.alpha = 0
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(view)
        }
            
        else if let navigation = self.controller.navigationController{
            navigation.view.addSubview(view)
        }
        else{
            self.controller.view.addSubview(view)
        }
        
        self.notification = UIView()
        self.notification.backgroundColor = self.delegate.color(for: self.type)
        self.view.addSubview(self.notification)
        
        if let radius = self.delegate.cornerRadius(){
            self.notification.layer.masksToBounds = radius > 0.0
            self.notification.layer.cornerRadius = radius
        }
        
        self.tinyLabel = self.delegate.tinyMessage()
        self.tinyLabel.text = self.subtitle
        self.notification.addSubview(self.tinyLabel)
        self.titleLabel = self.delegate.titleMessage()
        self.titleLabel.text = self.title
        self.notification.addSubview(self.titleLabel)
        
        setupConstraints()
        setupRecognizers()
    }
    
    
    private func setupRecognizers(){
        
        self.viewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleViewTap(_:)))
        self.viewTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(self.viewTap)
        
        
        self.notificationTap = UITapGestureRecognizer(target: self, action: #selector(self.handleNotificationTap(_:)))
        self.notificationTap.numberOfTapsRequired = 1
        self.notification.addGestureRecognizer(self.notificationTap)
        
        self.notificationSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleViewSwipe(_:)))
        self.notificationSwipe.direction = .up
        self.notification.addGestureRecognizer(self.notificationSwipe)
    }
    
    
    private func setupConstraints(){
        
        self.view.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.controller.view)
            make.left.right.equalTo(0)
        }
        
        self.notification.snp.makeConstraints { (make) in
            make.top.equalTo(startPosY)
            make.left.equalTo(self.delegate.paddingX())
            make.right.equalTo(-self.delegate.paddingX())
        }
        
        self.tinyLabel.snp.makeConstraints { make in
            make.left.top.right.equalTo(self.notification).inset(13)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.right.left.equalTo(self.tinyLabel)
            make.top.equalTo(self.tinyLabel).inset(20)
        }
        
        self.notification.snp.makeConstraints { (make) in
            make.height.equalTo(self.titleLabel).inset(-25)
        }
    }
    
    
    fileprivate func clear(){
        
        if self.notification != nil{
            self.notification.removeGestureRecognizer(self.notificationSwipe)
            self.notification.removeFromSuperview()
            self.notification = nil
        }
        
        if self.view != nil{
            self.view.removeGestureRecognizer(self.viewTap)
            self.view.removeFromSuperview()
            self.view = nil
        }
    }
}

extension StokkurNotification: UIGestureRecognizerDelegate{
    
    @objc func handleViewTap(_ sender: UITapGestureRecognizer) {
        hide()
    }
    
    @objc func handleNotificationTap(_ sender: UITapGestureRecognizer) {
        
        hide()
        guard let selected = onSelection else { return }
        selected()
    }
    
    @objc func handleViewSwipe(_ sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .up{
            hide()
        }
    }
    
}


fileprivate extension StokkurNotification{
    
    func addTimer(){
        perform(#selector(hide), with: nil, afterDelay: self.delegate.notificationDuration())
    }
    
    
    func cancelExistingTimers(){
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
    }
    
    
    func show(){
        
        let delay = 0.1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            
            guard let this = self else { return }
            
            this.addTimer()
            
            NotificationHapticGenerator.generate(.heavy)
            
            let duration = this.delegate.notificationAnimationDuration()
            
            this.notification.animate(
                .custom(duration: duration, type: .spring(delay: 0.0, op: .curveEaseOut, springDamping: 0.6, sprintVelocity: 0.7), closure: { (view) in
                    
                    view.snp.updateConstraints { (make) in
                        make.top.equalTo(this.delegate.paddingY())
                    }
                    
                    view.superview?.layoutIfNeeded()
                    
                    this.view.alpha = 1.0
                })
            )
        }
    }
    
    
    @objc func hide(){
        
        cancelExistingTimers()
        
        let duration = self.delegate.notificationAnimationDuration()
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.notification.snp.updateConstraints { (make) in
                make.top.equalTo(self.startPosY)
            }
            
            self.notification.superview?.layoutIfNeeded()
            
            self.view.alpha = 0
            
            
        }) { (complete) in
            
            self.clear()
            self.queue.showNext({ (hasNotification) in
                if hasNotification == false{
                    print("all notifcations are done")
                }
            })
        }
    }
}

