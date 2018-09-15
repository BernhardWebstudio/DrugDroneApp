//
//  DrugTableViewCell.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import UIKit
import Material

class DrugTableViewCell: UITableViewCell {
    @IBOutlet weak var drugTypeLabel: UILabel!
    @IBOutlet weak var orderButton: FlatButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with drug: Drug) {
        let size = drugTypeLabel.frame.size.height
        drugTypeLabel.bounds = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        drugTypeLabel.layer.cornerRadius = size / 2.0
        drugTypeLabel.layer.borderWidth = 1.5
        drugTypeLabel.layer.backgroundColor = UIColor.clear.cgColor
        drugTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        switch drug.type {
        case .pill:
            drugTypeLabel.text = "💊"
        case .dose:
            drugTypeLabel.text = "💉"
        case .unknown:
            drugTypeLabel.text = "❓"
        }
        
        orderButton.apply(Stylesheet.General.flatButton)
        orderButton.titleLabel?.lineBreakMode = .byWordWrapping
        orderButton.titleLabel?.textAlignment = .center
        
        let localizedTitle = NSLocalizedString(drug.name, comment: "")
        let titleString = NSMutableAttributedString(
            string: "\(localizedTitle)\n",
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.white
            ])
        
        let localizedDetail = NSLocalizedString("\(drug.description)", comment: "")
        let detailString = NSMutableAttributedString(
            string: localizedDetail,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: UIColor.white
            ])
        
        titleString.append(detailString)
        orderButton.setAttributedTitle(titleString, for: .normal)
    }
}
