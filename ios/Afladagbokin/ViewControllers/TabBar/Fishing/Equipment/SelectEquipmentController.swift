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
import Bond
import ReactiveKit

protocol SelectEquipmentControllerDelegate:class{
    
    func didSelectEquipment(equipmentId: Int)
    func popHarbor()
}

extension SelectEquipmentController: HeaderDelegate{
    
    func add() {}
    
    func goBack() {
        self.delegate?.popHarbor()
    }
}

class SelectEquipmentController: UIViewController {

    
    @IBOutlet weak var viewHeader: Header!
    @IBOutlet weak var tableView: UITableView!
    public weak var delegate: SelectEquipmentControllerDelegate?
    let viewModel: EquipmentViewModel
    
    public init(){
        self.viewModel = EquipmentViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup(){
        
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "EquipmentCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "EquipmentCell")
        tableView.separatorStyle = .none
        viewHeader.setupWithBackButtonOnly()
        viewHeader.delegate = self
        viewHeader.setTitle(title: "Veldu veiðarfæri")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SelectEquipmentController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let id = Session.manager.getDefaultEquipmentTypeId()
        let id = viewModel.arrData[indexPath.row].id
        self.delegate?.didSelectEquipment(equipmentId: id)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "EquipmentCell") as! EquipmentCell
        
        let id = viewModel.arrData[indexPath.row].id
        
        switch id {
        case EquipmentType.skotuselsNet.rawValue: cell.setupAsSkotuselsNet()
        case EquipmentType.þorskfiskNet.rawValue: cell.setupAsTorskNet()
        case EquipmentType.grasleppuNet.rawValue: cell.setupAsGrasleppunet()
        case EquipmentType.raudmagaNet.rawValue: cell.setupAsRaudmaganet()
        case EquipmentType.lina.rawValue: cell.setupAsLina()
        case EquipmentType.landbeittLina.rawValue: cell.setupAsLandbeittLina()
        case EquipmentType.handfaeri.rawValue: cell.setupAsHandfaeri()
        case EquipmentType.linutrekt.rawValue: cell.setupAsLinutrekt()
        default:
            //Need case for unknown
            print("unknown")
            cell.setupAsSkotuselsNet()
        }
        
        if Session.manager.getSelectedEquipmentId() == id {
            cell.setupAsSelected()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrData.count
    }
}
