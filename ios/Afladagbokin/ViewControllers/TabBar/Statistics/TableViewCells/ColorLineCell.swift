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

class ColorLineCell: UITableViewCell {

    var model: TourStatsModel? = nil
    var dateModel: TourStatsModelForDates? = nil
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewColor: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model: TourStatsModel){
        
        self.viewColor.layer.cornerRadius = self.viewColor.frame.size.height/2.0
        self.viewColor.backgroundColor = Color.blue.value
        self.model = model
        viewColor.clipsToBounds = true
        self.applyColor()
    }
    
    func setup(dateModel: TourStatsModelForDates){
        
        self.viewColor.layer.cornerRadius = self.viewColor.frame.size.height/2.0
        self.viewColor.backgroundColor = Color.blue.value
        self.dateModel = dateModel
        viewColor.clipsToBounds = true
        self.applyColor()
    }
    
    func applyColor(){
        
        let margins = constraintLeading.constant + constraintTrailing.constant
        
        var xStartingPoint: CGFloat = 0.0
        
        for view in viewColor.subviews{
            view.removeFromSuperview()
        }
        
        let list = self.model?.fishSpeciesList ?? self.dateModel?.fishSpeciesList ?? []
        let sum = self.model?.catchSum ?? self.dateModel?.catchSum ?? 0.0
        
        for specie in list{
            
            let proportionalWidth = CGFloat(CGFloat(specie.weight) / CGFloat(sum))
            let wholeScreenWidth = UIScreen.main.bounds.width
            let lineWidth = wholeScreenWidth - margins
            let width = proportionalWidth * lineWidth
            let viewForSpecie = UIView(frame: CGRect(x: xStartingPoint, y: 0.0, width: width, height: constraintHeight.constant))
            xStartingPoint = xStartingPoint + width
            let color =  UIColor(hexString: specie.colorCode).withAlphaComponent(1.0)
            viewForSpecie.backgroundColor = color
            viewColor.addSubview(viewForSpecie)
        }
        
    }
    
}
