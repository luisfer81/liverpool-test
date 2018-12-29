//
//  ProductoCell.swift
//  liverpool-test
//
//  Created by Luis Fernando Nava on 12/28/18.
//  Copyright © 2018 Luis Fernando Nava. All rights reserved.
//

import UIKit

class ProductoCell: UITableViewCell {

    @IBOutlet weak var productoImagen: UIImageView!
    @IBOutlet weak var productoNombre: UILabel!
    @IBOutlet weak var precioNoDescuento: UILabel!
    @IBOutlet weak var precioDescuento: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
