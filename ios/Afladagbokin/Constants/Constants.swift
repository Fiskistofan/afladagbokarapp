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
import Foundation

//MARK: - Language settings


//MARK: - Cornerradius
enum CornerRadius: CGFloat{
    case base = 10
    case medium = 8
    case small = 6
    case micro = 3
}

struct ApplicationConstants {
    
    static let unkownError = "Eitthvað fór úrskeiðis"
    static let GDPR_READ_MORE_URL = "https://aflaskraning.is/privacy-policy"
}

struct Texts{
    
    //Authentication texts
    static let textLogin = "Skráðu þig inn í appið með símanúmerinu þínu hér fyrir neðan. Útgerð þarf að hafa skráð þig sem skipstjóra á "
    static let myPages = "Mínar Síður"
    static let phoneNr = "Símanúmer"
    static let confirmation = "Sláðu inn staðfestingarkóðann sem var sendur í númerið "
    static let confirmation2 = " og smelltu á græna takkann til að skrá þig inn.\n\n Ef þú fékkst ekki kóða getur þú beðið um nýtt SMS hér fyrir ofan. "
    static let smsConfirm = "SMS staðfestingarkóði"
    static let dagbok = "Afladagbókin"
    
    //Afli texts
    static let notLogged = "Þú hefur ekki skráð afla í dag"
    static let clickHere = "Smelltu á plúsinn fyrir ofan til að skrá afla."
    static let skraAfla = "Skrá afla"
    static let fromWhere = "Úr hvaða afla ertu að skrá?"
    static let chooseType = "Veldu tegund"
    static let estimatedFishing = "Skrá áætlaðan afla"
    static let fish = "Fiskur"
    static let birdsAndMammals = "Fuglar og spendýr"
    static let bird = "Fugl"
    static let logType = "Skrá aflategund"
    static let cancel = "Hætta við"
    static let weight = "Þyngd (kg)"
    static let quantity = "Fjöldi"
    static let enterWeight = "Sláðu inn þyngd"
    static let enterQuantity = "Sláðu inn fjölda"
    static let sleppt = "Landað eða sleppt?"
    static let sleppa = "Sleppt"
    static let londud = "Landað"
    static let save = "VISTA SKRÁNINGU"
    
    //MORE texts
    static let moreTitle = "Meira"
    static let loggedInAs = "Þú ert skráður inn sem"
    static let kt = "kt: "
    static let moreDescription = "Appið er ætlað sjómönnum til aflaskráningar og skila til Fiskistofu."
    
    //STATS texts
    static let info = "Þegar aflaskráning hefur verið skilað inn byrjar tölfræðin að birtast hér"
    
    //VC titles
    static let tolfraedi = "Tölfræði"
    
    //Back texts
    static let bakka = "Til baka"
    
    //GDPR
    static let GDPR_MSG = "Fiskistofa hefur tekið í notkun nýja skilmála sem innihalda upplýsingar um persónuverndarstefnu Fiskistofu. Í stefnunni getur þú kynnt þér hvaða persónuupplýsingum Fiskistofa er að safna, í hvaða tilgangi og hvaða rétt þú hefur varðandi aðgang og leiðréttingar á persónuupplýsingum um þig. Kynntu þér málið!"
    static let GDPR_MSG_TITLE = "Uppfærðir skilmálar"
    static let GDPR_ACCEPT_BTN = "Samþykkja"
    static let GDPR_READ_MORE_BTN = "Lesa meira"
    static let GDPR_SUBTITLE = "Ný persónuverndarstefna"
    static let GDPR_ERROR = "Ekki náðist að skrá samþykki. Vinsamlegast reyndu aftur"
    
}
