//
//  PopupModalView.swift
//  APPLES
//
//  Created by Steve Schaeffer on 7/6/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit

class PopupModalView: UIViewController, Dimmable {
    
    @IBOutlet weak var popupView: UIView!

    @IBOutlet weak var infoText: UITextView!
    

    let dimLevel: CGFloat = 0.45
    let dimSpeed: Double = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.blackColor().CGColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.blackColor().CGColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
        let formattedString = NSMutableAttributedString()
        formattedString.bold("Emergence: ").normal("formation of, or appearance of, new green tissue at the base of the stem for grasses; appearance of new green leaf tissue for forbs and herbs; opening of leaf buds, revealing newly formed green leaf tissue, in trees and shrubs \r\n \r\n").bold("Flower Set: ").normal("formation of an unopened flower bud \r\n \r\n").bold("Blooming: ").normal("opening of a flower bud with complete exposure of the blossom, where flower can be pollinated \r\n \r\n").bold("Fruit Set: ").normal("dropping of flower petals and development of a swollen fruit at the base of what was formerly the flower \r\n \r\n").bold("Seed Set: ").normal("drying and typically hardening of the fruit body to form a seed capsule \r\n \r\n").bold("Leaf Color Change: ").normal("appearance of red or orange coloration on approximately 5% to 10% of the leaf surface area, indicating color change away from green pigmentation \r\n \r\n").bold("Abscission: ").normal("release or dropping of a colored leaf from the stalk that joins the leaf to the stem")
        

        infoText.attributedText = formattedString
        
    }
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    

}

extension NSMutableAttributedString {
    func bold(text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "MyriadPro-BlackIt", size: 14)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.appendAttributedString(boldString)
        return self
    }
    
    func normal(text:String)->NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 14)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.appendAttributedString(boldString)
        return self
    }
}