//
//  oneFilterTableViewCell.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 03/09/2022.
//

import UIKit

class oneFilterTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var filterNameUILabel: UILabel!
    @IBOutlet weak var filterValueUILabel: UILabel!
    
    //MARK: - Functions
    func configure(for filterName: String, filterValue: String) {
        filterNameUILabel.text = filterName.capitalizingFirstLetter()
        filterValueUILabel.text = filterValue.capitalizingFirstLetter()
    }
    
}
