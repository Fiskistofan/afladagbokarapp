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

protocol FishingViewDelegate: class {
    func fishingViewDidPressStart(_ fishingView: FishingView)
}


class FishingView: View {
    weak var delegate: FishingViewDelegate?
    
    private lazy var icelandImage: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .iceland))
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var anchorImage: UIImageView = {
        let view = UIImageView(image: UIImage(asset: .anchor))
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor.init(hexString: "33537F");
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.text = "Þú þarft að  hefja veiðar og draga\nveiðarfæri til að skrá aflann."
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.textColor = Color.white.value
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var isButtonVisible = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                guard let self = self else { return }
                self.startButton.alpha = self.isButtonVisible ? 1 : 0
            })
        }
    }
    
    private lazy var startButton: Button = {
        let button = Button(title: "Hefja veiðar")
        button.alpha = 0
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(hexString: "87C93E").withAlphaComponent(0.7).cgColor
        button.layer.borderWidth = 2
        
        button.action = { [weak self] in
            guard let self = self else { return }
            self.delegate?.fishingViewDidPressStart(self)
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var layoutGuide = UILayoutGuide()
    
    override func build() {
        super.build()
        
        backgroundColor = UIColor.init(hexString: "0E233F")
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(icelandImage)
        addSubview(anchorImage)
        addSubview(title)
        addSubview(startButton)
        addLayoutGuide(layoutGuide)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        // Iceland Image
        NSLayoutConstraint.activate([
            icelandImage.topAnchor.constraint(equalTo: self.topAnchor),
            icelandImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            icelandImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            icelandImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // Anchor Image
        let heightOfsett = UIScreen.main.bounds.height * -0.1
        NSLayoutConstraint.activate([
            anchorImage.centerXAnchor.constraint(equalTo: icelandImage.centerXAnchor),
            anchorImage.centerYAnchor.constraint(equalTo: icelandImage.centerYAnchor, constant: heightOfsett),
        ])
        
        // Title Text
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.topAnchor.constraint(equalTo: anchorImage.bottomAnchor, constant: 40),
        ])
        
        // Layout Guide
        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: title.bottomAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        // Start Button
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            startButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            startButton.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 77),
        ])
    }
}
