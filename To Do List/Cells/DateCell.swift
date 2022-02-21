//
//  DateCell.swift
//  To Do List
//
//  Created by Konstantin Ryabtsev on 20.02.2022.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    func setDate(_ date: Date) {
        label.text = date.formatedFullDate
    }
}
