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

protocol LoggedAfliCellDelegate: class{
    
    func didTapChange(catchId: String)
}

class LoggedAfliCell: UITableViewCell {

    @IBOutlet weak var imgFish: UIImageView!
    @IBOutlet weak var lblFishName: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var viewSep: UIView!
    @IBOutlet weak var lblIsUndirmal: UILabel!
    @IBOutlet weak var lblLogDate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    public weak var delegate: LoggedAfliCellDelegate?
    var catchId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(fishName: String, weight: Double, isUndirmal: Bool, logDate: String, type: Int, catchId: String, delegate: AfliViewController){
        
        lblWeight.text = type == 0 ? "\(weight) kg" : "\(Int(weight)) stk"
        lblFishName.text = fishName
        lblLogDate.text = "Skráð: " + logDate
        self.delegate = delegate
        self.catchId = catchId
        if type == 0{
            imgFish.image = Asset.fish.image
        }
        else{
            imgFish.image = Asset.mammal.image
        }
        
        if isUndirmal{
            lblIsUndirmal.text =  "Undirmál: Já"
        }
        else{
            lblIsUndirmal.text = "Undirmál: Nei"
        }
        
        styleCell()
    }
    
    func styleCell(){
        
        lblFishName.styleAsLoggedFish()
        lblWeight.styleAsLoggedWeight()
        lblIsUndirmal.textColor = Color.blue.value
        lblIsUndirmal.font = Fonts.System.regular.of(size: 18)
        lblLogDate.font = Fonts.System.regular.of(size: 13)
        lblLogDate.textColor = Color.blue.value
        viewSep.backgroundColor = Color.cellSeperator.value
        btnChange.layer.cornerRadius = btnChange.frame.size.height/2.0
        btnChange.layer.masksToBounds = true
        btnChange.setTitle("BREYTA", for: .normal)
        btnChange.setTitleColor(Color.white.value, for: .normal)
        btnChange.titleLabel?.font = Fonts.System.bold.of(size: 13)
        let gradientHelper = GradientHelper()
        gradientHelper.addGradientTo(view: btnChange, frame: btnChange.bounds, colors: [UIColor(red:0.25, green:0.46, blue:0.75, alpha:1).cgColor, UIColor(red:0.09, green:0.27, blue:0.51, alpha:1).cgColor], startPoint: CGPoint(x: 0.36, y: -0.43), endPoint: CGPoint(x: 0.56, y: 1.31), locations: [NSNumber(value:0), NSNumber(value: 1)])
    }
    
    @IBAction func editClicked(_ sender: Any) {
        
        self.delegate?.didTapChange(catchId: self.catchId)
    }
    
}
