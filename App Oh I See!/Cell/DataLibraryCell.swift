//
//  DataLibraryCell.swift
//  App Oh I See!
//
//  Created by Diana Febrina Lumbantoruan on 13/07/21.
//

import UIKit

class DataLibraryCell: UITableViewCell {

    @IBOutlet weak var textImage: UIImageView!
    @IBOutlet weak var judulText: UILabel!
    @IBOutlet weak var tandaPanah: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
