//
//  Stylesheet.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import UIKit
import Material

enum Stylesheet {
    enum General {
        static let tableView = Style<UITableView> {
            $0.tableFooterView = UIView()
            $0.separatorColor = .clear
        }
        
        static let cell = Style<UITableViewCell> {
            $0.preservesSuperviewLayoutMargins = false
            $0.separatorInset = .zero
            $0.layoutMargins = .zero
        }
        
        static let flatButton = Style<FlatButton> {
            $0.backgroundColor = .gray
            $0.pulseColor = .white
        }
    }
}
