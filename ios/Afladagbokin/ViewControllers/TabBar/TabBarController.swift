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
import ReactiveKit
import Bond

protocol MidButtonDelegate:class{
    
    func greenClicked()
    
    func redClicked()
    
    func regularClicked()
}

class TabBarController: UITabBarController{
    
    let kTabBarHeight: CGFloat = 77
    let kTabBarItemWidth: CGFloat = UIScreen.main.bounds.width / 5.0 //5 = arrVC Count
    var viewDummy: UIView? = nil
    var btnRed: BtnRegular?
    var btnGreen: BtnRegular?
    var btnRegular: BtnRegular?
    let btnAnimationDuration = 0.5
    let disposeBag = DisposeBag()
    let viewModel: TabBarViewModel
    public weak var delegateBtn: MidButtonDelegate?
    
    //MARK: Initialization
    public init(viewModel: TabBarViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .white
        self.tabBar.backgroundColor = .white

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAppear()
    }
    
    
    
    func setupAppear(){
        
        if !self.viewModel.hasSetup{
            //Extra 5 padding on each side to make it bigger than the tab
            //5 items in the tabbar
            let greenBtnWidth = (UIScreen.main.bounds.width / 5) + 10
            let greenBtnXStart = (UIScreen.main.bounds.width / 5) * 2 - 5
            let greenBtnYStart = self.tabBar.frame.origin.y - 8
            let greenBtnHeight = self.tabBar.frame.size.height + 25
            
            let greenAndRedRect = CGRect(x: greenBtnXStart, y: greenBtnYStart, width: greenBtnWidth, height: greenBtnHeight)
            
            btnGreen = BtnRegular()
            btnGreen?.setupAsGreen()
            btnGreen?.frame = greenAndRedRect
            let tapRec = UITapGestureRecognizer(target: self, action: #selector(handleGreen))
            btnGreen?.isUserInteractionEnabled = true
            btnGreen?.addGestureRecognizer(tapRec)
            
            btnRed = BtnRegular()
            btnRed?.setupAsRed()
            btnRed?.frame = greenAndRedRect
            let tapRecRed = UITapGestureRecognizer(target: self, action: #selector(handleRed))
            btnRed?.isUserInteractionEnabled = true
            btnRed?.addGestureRecognizer(tapRecRed)

            
            let regularBtnWidth = (UIScreen.main.bounds.width / 5) + 4
            let regularBtnXStart = (UIScreen.main.bounds.width / 5) * 2 - 2
            let regularBtnYStart = self.tabBar.frame.origin.y
            let regularBtnHeight = self.tabBar.frame.size.height
            
            btnRegular = BtnRegular()
            btnRegular?.setupAsRegular()
            btnRegular?.frame = CGRect(x: regularBtnXStart, y: regularBtnYStart, width: regularBtnWidth, height: regularBtnHeight)
            let tapRecReg = UITapGestureRecognizer(target: self, action: #selector(handleRegular))
            btnRegular?.isUserInteractionEnabled = true
            btnRegular?.addGestureRecognizer(tapRecReg)

            let gradientHelper = GradientHelper()
            gradientHelper.addStartTripGradient(view: btnGreen!)
            gradientHelper.addEndTripGradient(view: btnRed!)
            
            self.view.addSubview(btnRegular!)
            self.view.addSubview(btnRed!)
            self.view.addSubview(btnGreen!)
            setupBindings()
            
            let numberOfItems = CGFloat((self.tabBar.items?.count)!)
            let tabBarItemSize = CGSize(width: self.tabBar.frame.width / numberOfItems, height: self.tabBar.frame.height)
            self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: Color.blue.value, size: tabBarItemSize).resizableImage(withCapInsets: .zero)
            tabBar.frame.size.width = self.view.frame.width + 4
            tabBar.frame.origin.x = -2
            tabBar.tintColor = .white
            self.viewModel.hasSetup = true
        }
    }
    
    func setupBindings(){
        
        _ = self.viewModel.isFishing.observeNext{ [weak self] value in
            if value{
                self?.showRed()
            }
            else{
                self?.showGreen()
            }
        }
    }
    
    @objc func handleGreen(){
        
        self.delegateBtn?.greenClicked()
    }
    
    @objc func handleRed(){

        self.delegateBtn?.redClicked()
    }
    
    @objc func handleRegular(){
        self.delegateBtn?.regularClicked()
    }
    
    func showGreen(){
        
        self.btnGreen?.alpha = 1
        self.btnRegular?.alpha = 0
        self.btnRed?.alpha = 0
        self.btnRegular?.isHidden = true
        self.btnRed?.isHidden = true
        self.btnGreen?.isHidden = false
    }
    
    func showRed(){
        self.btnGreen?.alpha = 0
        self.btnRegular?.alpha = 0
        self.btnRed?.alpha = 1
        self.btnRegular?.isHidden = true
        self.btnRed?.isHidden = false
        self.btnGreen?.isHidden = true
    }
    
    func showRegular(){
        self.btnGreen?.alpha = 0
        self.btnRegular?.alpha = 1
        self.btnRed?.alpha = 0
        self.btnRegular?.isHidden = false
        self.btnRed?.isHidden = true
        self.btnGreen?.isHidden = true
    }
    
    func showBoatError(){
        print("boat error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        if UIDevice.current.iPhoneX{
            sizeThatFits.height = 83
        }
        else{
            sizeThatFits.height = 77
        }
        return sizeThatFits
    }
}
