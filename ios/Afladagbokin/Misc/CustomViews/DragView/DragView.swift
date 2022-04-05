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


protocol DragViewDelegate: class {
    func dragViewDidSelectAnnotation(_ dragView: DragView, annotation: Toss)
}


class DragView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    weak var delegate: DragViewDelegate?
    var annotations: [Toss] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    init(frame: CGRect, annotations: [Toss]) {
        self.annotations = annotations
        
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("DragView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let cellNib = UINib(nibName: "DragInfoCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "DragInfoCell")
        
        style()
    }
    
    func setAnnotation(_ annotations: [Toss]) {
        self.annotations = annotations
    }
    
    func style() {
        //Set self
        self.layer.cornerRadius = 5
        
        //Set contentView
        self.contentView.layer.borderColor = Color.infoBorder.value.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = Color.infoBackground.value.withAlphaComponent(0.9)
        
        // Set tableView
        //self.tableView.backgroundView = nil
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        
        // Set title label
        lblTitle.textColor = Color.white.value
        lblTitle.font = Fonts.System.bold.of(size: 16)
        lblTitle.text = "Veldu veiðarfæri"
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     }
    
}


extension DragView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = annotations[indexPath.row]
        delegate?.dragViewDidSelectAnnotation(self, annotation: annotation)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "DragInfoCell") as? DragInfoCell
        
        if cell == nil {
            cell = DragInfoCell(style: .default, reuseIdentifier: "DragInfoCell")
        }
        
        let toss = annotations[indexPath.row]
        cell?.populateView(toss: toss)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annotations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
}
