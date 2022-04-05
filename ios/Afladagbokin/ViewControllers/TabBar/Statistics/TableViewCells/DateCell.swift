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

enum DateCellType{
    
    case from
    case to
}

protocol DateCellDelegate:class{
    
    func didTapDate(isFromDate: Bool)
}

class DateCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var lblDate: UILabel!
    public weak var delegate: DateCellDelegate?
    var date = Observable<String>("")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithType(type: DateCellType, strDate: Observable<String>){
        
        lblDate.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        lblDate.textColor = Color.blue.value
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.viewContent.layer.shadowOffset = CGSize.zero
        self.viewContent.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.1).cgColor
        self.viewContent.layer.shadowOpacity = 1
        self.viewContent.layer.shadowRadius = 15
        self.date = strDate
        self.selectionStyle = .none
        _ = self.date.observeNext{ [weak self] _ in
            
            self?.lblDate.text = self?.date.value
        }
    }
    
}
