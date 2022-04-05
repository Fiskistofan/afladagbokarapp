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

protocol MoreViewControllerDelegate:class{
    
    func logOut()
}

class MoreViewController: BaseViewController {

    //MARK: Properties
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblLogOut: UILabel!
    @IBOutlet weak var lblSignedIn: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblKt: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var viewShadow: UIView!
    let viewModel: MoreViewModel
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cTitleToTop: NSLayoutConstraint!
    let animationDuration: Double = 0.3
    public weak var delegate: MoreViewControllerDelegate?
    
    //MARK: Init + lifecycle
    init(viewModel: MoreViewModel){
        self.viewModel = viewModel
         super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setup()
        setupBindings()

    }
    
    //MARK: Styling + setup
    
    func addGradientToButton(){
        
        btnLogOut.backgroundColor = Color.redGradientButtonMid.value
        let gradient = CAGradientLayer()
        gradient.frame = btnLogOut.bounds
        gradient.colors = [Color.redGradientButtonStart.value.cgColor, Color.redGradientButtonMid.value.cgColor, Color.redGradientButtonEnd.value.cgColor]
        gradient.locations = [0, 0.027350556, 1]
        gradient.startPoint = CGPoint(x: 0.53, y: -0.72)
        gradient.endPoint = CGPoint(x: 0.59, y: 1.45)
        gradient.cornerRadius = 5
        btnLogOut.layer.masksToBounds = true
        btnLogOut.layer.insertSublayer(gradient, at: 0)
        
        viewShadow.styleForGradientButton()
    }
    
    func style(){
        
        viewHeader.backgroundColor = Color.blueHeader.value
        lblTitle.styleAsTitle()
        lblAbout.styleAsBoxLabelActive()
        lblLogOut.styleAsBoxLabelInActive()
        lblSignedIn.textColor = Color.lightGrayText.value
        lblName.textColor = Color.blue.value
        lblKt.textColor = Color.blue.value
        lblSignedIn.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lblName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        lblKt.font = UIFont.systemFont(ofSize: 18, weight: .light)
        btnLogOut.setTitleColor(Color.white.value, for: .normal)
        btnLogOut.layer.cornerRadius = 5
        lblText.lineBreakMode = .byWordWrapping
        lblText.numberOfLines = 0
        lblText.textColor = Color.lightGrayText.value
        lblVersion.textColor = Color.lightGrayText.value
        lblVersion.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        viewHeader.addGradientToHeader()
        addGradientToButton()
        if UIDevice.current.iPhoneX{
            cTitleToTop.constant = 45
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    func setup(){
        
        //Hide the stuff that is in the second tab
        self.hideLogout()
        
        lblTitle.text = Texts.moreTitle
        lblSignedIn.text = Texts.loggedInAs
        lblKt.text = Session.manager.getUserSSN()
        lblName.text = Session.manager.getUserName()
        
        let tapRecAbout = UITapGestureRecognizer(target: self, action: #selector(showAbout))
        let tapRecLogOut = UITapGestureRecognizer(target: self, action: #selector(showLogout))
        lblAbout.isUserInteractionEnabled = true
        lblLogOut.isUserInteractionEnabled = true
        lblAbout.addGestureRecognizer(tapRecAbout)
        lblLogOut.addGestureRecognizer(tapRecLogOut)

        lblText.text = Texts.moreDescription
        lblText.textAlignment = .center
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            lblVersion.text = "\(version) [\(build)]"
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showLogout))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(showAbout))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func setupBindings(){
        
        _ = self.viewModel.isAboutActive.observeNext{ value in
            
            if value{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.hideLogout()
                })
                
            }
            else{
                UIView.animate(withDuration: self.animationDuration, animations: {
                    self.hideAbout()
                })
            }
        }
    }
    
    //MARK: General methods
    
    @objc func showAbout(){
        
        self.viewModel.isAboutActive.value = true
    }
    
    @objc func showLogout(){
        self.viewModel.isAboutActive.value = false
    }
    
    func hideAbout(){
        self.lblSignedIn.alpha = 1
        self.lblName.alpha = 1
        self.lblKt.alpha = 1
        self.btnLogOut.alpha = 1
        self.lblAbout.styleAsBoxLabelInActive()
        self.lblLogOut.styleAsBoxLabelActive()
        self.lblText.alpha = 0
        self.imgView.alpha = 0
        self.lblVersion.alpha = 0
    }
    
    func hideLogout(){
        self.lblSignedIn.alpha = 0
        self.lblName.alpha = 0
        self.lblKt.alpha = 0
        self.btnLogOut.alpha = 0
        self.lblAbout.styleAsBoxLabelActive()
        self.lblLogOut.styleAsBoxLabelInActive()
        self.lblText.alpha = 1
        self.imgView.alpha = 1
        self.lblVersion.alpha = 1
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let alert = UIAlertController(title: "Útskráning", message: "Ertu viss um að þú viljir skrá þig út?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Skrá út", style: UIAlertActionStyle.default, handler: { action in
            
            self.delegate?.logOut()
        }))
        alert.addAction(UIAlertAction(title: "Hætta við", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
