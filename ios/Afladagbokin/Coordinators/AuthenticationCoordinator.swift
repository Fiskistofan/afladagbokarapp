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

protocol AuthenticationCoordinatorDelegate: class{
    func authenticationCoordinatorDidFinish(authenticationCoordinator: AuthenticationCoordinator)
}

class AuthenticationCoordinator: Coordinator{
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var navigationController: UINavigationController
    
    
    //MARK: Properties
    
    var rootViewController: UIViewController?
    var authenticationDelegate: AuthenticationCoordinatorDelegate?
    
    //Coordinator protocol var
    var childCoordinators: [Coordinator] = []
     
    
    deinit {
        print("[AuthenticationCoordinator] - Did deinit")
    }
    
    //Coordinator Protocol
    public func start(){
        
        let authVM = AuthenticationViewModel()
        let authenticationVC = AuthenticationViewController(viewModel: authVM)
        authenticationVC.delegate = self
        self.navigationController.setViewControllers([authenticationVC], animated: true)
        self.rootViewController = authenticationVC
        
        
        self.rootViewController?.present(AppClosingDialogViewController(), animated: true, completion: nil)
    }
}

extension AuthenticationCoordinator: AuthenticationViewControllerDelegate{
    
    func didFinishWithSuccessfulLogin() {
        self.authenticationDelegate?.authenticationCoordinatorDidFinish(authenticationCoordinator: self)
    }
}
