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


public class StokkurNotificationQueue: NSObject {
    
    //Access through singleton
    public static let queue = StokkurNotificationQueue()
    
    //The queue of notifications
    private(set) var notifications: [StokkurNotification] = []
    
    //The current number of notification banners on the queue
    public var numberOfBanners: Int {
        return notifications.count
    }
    
    /*
     * Adds a notification to the queue. If only one then show it immediately.
     */
    func addNotification(_ banner: StokkurNotification) {
        
        notifications.append(banner)
        
        if notifications.index(of:banner) == 0 {
            banner.start()
        }
    }
    

    /*
     * Shows the next notification if there are any
     */
    func showNext(_ complete: ((_ hasNotifications: Bool) -> Void)) {
        
        if !notifications.isEmpty {
            notifications.removeFirst()
        }
        
        guard let banner = notifications.first else {
            complete(false)
            return
        }

        banner.start()
        complete(true)
	}
}
