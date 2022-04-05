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
import StokkurUtls

protocol AfliViewControllerDelegate:class{
    
    func addAfli()
    func showTab()
    func editAfli(catchToEdit: Catch)
}

class AfliViewController: BaseViewController{

    //MARK: Properties
    public weak var delegate: AfliViewControllerDelegate?

    @IBOutlet weak var viewHead: Header!
    
    @IBOutlet weak var btnBigAdd: UIButton!
    @IBOutlet weak var lblSkra: UILabel!
    @IBOutlet weak var lblClickHere: UILabel!
    @IBOutlet weak var cBookToTopBar: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: Button!
    let viewModel: AfliViewModel
    
    //MARK: Init 
    init(delegate: AfliViewControllerDelegate){

        self.delegate = delegate
        self.viewModel = AfliViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewCycle and styling
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.showTab()
        DispatchQueue.main.after(when: 0.15) {
            self.viewModel.fillData()
            if self.viewModel.arrData.value.isEmpty{
                self.tableView.isHidden = true
                self.btnAdd.isHidden = true
            }
            else{
                self.tableView.isHidden = false
                self.btnAdd.isHidden = false
            }
            self.tableView.reloadData()
        }
    }
    
    func setup(){
        
        lblSkra.text = Texts.notLogged
        lblClickHere.text = Texts.clickHere
        self.delegate?.showTab()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "LoggedAfliCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LoggedAfliCell")
        viewHead.setupWithTextOnly()
        viewHead.setTitle(title: "Afladagbók")
        viewHead.delegate = self
        
        btnAdd.action = { [weak self] in
            self?.delegate?.addAfli()
        }
    }
    
    func style(){
        lblSkra.textColor = Color.lightGrayText.value
        lblClickHere.textColor = Color.lightGrayText.value
        
        btnAdd.title = "Bæta við"
        btnAdd.tintColor = UIColor.white
        btnAdd.backgroundColor = Color.blueButtonGradientEnd.value
//
        btnAdd.layer.cornerRadius = 10
//        btnAdd.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
//        btnAdd.layer.borderWidth = 2
        btnAdd.heightAnchor.constraint(equalToConstant: 67).isActive = true
        
        lblSkra.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        if Utls.screenType() == .iPhone5ScreenSize{
            cBookToTopBar.constant = 100
        }
    }
    
    //MARK: UserActions
    @IBAction func btnAddClicked(_ sender: Any) {
        self.delegate?.addAfli()
    }
    
    @IBAction func btnBigAddClicked(_ sender: Any) {
        self.delegate?.addAfli()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AfliViewController: HeaderDelegate{
    
    func goBack() {
        
    }
    
    func add() {
        self.delegate?.addAfli()
    }
}

extension AfliViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoggedAfliCell") as! LoggedAfliCell
        
        let aCatch = self.viewModel.arrData.value[indexPath.row]
        let catchName = Session.manager.getNameFromIDAndType(id: aCatch.speciesId, type: aCatch.type)
        let pullIdOfCatch = aCatch.pullId
        let logDate = self.viewModel.getPullLogDateFromCatchPullId( pullIdOfCatch!)
        cell.setupWith(fishName: catchName, weight: aCatch.weight, isUndirmal: aCatch.smallFish, logDate: logDate, type: aCatch.type, catchId: aCatch.id, delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 135
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrData.value.count
    }
}

extension AfliViewController: LoggedAfliCellDelegate{
    
    func didTapChange(catchId: String) {
        
        if let _catch = viewModel.arrData.value.first(where: { $0.id == catchId }) {
            let pulls = Session.manager.getPulls()
            let catchAttachedPulls = pulls.filter { $0.id == _catch.pullId }
            
            Session.manager.saveSelectedPullsToLogCatch(catchAttachedPulls)
            self.delegate?.editAfli(catchToEdit: _catch)
        }
        
        
        /*
        for aCatch in self.viewModel.arrData.value{
            
            if aCatch.id == catchId{
                
                //We need to tell the session manager if we're editing one pull or many pulls
                let arrPulls = Session.manager.getPulls()
                var catchAttachedPulls: [Pull] = []
                for pull in arrPulls{
                    for someCatch in pull.catches{
                        if aCatch.id == someCatch.id{
                            catchAttachedPulls.append(pull)
                        }
                    }
                }
                Session.manager.saveSelectedPullsToLogCatch(catchAttachedPulls)
                self.delegate?.editAfli(catchToEdit: aCatch)
                break
            }
        }
         */
    }
}
