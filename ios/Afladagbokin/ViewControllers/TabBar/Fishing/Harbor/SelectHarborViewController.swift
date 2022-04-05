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


protocol SelectHarborViewControllerDelegate: class{
    
    func didSelectHarborWith(harborId: Int)
    func popHarbor()
}

class SelectHarborViewController: BaseViewController {

    
    @IBOutlet weak var viewHeader: Header!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblHarbor: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    public weak var delegate: SelectHarborViewControllerDelegate?
    let viewModel: HarborViewModel
    @IBOutlet weak var harborHeader: UIView!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    let cellHeight:CGFloat = 80
    
    //MARK: Init + lifecycle
    init(viewModel: HarborViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupBindings()
        style()
        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        setupViewModel()
        setupHeader()
        setupContinueBtn()
        setupTable()
        setupSearchbar()
    }
    
    func setupContinueBtn(){
        
        _ = btnStart.reactive.tap.observeNext{
            self.delegate?.didSelectHarborWith(harborId: self.viewModel.selectedHarborId.value)
            if let sHarbor = self.viewModel.selectedHarbor{
                HarborManager.addSelectedHarborToDB(harbor: sHarbor)
            }
        }
    }
    
    func setupTable(){
        
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "HarborCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HarborCell")
        tableView.separatorStyle = .none
    }
    
    func setupSearchbar(){
        
        searchBar.delegate = self
        searchBar.showsCancelButton = false
    }
    
    func setupHeader(){
        
        viewHeader.setupWithBackButtonOnly()
        viewHeader.setTitle(title: "Löndunarhöfn")
        viewHeader.delegate = self
    }
    
    func setupViewModel(){
        
        viewModel.fillData()
    }
    
    func setupBindings(){
        
        _ = self.viewModel.selectedHarborName.observeNext{ name in
            self.lblHarbor.text = "Valin löndunarhöfn: " + name
        }
        
        _ = self.viewModel.filteredData.observeNext{ _ in
            self.tableView.reloadData()
        }
    }
    
    func style(){
        
        btnStart.styleAsSave()
        btnStart.setTitle("HEFJA VEIÐAR", for: .normal)
        lblHarbor.font = Fonts.System.regular.of(size: 19)
        lblHarbor.textColor = Color.blue.value
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SelectHarborViewController: UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectAtIndex(indexPath)
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HarborCell") as! HarborCell
        cell.setupWith(name: viewModel.filteredData.value[indexPath.row].portName)
        cell.removeGradient()
        if indexPath.row%2 == 0{
            cell.applyGradient(height: cellHeight)
        }
        else{
            cell.removeGradient()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredData.value.count
    }
}

extension SelectHarborViewController: HeaderDelegate{
    
    func goBack() {
        self.delegate?.popHarbor()
    }
    
    func add() {
        
    }
}

extension SelectHarborViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.showsCancelButton = searchText.isEmpty ? false : true
        
        viewModel.filteredData.value = searchText.isEmpty ? viewModel.arrData.value : viewModel.arrData.value.filter { (item: PortModel) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.portName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
    }
}
