//
//  oneFilterTableViewCell.swift
//  ParkInBordeaux
//
//  Created by Clément Garcia on 03/09/2022.
//

import UIKit

/// Controller handling tableViewCells for the filter menu
class oneFilterTableViewCell: UITableViewCell {

    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - @IBOutlet
    
    /// Used to display the affected filter title
    @IBOutlet weak var filterNameUILabel: UILabel!
    /// Used to display the currently selected filter option.
    @IBOutlet weak var filterValueUILabel: UILabel!
    
    //MARK: - Functions
    /// Set the data to be displayed by the view
    /// - Parameters:
    ///   - filterName: Affected filter name
    ///   - filterValue: Affected filter current selection.
    func configure(for filterName: String, filterValue: String) {
        filterNameUILabel.text = filterName.capitalizingFirstLetter()
        filterValueUILabel.text = filterValue.capitalizingFirstLetter()
        filterValueUILabel.textColor = .gray
    }
}
