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
import Lottie

protocol SingleStatsViewControllerDelegate: class{
    
    func pop()
}

class SingleStatViewController: UIViewController {
    

    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: Header!
    var viewModel: SingleStatsViewModel?
    public weak var delegate: SingleStatsViewControllerDelegate?
        var animationView: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLottie()
        setup()
        // Do any additional setup after loading the view.
    }
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // your code here
            UIView.animate(withDuration: 0.25, animations: {
                self.animationView?.alpha = 0
            })
        }
    }
    
    func setup(){
        
        tableView.delegate = self
        tableView.dataSource = self
        viewHeader.setupWithBackButtonOnly()
        viewHeader.delegate = self
        lblEmpty.isHidden = true
        let cellNib = UINib(nibName: "LastTripCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LastTripCell")
        let cellNib2 = UINib(nibName: "StatsSpeciesCell", bundle: nil)
        tableView.register(cellNib2, forCellReuseIdentifier: "StatsSpeciesCell")
        let cellNib3 = UINib(nibName: "ColorLineCell", bundle: nil)
        tableView.register(cellNib3, forCellReuseIdentifier: "ColorLineCell")
        tableView.separatorStyle = .none
        lblEmpty.font = Fonts.System.regular.of(size: 18)
        lblEmpty.textColor = Color.blue.value
        setupBindings()
        
        showLottie()
        
        let blockComplete = {
            
            print("hiding lottie")
            self.hideLottie()
        }
        
        viewModel?.getStatsForTour(id: (self.viewModel?.tourId)!, blockComplete: blockComplete)
    }
    
    func setupBindings(){
        
        _ = self.viewModel?.statsModel.observeNext{ [weak self] _ in
            
            if let landingDate = self?.viewModel?.statsModel.value?.landingDate{
                self?.viewHeader.setTitle(title: landingDate)
            }
            self?.tableView.reloadData()
        }
        
        
        _ = self.viewModel?.dateStatsModel.observeNext{ [weak self] _ in
            
            self?.viewHeader.setTitle(title: "Samantekt")
            self?.tableView.reloadData()
        }
        
        _ = self.viewModel?.shouldDisplayFailLbl.observeNext{ [weak self] value in
            
            self?.lblEmpty.isHidden = !value
            self?.tableView.isHidden = value
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SingleStatViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch SingleStatsViewModel.getCellTypeFor(indexPath: indexPath, statsModel: self.viewModel?.statsModel.value, statsModelDates: self.viewModel?.dateStatsModel.value){
            
        case .forLastTripCell:
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LastTripCell") as! LastTripCell
            if let model = self.viewModel?.statsModel.value{
                cell.setupWith(harbor: model.landingPort, strDate: model.landingDate, total: String(model.catchSum), undir: String(model.smallCatchSum), species: model.speciesCount, logAmount: model.totalPulls)
            }
            if let model = self.viewModel?.dateStatsModel.value{
                
                cell.setupWith(harbor: model.landingPort, strDate: model.landingDate, total: String(model.catchSum), undir: String(model.smallCatchSum), species: model.speciesCount, logAmount: model.totalPulls)
            }
            cell.selectionStyle = .none
            return cell
            
            
            
        case .forColorLineCell:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ColorLineCell") as! ColorLineCell
            
            if let model = self.viewModel?.statsModel.value{
                cell.setup(model: model)
            }
            if let myModel = self.viewModel?.dateStatsModel.value{
                cell.setup(dateModel: myModel)
            }
            cell.selectionStyle = .none
            return cell
            
            
            
        case .forStatsSpeciesCellOther:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "StatsSpeciesCell") as! StatsSpeciesCell
            if let model = self.viewModel?.statsModel.value{
                let otherSpecies = model.otherSpeciesList[indexPath.row-model.fishSpeciesList.count-2]
                cell.setupWith(speciesName: otherSpecies.otherSpecies.speciesName, count: String(otherSpecies.count))
                cell.selectionStyle = .none
                return cell
            }
            if let model = self.viewModel?.dateStatsModel.value{
                let otherSpecies = model.otherSpeciesList[indexPath.row-2-model.fishSpeciesList.count]
                cell.setupWith(speciesName: otherSpecies.otherSpecies.speciesName, count: String(otherSpecies.count))
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
            
            
            
        case .forStatsSpeciesCellFish:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "StatsSpeciesCell") as! StatsSpeciesCell
            if let model = self.viewModel?.statsModel.value{
                let species =  model.fishSpeciesList[indexPath.row-2]
                
                let color = species.colorCode
                let weight = species.weight
                let str = getCellStringForSpecies(species)
                
                cell.setupWith(species: str, amount: String(weight), strColor: color)
                cell.selectionStyle = .none
                return cell
            }
            
            if let model = self.viewModel?.dateStatsModel.value{
                let species =  model.fishSpeciesList[indexPath.row-2]
                
                let str = getCellStringForSpecies(species)
                let color = species.colorCode
                let weight =  species.weight
                
                cell.setupWith(species: str, amount: String(weight), strColor: color)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
            
            
        case .undefined:
            return UITableViewCell()
        }
    }
    
    fileprivate func getCellStringForSpecies(_ species: FishSpeciesCatch) -> String {
        let cellString = species.fishSpecies?.speciesName ?? ""
        
        if species.smallFish && species.gutted { return cellString + " (undirmál og slægður)" }
        if species.smallFish                   { return cellString + " (undirmál)"            }
        if species.gutted                      { return cellString + " (slægður)"             }
        
        return cellString
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 210
        }
        if indexPath.row == 1{
            return 30
        }
        else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let model = self.viewModel?.statsModel.value {
            let count = model.fishSpeciesList.count + model.otherSpeciesList.count
            return count + 2
        }
        
        if let dateModel = self.viewModel?.dateStatsModel.value {
            let count = dateModel.fishSpeciesList.count + dateModel.otherSpeciesList.count
            return count + 2
        }
        
        return 0
    }
}

extension SingleStatViewController: HeaderDelegate{
    
    func goBack() {
        self.delegate?.pop()
    }
    
    func add() {
        
    }
}

extension SingleStatViewController: StatsCellDateDelegate{
    func didSelectDate() {
       
    }
    
    func didTapDate(isFromDate: Bool) {
        
    }
}
