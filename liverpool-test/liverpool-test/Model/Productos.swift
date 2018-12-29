//
//  Productos.swift
//  liverpool-test
//
//  Created by Luis Fernando Nava on 12/28/18.
//  Copyright © 2018 Luis Fernando Nava. All rights reserved.
//

import UIKit
import SwiftyJSON

class Productos {
    
    //Declaro las variables del modelo
    var nombreProducto : String = ""
    var precioNoDescuento : Double = 0.0
    var precioDescuento : Double = 0.0
    var imagen : String = ""
  
    
    init(nombreProducto : String, precioNoDescuento: Double, precioDescuento: Double, imagen: String) {
        self.nombreProducto = nombreProducto
        self.precioNoDescuento = precioNoDescuento
        self.precioDescuento = precioDescuento
        self.imagen = imagen
    }

}
