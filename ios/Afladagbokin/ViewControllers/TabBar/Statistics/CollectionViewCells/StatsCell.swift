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

protocol StatsCellDelegate:class {
    
    func didSelectTrip(id: Int)
}

protocol StatsCellDateDelegate:class{
    
    func didTapDate(isFromDate: Bool)
    func didSelectDate()
}

enum CollectionType{
    case lastTrip
    case pastTrips
    case period
}


class StatsCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    var type: CollectionType? = nil
    //LastTrip
    var heightOffset: CGFloat = 0
    
    var arrTrips = Observable<[TourModel]>([])
    let statsStaticHeight: CGFloat = 210
    let colorLineHeight: CGFloat = 30
    let speciesHeight: CGFloat = 40
    let pastTripHeight: CGFloat = 96
    let periodHeight: CGFloat = 95
    let whiteSpaceHeight: CGFloat = 16
    public weak var delegate: StatsCellDelegate?
    public weak var dateDelegate: StatsCellDateDelegate?
    let btnCellHeight: CGFloat = 115
    var tourStatsModel: TourStatsModel?
    var arrSpecies = Observable<[FishSpeciesCatch]>([])
    var arrOtherSpecies = Observable<[AnimalsSpeciesCatch]>([])
    var strFromDate = Observable<String>("")
    var strToDate = Observable<String>("")
    
    //PastTrips
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(type: CollectionType, heightOffset: CGFloat, arrTrips:[TourModel], tourStatsModel: TourStatsModel?, fromDate: Observable<String>, toDate: Observable<String>){
        
        setupBindings()
        
        self.type = type
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        tableView.backgroundColor = .white
        self.arrTrips.value = arrTrips
        self.tourStatsModel = tourStatsModel
        if let arrSpecies = self.tourStatsModel?.fishSpeciesList{
            self.arrSpecies.value = arrSpecies
        }
        if let arrOtherSpecies = self.tourStatsModel?.otherSpeciesList{
            self.arrOtherSpecies.value = arrOtherSpecies
        }
        self.strFromDate = fromDate
        self.strToDate = toDate
        
        switch type {
        case .lastTrip:
            let cellNib = UINib(nibName: "LastTripCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "LastTripCell")
            let cellNib2 = UINib(nibName: "StatsSpeciesCell", bundle: nil)
            tableView.register(cellNib2, forCellReuseIdentifier: "StatsSpeciesCell")
            let cellNib3 = UINib(nibName: "ColorLineCell", bundle: nil)
            tableView.register(cellNib3, forCellReuseIdentifier: "ColorLineCell")
            let cellNib4 = UINib(nibName: "EmptyCell", bundle: nil)
            tableView.register(cellNib4, forCellReuseIdentifier: "EmptyCell")
        case .pastTrips:
            
            let cellNib = UINib(nibName: "TripCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "TripCell")
            let cellNib2 = UINib(nibName: "EmptyCell", bundle: nil)
            tableView.register(cellNib2, forCellReuseIdentifier: "EmptyCell")
        case .period:
            let cellNib = UINib(nibName: "DateCell", bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "DateCell")
            let cellNib2 = UINib(nibName: "DateBtnCell", bundle: nil)
            tableView.register(cellNib2, forCellReuseIdentifier: "DateBtnCell")
        }
    }
    
    func setupBindings(){
        
        _ = self.arrSpecies.observeNext{ [weak self] _ in
            self?.tableView.reloadData()
        }
        _ = self.arrOtherSpecies.observeNext{ [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension StatsCell: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == .lastTrip{
            
            switch StatCellHelper.getCellType(indexPath: indexPath, model: self.tourStatsModel, arrSpecies: arrSpecies.value, arrOtherSpecies: arrOtherSpecies.value){
                
            case .forLastTripCell:
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "LastTripCell") as! LastTripCell
                if let model = self.tourStatsModel{
                    cell.setupWith(harbor: model.landingPort, strDate: model.landingDate, total: String(model.catchSum), undir: String(model.smallCatchSum), species: model.fishSpeciesList.count, logAmount: model.totalPulls)
                    cell.selectionStyle = .none
                    return cell
                }
            case .forEmptyCell:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                return cell
            case .forColorLine:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ColorLineCell") as! ColorLineCell
                if let model = self.tourStatsModel{
                    cell.setup(model: model)
                    return cell
                }
            case .forStatsSpeciesOther:
                let otherSpecies = arrOtherSpecies.value[indexPath.row-arrSpecies.value.count-2]
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "StatsSpeciesCell") as! StatsSpeciesCell
                cell.setupWith(speciesName: otherSpecies.otherSpecies.speciesName, count: String(otherSpecies.count))
                cell.selectionStyle = .none
                return cell
            case .forStatsSpeciesFish:
                let species = arrSpecies.value[indexPath.row-2]
                
                let str = getCellStringForSpecies(species)
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "StatsSpeciesCell") as! StatsSpeciesCell
                
                let weight = species.weight
                let color = species.colorCode
                cell.setupWith(species: str, amount: String(weight), strColor: color)
                
                cell.selectionStyle = .none
                return cell
            }
        }
        
        if type == .pastTrips{
            
            switch StatCellHelper.getPastTripType(indexPath: indexPath, model: self.tourStatsModel){
                
            case .forDefaultCell:
                return UITableViewCell()
            case .forTripCell:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "TripCell") as! TripCell
                let trip = arrTrips.value[indexPath.row-1] //Fake white cell at the top
                cell.setupWith(date: trip.dateLanded, name: trip.landingPort, weight: String(trip.weight))
                cell.selectionStyle = .none
                return cell
            case .forEmptyCell:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! EmptyCell
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                return cell
            }
        }
        
        if type == .period{
            
            switch StatCellHelper.getPeriodCellType(indexPath: indexPath){
                
            case .forClearCell:
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                return cell
            case .forDateCellFrom:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setupWithType(type: .from, strDate: self.strFromDate)
                cell.delegate = self
                return cell
            case .forDateCellTo:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setupWithType(type: .to, strDate: self.strToDate)
                cell.delegate = self
                return cell
            case .forDateBtnCell:
                let btnCell = self.tableView.dequeueReusableCell(withIdentifier: "DateBtnCell") as! DateBtnCell
                btnCell.setup()
                btnCell.delegate = self
                return btnCell
            }
            
        }
        let tableCell = UITableViewCell()
        tableCell.selectionStyle = .none
        return tableCell
    }
    
    fileprivate func getCellStringForSpecies(_ species: FishSpeciesCatch) -> String {
        let cellString = species.fishSpecies?.speciesName ?? ""
        
        if species.smallFish && species.gutted { return cellString + " (undirmál og slægður)" }
        if species.smallFish                   { return cellString + " (undirmál)"            }
        if species.gutted                      { return cellString + " (slægður)"             }
        
        return cellString
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == .lastTrip{
            if indexPath.row == 0{
                
                 if self.tourStatsModel != nil{
                    return statsStaticHeight
                }
                return 600
            }
            if indexPath.row == 1{
                return colorLineHeight
            }
            else{
                return speciesHeight
            }
        }
        if type == .pastTrips{
            
              if self.tourStatsModel != nil{
                if indexPath.row == 0{
                    return whiteSpaceHeight
                }
                return pastTripHeight
            }
             else{
                return 600
            }
        }
        if type == .period{
            if indexPath.row == 0{
                return whiteSpaceHeight
            }
            if indexPath.row == 1 || indexPath.row == 2{
                return periodHeight
            }
            return btnCellHeight
            
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == .lastTrip{
            //Static cell on top + color cell = 2
            
            if arrTrips.value.count > 0{
                return 2 + arrSpecies.value.count + arrOtherSpecies.value.count
            }
            else{
                //Empty cell
                return 1
            }
        }
        if type == .pastTrips{
            
            if self.tourStatsModel != nil{
                return arrTrips.value.count + 1
            }
            else{
                return 1
            }
        }
        if type == .period{
            return 4 //From + To + spaceing top
        }
        return 1
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == .period{
            if indexPath.row == 1{
                
                self.dateDelegate?.didTapDate(isFromDate: true)
            }
            if indexPath.row == 2{
                self.dateDelegate?.didTapDate(isFromDate: false)
                print("to")
            }
            return
        }
        if type == .pastTrips{
            //Here we check if we can access this value
            //And the delegate takes care of wether or not to act on the tablecell click
            //because this class doesn't know which page we are on
            if self.tourStatsModel != nil{
                if indexPath.row - 1 < arrTrips.value.count{
                    self.delegate?.didSelectTrip(id: arrTrips.value[indexPath.row-1].id)
                }
            }
        }
    }
}

extension StatsCell: DateCellDelegate{
    
    func didTapDate(isFromDate: Bool) {
        self.dateDelegate?.didTapDate(isFromDate: isFromDate)
    }
}

extension StatsCell: DateBtnCellDelegate{
    
    func didSelectDate() {
        
        self.dateDelegate?.didSelectDate()
    }
}


