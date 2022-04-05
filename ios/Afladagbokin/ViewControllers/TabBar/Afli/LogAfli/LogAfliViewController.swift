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

protocol LogAfliViewControllerDelegate:class{
    func goBack()
    func didFinishLogging(animal: AnimalProtocol, isReleased: Bool, isSmallFish: Bool, isGutted: Bool, weight: Double, type: Int)
    func hideTabBar()
}

class LogAfliViewController: BaseViewController {

    //MARK: Properties
    fileprivate weak var delegate: LogAfliViewControllerDelegate?
    @IBOutlet weak var viewHeader: Header!
    @IBOutlet weak var tableView: UITableView!
    let viewModel: LogAfliViewModel
    let rowHeightAnimals: CGFloat = 60
    let rowHeightWeight: CGFloat = 148
    let rowHeightLogging: CGFloat = 140
    @IBOutlet weak var btnSave: UIButton!
    let originalBtnConstant: CGFloat = 27
    @IBOutlet weak var cBtnToBot: NSLayoutConstraint!
    @IBOutlet weak var cTblToHeader: NSLayoutConstraint!
    @IBOutlet weak var cTblToHeaderWithSearch: NSLayoutConstraint!
    var layoutConstraintTblvToHeader: NSLayoutConstraint?
    @IBOutlet weak var cSearchHeight: NSLayoutConstraint!
    let animationDuration = 0.4
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: Init
    init(delegate: LogAfliViewControllerDelegate, viewModel: LogAfliViewModel){
        self.delegate = delegate
        self.viewModel = viewModel
        self.viewModel.setupBonding()
        self.viewModel.fillData()
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let gradientHelper = GradientHelper()
        gradientHelper.addGradientTo(view: btnSave, frame: btnSave.frame, colors: [Color.greenGradientStart.value.cgColor, Color.greenGradientEnd.value.cgColor], startPoint: CGPoint(x: 0.4, y: -0.29), endPoint: CGPoint(x: 0.4, y: 1.91))
    }
}


//MARK: Setup + Stylings
extension LogAfliViewController{
    
    func style(){
        btnSave.styleAsSave()
        viewHeader.setupWithBackButtonOnly()
    }

    func setup(){
        setupTable()
        setupBindings()
        self.delegate?.hideTabBar()
        setupHeader()
        setupSearchbar()
    }
    
    func setupSearchbar(){
        searchBar.delegate = self
        self.searchBar.showsCancelButton = false
    }
    
    func setupTable(){
        
        let cellNib = UINib(nibName: "AnimalCell", bundle: nil)
        let cellNib2 = UINib(nibName: "LogWeightCell", bundle: nil)
        let cellNib3 = UINib(nibName: "ButtonCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AnimalCell")
        tableView.register(cellNib2, forCellReuseIdentifier: "LogWeightCell")
        tableView.register(cellNib3, forCellReuseIdentifier: "ButtonCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func setupHeader(){
        viewHeader.delegate = self
        viewHeader.setTitle(title: viewModel.title.value)
    }
    
    func setupBindings(){
        
        _ = self.viewModel.arrFilteredData.observeNext{ [weak self] value in
            guard let this = self else { return }
            this.tableView.reloadData()
        }
        
        _ = self.viewModel.selectedAnimalId.observeNext{ [weak self] value in
            
            guard let this = self else { return }
            
            if this.viewModel.checkSelectedAnimalId(animalId: value) == .nothingSelected{
                this.btnSave.isHidden = true
                this.cSearchHeight.constant = 56
                return
            }
            else{
                this.cSearchHeight.constant = 0
            }
            this.view.setNeedsUpdateConstraints()
            
            UIView.animate(withDuration: (this.animationDuration), animations: {
                this.view.layoutIfNeeded()
            })
        }
        
        _ = self.viewModel.loggedAnimal.observeNext{ [weak self] value in
            
            guard let this = self else { return }
            if value != nil{
                UIView.animate(withDuration: this.animationDuration, animations: {
                    this.btnSave.isHidden = false
                })
            }
            else{
                UIView.animate(withDuration: this.animationDuration, animations: {
                    this.btnSave.isHidden = true
                })
            }
        }
        
        
        _ = self.viewModel.numberOfSections.observeNext{ [weak self] value in
            
            guard let this = self else { return }
            if value != 1 {
                this.view.endEditing(true)
                this.searchBar.text = ""
                this.searchBar.showsCancelButton = false
            }
        }
    }
}

//MARK: UserActions
extension LogAfliViewController{
    
    //MARK: General methods
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        guard let animal = self.viewModel.loggedAnimal.value else { return }
        
        if self.viewModel.isLuda.value{
            
            let isReleased = self.viewModel.arrBtnCellViewModels[0].isBtnSelected.value
            
            guard let weight = Double(self.viewModel.weightViewModel.animalWeight.value) else{
                self.delegate?.didFinishLogging(animal: animal, isReleased: isReleased, isSmallFish: false, isGutted: false, weight: 0, type: 0)
                return
            }
            self.delegate?.didFinishLogging(animal: animal, isReleased: isReleased, isSmallFish: false, isGutted: false, weight: weight, type: 0)
            AnimalProtocolHelper.addSelectedFishToDB(fishId: animal.id)
        }
        else{
            
            var isGutted = false
            var isUndirmal = false
            var type = 0
            if Session.manager.getIsLoggedAfliFish(){
                isGutted = self.viewModel.arrBtnCellViewModels[0].isBtnSelected.value
                isUndirmal = self.viewModel.arrBtnCellViewModels[1].isBtnSelected.value
                type = 0
                AnimalProtocolHelper.addSelectedFishToDB(fishId: animal.id)
            }
            else{
                type = 1
                AnimalProtocolHelper.addSelectedAnimalToDB(animalId: animal.id)
            }
            guard let weight = Double(self.viewModel.weightViewModel.animalWeight.value) else{
                self.delegate?.didFinishLogging(animal: animal, isReleased: false, isSmallFish: isUndirmal, isGutted: isGutted, weight: 0, type: type)
                return
            }
            self.delegate?.didFinishLogging(animal: animal, isReleased: false, isSmallFish: isUndirmal, isGutted: isGutted, weight: weight, type: type)
        }
        
    }
    
    @objc func reset(){
        viewModel.resetListItems()
        viewHeader.setupWithBackButtonOnly()
        viewModel.reset()
        UIView.transition(with: tableView,
                          duration: self.animationDuration,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LogAfliViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = viewModel.shouldShowCancelButtonForSearchText(searchText)
        self.viewModel.configureFilteredArrayBasedOnSearchText(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
}

//MARK: TableView
extension LogAfliViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard !viewModel.hasSelectedAnimalId() else { return }
        guard viewModel.shouldRespondToRowClick() else { return }
        guard viewModel.isLuda.value else{
            
            self.viewModel.selectedAnimalId.value = viewModel.arrFilteredData.value[indexPath.row].id
            self.viewModel.selectedAnimalName = viewModel.arrFilteredData.value[indexPath.row].speciesName
            UIView.transition(with: tableView, duration: self.animationDuration, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: { _ in
                tableView.setContentOffset(CGPoint.zero, animated: true)
            })
            return
        }
        
        self.viewModel.selectedAnimalId.value = viewModel.arrFilteredData.value[indexPath.row].id
        self.viewModel.selectedAnimalName = viewModel.arrFilteredData.value[indexPath.row].speciesName
        UIView.transition(with: tableView, duration: self.animationDuration, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: { _ in
            tableView.setContentOffset(CGPoint.zero, animated: true)
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AnimalCell") as! AnimalCell
            if let name = self.viewModel.selectedAnimalName{
                cell.setupWith(title: name, selectable: false)
            }
            else{
                cell.setupWith(title: self.viewModel.arrFilteredData.value[indexPath.row].speciesName, selectable: true)
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LogWeightCell") as! LogWeightCell
            cell.setup(viewModel: self.viewModel.weightViewModel)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == self.viewModel.numberOfSections.value - 1{
            return UITableViewCell()
        }
        else{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as! ButtonCell
            
            cell.setup(viewModel: self.viewModel.arrBtnCellViewModels[indexPath.section-2])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return rowHeightAnimals
        }
        if indexPath.section == 1{
            return rowHeightWeight
        }
        if indexPath.section == self.viewModel.numberOfSections.value - 1{
            return 70
        }
        else{
            return rowHeightLogging
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if viewModel.hasSelectedAnimalId() { return 1 }
        return self.viewModel.arrFilteredData.value.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return self.viewModel.numberOfSections.value
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension LogAfliViewController: HeaderDelegate{
    
    func goBack() {
        if self.viewModel.shouldPopScreen(){
            self.delegate?.goBack()
        }
        else{
            reset()
        }
    }
    
    func add(){}
}
