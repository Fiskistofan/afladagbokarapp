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

class LastTripCell: UITableViewCell {

    
    @IBOutlet weak var lblHarborStatic: UILabel!
    @IBOutlet weak var lblDateStatic: UILabel!
    @IBOutlet weak var lblTotalStatic: UILabel!
    @IBOutlet weak var lblSpeciesStatic: UILabel!
    @IBOutlet weak var lblLogStatic: UILabel!
    @IBOutlet weak var lblHarbor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSpecies: UILabel!
    @IBOutlet weak var lblLog: UILabel!
    @IBOutlet weak var viewSep: UIView!
    let arrSpecies = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        styleCell()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func setupWith(harbor: String, strDate: String, total: String, undir: String, species: Int, logAmount: Int){
        
        styleCell()
        self.lblHarbor.text = harbor
        self.lblDate.text = strDate
        self.lblTotal.text = total + " kg"
        self.lblSpecies.text = String(species)
        self.lblLog.text = String(logAmount)
    }
    
    func styleCell(){
        self.selectionStyle = .none
        self.lblHarbor.styleAsStats()
        self.lblDate.styleAsStats()
        self.lblTotal.styleAsStats()
        self.lblSpecies.styleAsStats()
        self.lblLog.styleAsStats()
        self.viewSep.backgroundColor = Color.statsSeperator.value
        self.lblHarborStatic.styleAsStatsStatic()
        self.lblDateStatic.styleAsStatsStatic()
        self.lblTotalStatic.styleAsStatsStatic()
        self.lblSpeciesStatic.styleAsStatsStatic()
        self.lblLogStatic.styleAsStatsStatic()
    }
}
