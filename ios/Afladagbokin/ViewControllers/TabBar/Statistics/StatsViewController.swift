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
import Lottie

protocol StatsViewControllerDelegate:class{
    func didSelectTrip(id: Int)
    func pop()
    func show()
    func hide()
    func didSelectDate(from: Date, to: Date)
}

class StatsViewController: BaseViewController{
    
    //MARK: Properties
    @IBOutlet weak var cViewHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: Header!
    let viewModel: StatisticsViewModel
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblLastTrip: UILabel!
    @IBOutlet weak var lblPastTrips: UILabel!
    @IBOutlet weak var lblTimabil: UILabel!
    var heightOffset: CGFloat = 0
    @IBOutlet weak var cLblContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    public weak var delegate: StatsViewControllerDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cPickerBot: NSLayoutConstraint!
    @IBOutlet weak var btnSelect: UIButton!
    var animationView: LOTAnimationView?
    
    //MARK: Init + Lifecycle
    init(viewModel: StatisticsViewModel, delegate: StatsViewControllerDelegate){
        self.viewModel = viewModel
        self.delegate = delegate
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
        setupLottie()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.activePage.value == 0{
            getStats()
        }
    }
    
    //MARK: Styling + setup
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
        animationView?.alpha = 0
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            // your code here
            UIView.animate(withDuration: 0.25, animations: {
                self.animationView?.alpha = 0
            })
        }
    }
    
    func style(){
        
        lblPastTrips.styleAsBoxLabelInActive()
        lblLastTrip.styleAsBoxLabelActive()
        lblTimabil.styleAsBoxLabelInActive()
        viewHeader.addGradientToHeader()
        self.view.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
    
    func setup(){
        
        self.collectionView.register(UINib(nibName: "StatsCell", bundle: nil), forCellWithReuseIdentifier: "StatsCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.alwaysBounceHorizontal = true
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        let tapRecLastTrip = UITapGestureRecognizer(target: self, action: #selector(activateLastTrip))
        let tapRecPastTrips = UITapGestureRecognizer(target: self, action: #selector(activatePastTrips))
        let tapRecPeriod = UITapGestureRecognizer(target: self, action: #selector(activatePeriod))
        lblTimabil.isUserInteractionEnabled = true
        lblPastTrips.isUserInteractionEnabled = true
        lblLastTrip.isUserInteractionEnabled = true
        lblTimabil.addGestureRecognizer(tapRecPeriod)
        lblPastTrips.addGestureRecognizer(tapRecPastTrips)
        lblLastTrip.addGestureRecognizer(tapRecLastTrip)
        if self.viewModel.type == .pushed{
            //Header setup
            viewHeader.setupWithBackButton(text: Texts.tolfraedi)
            viewHeader.delegate = self
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
        else{
            viewHeader.setupWithTextOnly()
        }
        datePicker.datePickerMode = .date
    }
    
    @IBAction func btnSelectPressed(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        if self.viewModel.isFromDateActive.value{
            self.viewModel.strFromDate.value = dateFormatter.string(from: (self.datePicker.date))
            self.viewModel.fromDate.value = (self.datePicker.date)
            self.viewModel.isFromDateActive.value = false
            self.hidePicker()
        }
        else{
            self.viewModel.strToDate.value = dateFormatter.string(from: (self.datePicker.date))
            print(dateFormatter.string(from: (self.datePicker.date)))
            self.viewModel.toDate.value = (self.datePicker.date)
            self.hidePicker()
        }
    }
    
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func setupBindings(){
        
        _ = self.viewModel.activePage.observeNext{ [weak self] value in
            if value == 0{
                self?.lblLastTrip.styleAsBoxLabelActive()
                self?.lblPastTrips.styleAsBoxLabelInActive()
                self?.lblTimabil.styleAsBoxLabelInActive()
                self?.hidePicker()
                guard let count = self?.viewModel.tourList.value.count else{
                    return
                }
            }
            else if value == 1{
                self?.lblLastTrip.styleAsBoxLabelInActive()
                self?.lblPastTrips.styleAsBoxLabelActive()
                self?.lblTimabil.styleAsBoxLabelInActive()
                guard let count = self?.viewModel.tourList.value.count else{
                    return
                }
                self?.hidePicker()
            }
            else if value == 2{
                self?.lblLastTrip.styleAsBoxLabelInActive()
                self?.lblPastTrips.styleAsBoxLabelInActive()
                self?.lblTimabil.styleAsBoxLabelActive()

            }
        }
        
        _ = self.viewModel.statsModel.observeNext{ _ in
            
            self.collectionView.reloadData()
        }
    }
    
    //MARK: User methods
    
    @objc func activateLastTrip(){
        self.viewModel.setActivePage(activePage: 0)
        let nextItem: IndexPath = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
    }
    
    @objc func activatePastTrips(){
        self.viewModel.setActivePage(activePage: 1)
        let nextItem: IndexPath = IndexPath(item: 1, section: 0)
        self.collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
    }
    
    @objc func activatePeriod(){
        self.viewModel.setActivePage(activePage: 2)
        let nextItem: IndexPath = IndexPath(item: 2, section: 0)
        self.collectionView.scrollToItem(at: nextItem, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func btnBackPushed(_ sender: Any) {
        self.delegate?.pop()
    }
    
    //MARK: Networking
    func getStats(){
        
        self.showLottie()
        self.viewModel.getStats{ [weak self] result in
            self?.hideLottie()
            if result.code == .ok{
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                    guard let tourList = result.model?.historyList else {
                        print("ERROR - fails silently")
                        return
                    }
                    
                    self?.viewModel.tourList.value = tourList
                    if tourList.count > 0{
                        self?.viewModel.newestTour.value = tourList[0]
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: CollectionView

extension StatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        print("visible path: " + String(visibleIndexPath.row))
        self.viewModel.setActivePage(activePage: visibleIndexPath.row)
        if self.viewModel.activePage.value == 0{
            getStats()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = self.viewModel.getCollectionviewHeight(screenHeight: UIScreen.main.bounds.height, headerHeight: viewHeader.bounds.size.height, containerHeight: viewContainer.frame.size.height)
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.viewModel.getNumberOfItemsForCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //indexPathRow = 0 -> Síðasta ferð
        //indexPathRow = 1 -> Fyrri ferðir
        //IndexPathRow = 2 -> Tímabil
        if self.viewModel.type == .standard{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCell", for: indexPath) as! StatsCell
            cell.delegate = self
            if indexPath.row == 0{
                cell.setupWith(type: .lastTrip, heightOffset: heightOffset, arrTrips: self.viewModel.tourList.value, tourStatsModel: self.viewModel.statsModel.value, fromDate: self.viewModel.strFromDate, toDate: self.viewModel.strToDate)
            }
            if indexPath.row == 1{
                cell.setupWith(type: .pastTrips, heightOffset: heightOffset, arrTrips: self.viewModel.tourList.value, tourStatsModel: self.viewModel.statsModel.value, fromDate: self.viewModel.strFromDate, toDate: self.viewModel.strToDate)
            }
            if indexPath.row == 2{
                cell.setupWith(type: .period, heightOffset: heightOffset, arrTrips: self.viewModel.tourList.value, tourStatsModel: self.viewModel.statsModel.value, fromDate: self.viewModel.strFromDate, toDate: self.viewModel.strToDate)
                cell.dateDelegate = self
            }
            
            return cell
        }
        else if self.viewModel.type == .pushed{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCell", for: indexPath) as! StatsCell
            cell.setupWith(type: .lastTrip, heightOffset: heightOffset, arrTrips: self.viewModel.tourList.value, tourStatsModel: self.viewModel.statsModel.value, fromDate: self.viewModel.strFromDate, toDate: self.viewModel.strToDate)
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

extension StatsViewController: StatsCellDelegate{
    
    func didSelectTrip(id: Int) {
        if self.viewModel.activePage.value == 1{
            self.delegate?.didSelectTrip(id: id)
        }
    }
}

extension StatsViewController: StatsCellDateDelegate{
    
    
    func showPicker(){
        
        cPickerBot.constant = 0
        
        if viewModel.isFromDateActive.value{
            datePicker.setDate(viewModel.fromDate.value, animated: false)
        }
        else{
            datePicker.setDate(viewModel.toDate.value, animated: false)
        }
        
        self.delegate?.hide()
    }
    
    func hidePicker(){
        cPickerBot.constant = -300
        self.delegate?.show()
    }
    
    func didTapDate(isFromDate: Bool) {
        
        self.viewModel.isFromDateActive.value = isFromDate
        self.showPicker()
    }
    
    func didSelectDate() {
        
        //Dont take them to the next screen unless they have inputted data
        if self.viewModel.fromDate.value.isSameWeekAsDate(self.viewModel.toDate.value){
            
            let alert = UIAlertController(title: "Villa", message: "'Frá' dagsetning má ekki vera sú sama og 'Til' dagsetning", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if self.viewModel.fromDate.value.isLaterThanDate(self.viewModel.toDate.value){
            
            let alert = UIAlertController(title: "Villa", message: "'Frá' dagsetning verður að vera á undan 'Til' dagsetningar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.delegate?.didSelectDate(from: self.viewModel.fromDate.value, to: self.viewModel.toDate.value)
    }
}

extension StatsViewController: HeaderDelegate{
    
    func goBack() {
        self.delegate?.pop()
    }
    
    func add() {
        
    }
}
