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

protocol AddAfliViewControllerDelegate:class{
    
    func didSelect(type: ControllerType, isFish: Bool)
    func goBack()
    func hideTabBar()
}

//This contorller is reused in two different screens
//The viewmodel is initialized with at type
//which is then used to set up the tableview + Bindings correctly

class AddAfliViewController: BaseViewController{

    //MARK: Properties
    public weak var delegate: AddAfliViewControllerDelegate?
    fileprivate let viewModel: AddAfliViewModel
    @IBOutlet weak var viewTop: Header!
    @IBOutlet weak var tableView: UITableView!
    let tableCellHeight: CGFloat = 194
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnSelect: Button!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var cConstraintBtnLeading: NSLayoutConstraint!
    
    
    //MARK: Init
    init(delegate: AddAfliViewControllerDelegate, viewModel: AddAfliViewModel){
        
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewCycle + styling
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.hideTabBar()
        }
        applyGradient()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureButtonState()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}

//MARK: - Setup
extension AddAfliViewController{
    
    func applyGradient(){
        
        let gradientHelper = GradientHelper()
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 2.0*cConstraintBtnLeading.constant, height: btnSave.bounds.size.height)
        
        gradientHelper.addGradientTo(view: btnSave, frame: frame, colors: [UIColor(red:0.71, green:0.93, blue:0.32, alpha:1).cgColor, UIColor(red:0.26, green:0.58, blue:0.13, alpha:1).cgColor], startPoint: CGPoint(x: 0.4, y: -0.29), endPoint: CGPoint(x: 0.4, y: 1.91), locations: [NSNumber(value: 0), NSNumber(value: 1)])
        
    }
    
    func setup(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 194
        let cellNib = UINib(nibName: "DragTableCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DragTableCell")
        let cellNib2 = UINib(nibName: "CheckboxCell", bundle: nil)
        tableView.register(cellNib2, forCellReuseIdentifier: "CheckboxCell")
        self.delegate?.hideTabBar()
        self.viewTop.delegate = self
        self.viewTop.setBackText(text: Texts.bakka)
        
        _ =  btnSelect.reactive.tap.observeNext{ [weak self] _ in
            
            self?.viewModel.changeSelectedState()
        }
        
        if self.viewModel.type == .animals{
            btnSave.isHidden = true
        }
        else{
            btnSave.isHidden = false
        }
        viewTop.updateAfli()
        
        btnSelect.widthAnchor.constraint(equalToConstant: 120).isActive = true
        btnSelect.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func style(){
        
        viewTop.setupForAddAfli()
        lblInfo.numberOfLines = 1
        lblInfo.minimumScaleFactor = 0.1
        lblInfo.adjustsFontSizeToFitWidth = true
        lblInfo.styleAsTableDescription()
        btnSelect.layer.cornerRadius = 5
        btnSelect.layer.borderWidth = 1
        btnSelect.titleLabel?.textAlignment = .center
        btnSelect.titleLabel?.font = .systemFont(ofSize: 12, weight: .black)
        btnSelect.setTitleColor(Color.blue.value, for: .normal)
        btnSelect.layer.borderColor = Color.blue.value.cgColor
        
        if self.viewModel.type == .time{
            self.lblInfo.font = Fonts.System.bold.of(size: 18)
            btnSave.isHidden = false
        }
        else{
            btnSelect.isHidden = true
            btnSave.isHidden = true
            lblInfo.textAlignment = .center
        }
        
        btnSave.styleAsSave()
        btnSave.setTitle("Áfram", for: .normal)
    }
    
    
}

//MARK: - Bindings
extension AddAfliViewController{
    
    
    //MARK: Bindings
    func setupBindings(){
        
        _ = btnSave.reactive.tap.observeNext{
            
            print("tapped")
            //We dont want the user to save a catch to 0-pulls
            guard self.viewModel.arrPullsToLog.value.count > 0 else{
                return
            }
            self.viewModel.savePullsToLogTo()
            self.delegate?.didSelect(type: self.viewModel.type, isFish: false)
        }
        
        _ = self.viewModel.title.observeNext{ value in
            
            self.viewTop.setTitle(title: value)
        }
        self.viewModel.descritpion.bind(to: lblInfo)
        
        _ = self.viewModel.btnIsSelected.observeNext{ [weak self] value in
            self?.viewModel.changeTo(value: value)
        }
        
        _ = self.viewModel.btnTitle.observeNext{ [weak self] value in
            
            self?.btnSave.setTitle(value, for: .normal)
        }
        configureButtonState()
        
    }
    
    func configureButtonState(){
        
        _ = self.viewModel.arrPullsToLog.observeNext{ [weak self] value in
            guard let self = self else { return }
            
            let isAllSelected = self.viewModel.arrData.value.count == value.count
                
            self.btnSelect.title = isAllSelected ? "HREINSA VAL" : "VELJA ALLT"
            
            if value.count > 0{
                UIView.animate(withDuration: 0.20, animations: {
                    self.btnSave.alpha = 1
                })
            }
            else{
                UIView.animate(withDuration: 0.20, animations: {
                    self.btnSave.alpha = 0
                })
            }
        }
    }
}

//MARK: - TableView
extension AddAfliViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.viewModel.type == .animals{
            
            var isFish = false
            if indexPath.row == 0{
                isFish = true
            }
            self.delegate?.didSelect(type: self.viewModel.type, isFish: isFish)
        }
        
        if self.viewModel.type == .time{

            if !self.viewModel.btnIsSelected.value{
                self.viewModel.didSelectAtIndexPath(indexPath.row)
                self.delegate?.didSelect(type: self.viewModel.type, isFish: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch self.viewModel.type {
        case .animals:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DragTableCell") as! DragTableCell
            if indexPath.row == 0{
                cell.applyImageForType(type: .fish)
            }
            if indexPath.row == 1{
                cell.applyImageForType(type: .mammalsAndBirds)
            }
            cell.setup()
            return cell
        case .time:
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CheckboxCell") as! CheckboxCell
            let cellVM = self.viewModel.arrData.value[indexPath.row]
            cell.setupWithViewModel(cellVM)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.getNumberOfCells()
    }
}

//MARK: - Delegate
extension AddAfliViewController: HeaderDelegate{
    
    func goBack() {
        self.delegate?.goBack()
    }
    
    func add(){
        
    }
}
