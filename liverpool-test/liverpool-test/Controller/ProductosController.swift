//
//  ProductosController.swift
//  liverpool-test
//
//  Created by Luis Fernando Nava on 12/28/18.
//  Copyright © 2018 Luis Fernando Nava. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductosController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productoTableView: UITableView!
    
    let urlProductos = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y dataSource TableView
        productoTableView.delegate = self
        productoTableView.dataSource = self
        
        //Registro de ProductoCell.xib
        productoTableView.register(UINib(nibName: "ProductoCell", bundle: nil), forCellReuseIdentifier: "customProductoCell")
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - Metodos TableView DataSource
    
    
    //cellForRowAtIndexPath:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customProductoCell", for: indexPath) as! ProductoCell
        cell.precioDescuento.text = "$6789.00"
        cell.precioNoDescuento.text = "1000.00"
        cell.productoNombre.text = "hajajajjajajajajajajashhsahshahahsshshahsahsahshashsahhahsahshashahsahhsashahsasah"
        cell.productoImagen.image = UIImage(named: "prueba")
        
        
        return cell
    }
    
    
    //numberOfRowsInSection:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    //configureTableView para la altura en caso de que se nesecite mas:
//    func configureTableView() {
//        productoTableView.rowHeight = UITableView.automaticDimension
//        productoTableView.estimatedRowHeight = 120.0
//    }
    
    ///////////////////////////////////////////

}
