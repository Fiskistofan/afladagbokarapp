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

protocol BoatViewControllerDelegate:class{
    
    func didSelectBoat()
}

class BoatViewController: BaseViewController {

    @IBOutlet weak var viewHeader: Header!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cHeaderHeight: NSLayoutConstraint!
    var viewModel: BoatViewModel
    var arrBoats: [ShipsModel]
    
    public weak var delegate: BoatViewControllerDelegate?
    
    //MARK: Init + lifecycle
    init(viewModel: BoatViewModel){
        self.viewModel = viewModel
        self.arrBoats = Session.manager.getBoats()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        setup()

        // Do any additional setup after loading the view.
    }
    
    func style(){
        
    }
    
    func setup(){
        
        self.arrBoats = Session.manager.getBoats()
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "BoatCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "BoatCell")
        tableView.separatorStyle = .none
        viewHeader.setupWithTextOnly()
        viewHeader.setTitle(title: "Veldu bát")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BoatViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.viewModel.didSelectBoat(id: arrBoats[indexPath.row].id)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BoatCell") as! BoatCell
        var needsShadow = false
        if indexPath.row % 2 == 0{
            needsShadow = true
        }
        cell.setupWith(boatId: arrBoats[indexPath.row].id, boatName: arrBoats[indexPath.row].name, companyName: "", needsShadow: needsShadow)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBoats.count
    }
}

