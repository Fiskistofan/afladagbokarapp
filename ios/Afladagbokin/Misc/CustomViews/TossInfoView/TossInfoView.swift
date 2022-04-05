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


protocol TossInfoViewDelegate: class {
    func tossInfoViewDidFinishWithClose(_ tossInfoView: TossInfoView)
    func tossInfoViewDidFinishWithDrag(_ tossInfoView: TossInfoView, annotation: Toss)
}


class TossInfoView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewSep: UIView!
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblCountDynamic: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDateDynamic: UILabel!
    
    @IBOutlet weak var lblGPS: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    
    @IBOutlet weak var btnExit: UIButton!
    @IBOutlet weak var btnDrag: UIButton!
    
    weak var delegate: TossInfoViewDelegate?
    var annotation: Toss!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        Bundle.main.loadNibNamed("TossInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.borderColor = Color.infoBorder.value.cgColor
        contentView.layer.borderWidth = 1
        
        style()
    }
    
    fileprivate func style() {
        self.layer.cornerRadius = 5
        
        // Set mainView
        self.contentView.layer.borderColor = Color.infoBorder.value.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 5
        self.contentView.backgroundColor = Color.infoBackground.value.withAlphaComponent(0.9)
        
        
        // Set title
        lblTitle.font = Fonts.System.bold.of(size: 16)
        lblTitle.textColor = Color.white.value
        
        
        // Set sub-titles
        _ = [lblCount, lblDate, lblGPS]
            .map {
                $0?.font = Fonts.System.bold.of(size: 14);
                $0?.textColor = Color.white.value
            }
        
        // Set dynamics
        _ = [lblCountDynamic, lblDateDynamic, lblLatitude, lblLongitude]
            .map {
                $0?.font = Fonts.System.regular.of(size: 14);
                $0?.textColor = Color.white.value
            }
        
        // Set buttons
        btnExit.setTitleColor(Color.redCloseButton.value, for: .normal)
        btnExit.titleLabel?.font = Fonts.System.bold.of(size: 14)
        btnDrag.setTitleColor(Color.white.value, for: .normal)
        btnDrag.layer.cornerRadius = 5
        btnDrag.layer.masksToBounds = true
        
        let gradientHelper = GradientHelper()
        let gradientColors = [UIColor(red:0.75, green:0.25, blue:0.35, alpha:1).cgColor, UIColor(red:0.74, green:0.25, blue:0.35, alpha:1).cgColor, UIColor(red:0.51, green:0.09, blue:0.27, alpha:1).cgColor]
        let gradientStartPoint = CGPoint(x: 0.53, y: -0.72)
        let gradientEndPoint = CGPoint(x: 0.59, y: 1.45)
        gradientHelper.addGradientTo(view: btnDrag, frame: btnDrag.bounds, colors: gradientColors, startPoint: gradientStartPoint, endPoint: gradientEndPoint)
        
        
        // Set sep
        viewSep.backgroundColor = Color.infoBorder.value
    }

}



// MARK: - Populate View
extension TossInfoView {
    func populateView(annotation: Toss) {
        self.annotation = annotation
        let toss = annotation
        
        lblTitle.text = toss.type.name.uppercased()
        
        lblDate.text = "Veiðarfæri í sjó:"
        lblDateDynamic.text = toss.date.toString()
        
        lblGPS.text = "Hnit(GPS):"
        lblLatitude.text = "(lat) \(toss.coordinates.latitude)"
        lblLongitude.text = "(lon) \(toss.coordinates.longitude)"
        
        btnExit.setTitle("LOKA", for: .normal)
        btnDrag.setTitle("Veiðarfæri úr sjó", for: .normal)
        
        if let lina = toss as? Lina {
            populateLina(lina: lina)
        } else if let net = toss as? Net {
            populateNet(net: net)
        } else if let handfaeri = toss as? Handfaeri {
            populateHandfaeri(handfaeri: handfaeri)
        }
    }
    
    fileprivate func populateLina(lina: Lina) {
        lblCount.text = "Fjöldi öngla og bjóða:"
        lblCountDynamic.text = "\(lina.onglaCount) — \(lina.bjodaCount)"
        
        //btnDrag.setTitle("DRAGA LÍNU", for: .normal)
    }
    
    fileprivate func populateNet(net: Net) {
        lblCount.text = "Fjöldi neta:"
        lblCountDynamic.text = "\(net.remainingTosses())/\(net.tossCount)"
        
        //btnDrag.setTitle("DRAGA NET", for: .normal)
    }
    
    fileprivate func populateHandfaeri(handfaeri: Handfaeri) {
        lblCount.text = "Fjöldi handfæra:"
        lblCountDynamic.text = "\(handfaeri.remainingTosses())/\(handfaeri.tossCount)"
        
        //btnDrag.setTitle("DRAGA HANDFÆRI", for: .normal)
    }

}



// MARK: - IBActions
extension TossInfoView {
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        delegate?.tossInfoViewDidFinishWithClose(self)
    }
    
    
    @IBAction func btnDragaTapped(_ sender: Any) {
        delegate?.tossInfoViewDidFinishWithDrag(self, annotation: annotation)
    }
}
