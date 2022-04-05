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

enum OnboardingStep {
    case startTrip
    case layEquipment
    case dragEquipment
    case registerCatch
    case endTrip
    
    var nextStep: OnboardingStep? {
        switch self {
        case .startTrip: return .layEquipment
        case .layEquipment: return .dragEquipment
        case .dragEquipment: return .registerCatch
        case .registerCatch: return .endTrip
        case .endTrip: return nil
        }
    }
    
    var title: String {
        switch self {
        case .startTrip: return "Hefja veiðar"
        case .layEquipment: return "Leggja veiðarfæri"
        case .dragEquipment: return "Draga veiðarfæri"
        case .registerCatch: return "Skráir afla"
        case .endTrip: return "Ljúka veiðum"
        }
    }
    
    var description: String {
        switch self {
        case .startTrip: return "Þú byrjar að velja hefja veiðar áður en þú leggur veiðarfæri"
        case .layEquipment: return "Eftir veiðar eru hafnar þá leggur þú veiðarfærin"
        case .dragEquipment: return "Þú velur viðkomandi veiðarfæri og síðan þau net sem þú ætlar draga"
        case .registerCatch: return "Þú nálgast skráningu afla með því að velja “Skrá afla” í valstiku"
        case .endTrip: return "Þú velur að ljúka veiðum og skila inn þegar þú hefur dregið öll veiðarfæri og skráð afla"
        }
    }
}

protocol OnboardingPageControllerDelegate: class {
    func onboardingPageControllerDidFinish(_ onboardingPageController: OnboardingPageController)
}

class OnboardingPageController: UIViewController {
    
    weak var onboardingDelegate: OnboardingPageControllerDelegate?
    
    private var step: OnboardingStep = .startTrip {
        didSet {
            pageController.setViewControllers([
                OnboardingViewController(withStep: step)
            ],
            direction: .forward, animated: true, completion: nil)
        }
    }
    
    lazy var pageController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        return controller
    }()
    
    // MARK: - Views
    lazy var background: UIImageView = {
        let view = UIImageView(image: Asset.background.image)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var logo: UIImageView = {
        let view = UIImageView(image: Asset.logo.image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.text = "Velkomin/n í Afladagbók"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var btnCancel: Button = {
        let view = Button(title: "SLEPPA")
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.action = { [weak self] in
            guard let this = self else { return }
            this.onboardingDelegate?.onboardingPageControllerDidFinish(this)
        }
        
        return view
    }()
    
    lazy var btnContinue: Button = {
        let view = Button(title: "Áfram")
        view.backgroundColor = Color.custom(hexString: "87C93E", alpha: 1.0).value
        view.setTitleColor(.white, for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false

        view.action = { [weak self] in
            guard let this = self else { return }
            
            if let nextStep = this.step.nextStep {
                this.step = nextStep
            } else {
                this.onboardingDelegate?.onboardingPageControllerDidFinish(this)
            }
        }
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(background)
        view.addSubview(pageController.view)
        view.addSubview(logo)
        view.addSubview(welcomeLabel)
        view.addSubview(btnCancel)
        view.addSubview(btnContinue)
        
        
        pageController.setViewControllers([
            OnboardingViewController(withStep: .startTrip),
        ],
        direction: .forward, animated: false, completion: nil)
      
        setupConstraints()
    }
    
    func setupConstraints() {
        // background
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // Logo
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            logo.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        // Welcome Label
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Button Cancel
        NSLayoutConstraint.activate([
            btnCancel.bottomAnchor.constraint(equalTo: btnContinue.topAnchor),
            btnCancel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnCancel.widthAnchor.constraint(equalToConstant: 100),
            btnCancel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
        
        
        // Button Continue
        NSLayoutConstraint.activate([
            btnContinue.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            btnContinue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -20),
            btnContinue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            btnContinue.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
    }
}
