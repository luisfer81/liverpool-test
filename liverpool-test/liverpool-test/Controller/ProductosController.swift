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
import SDWebImage

class ProductosController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var productoTableView: UITableView!
    @IBOutlet weak var barraBusqueda: UISearchBar!
    
    let urlProductos = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp"
    var arrayProductos: [Productos] = []
    var paginas = 1
    var busqueda = ""
    var mensaje = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y dataSource TableView & Search Bar
        productoTableView.delegate = self
        productoTableView.dataSource = self
        barraBusqueda.delegate = self
        
        //Registro de ProductoCell.xib
        productoTableView.register(UINib(nibName: "ProductoCell", bundle: nil), forCellReuseIdentifier: "customProductoCell")
        
        mensaje = "Busca el producto que necesitas"
        
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - Metodos TableView DataSource
    
    
    //cellForRowAtIndexPath:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customProductoCell", for: indexPath) as! ProductoCell
        
        if arrayProductos[indexPath.row].precioDescuento > 0 {
            cell.precioNoDescuento.isHidden = false
            cell.precioDescuento.text = "\(arrayProductos[indexPath.row].precioDescuento)"
            cell.precioNoDescuento.text = "\(arrayProductos[indexPath.row].precioNoDescuento)"
        } else {
            cell.precioDescuento.text = "\(arrayProductos[indexPath.row].precioNoDescuento)"
            cell.precioNoDescuento.isHidden = true
        }
        
        cell.productoNombre.text = arrayProductos[indexPath.row].nombreProducto
        cell.productoImagen.sd_setImage(with: URL(string: arrayProductos[indexPath.row].imagen), placeholderImage: UIImage(named: "prueba.png"))
        
        return cell
    }
    
    
    //numberOfRowsInSection:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayProductos.count > 0 {
            self.productoTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return arrayProductos.count
        }
        else {
            let messageLabel = UILabel(frame: CGRect(x: 20.0, y: 0, width: self.productoTableView.bounds.size.width - 40.0, height: self.productoTableView.bounds.size.height))
            messageLabel.text = mensaje
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.center
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            self.productoTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
        
        return 0
    }
    
    //willDisplay Table
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ultimoDato = arrayProductos.count - 1
        if indexPath.row == ultimoDato {
            cargaDatos(pagina: paginas, busqueda: busqueda)
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        arrayProductos.removeAll()
        busqueda = barraBusqueda.text!
        paginas = 1
        cargaDatos(pagina: paginas, busqueda: busqueda)
    }
    
    func cargaDatos(pagina : Int, busqueda: String) {
        let params : [String : String] = ["search-string" : busqueda, "page-number" : "\(pagina)"]
        Alamofire.request(urlProductos, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                
                let productoJSON : JSON = JSON(response.result.value!)
                if let tempResult = productoJSON["plpResults"].dictionary {
                    if let record = tempResult["records"]?.arrayValue {
                        if record.count > 0 {
                            for i in 1...record.count {
                               
                                self.arrayProductos.append(Productos.init(nombreProducto: record[i-1]["productDisplayName"].stringValue, precioNoDescuento: Double(record[i-1]["listPrice"].stringValue)!, precioDescuento: Double(record[i-1]["promoPrice"].stringValue)!, imagen: record[i-1]["smImage"].stringValue))
                                
                            }
                            self.paginas = self.paginas + 1
                            self.productoTableView.reloadData()
                        } else {
                            print("producto no encontrado")
                            self.productoNoEncontrado()
                        }
                    }
                } else {
                    print("Producto No disponible")
                    self.productoNoEncontrado()
                }
                
                
            } else {
                print("Error - \(response.result.error!)")
                self.productoNoEncontrado()
            }
        }
    }
    
    func productoNoEncontrado() {
        arrayProductos.removeAll()
        mensaje = "Producto no encontrado prueba con otra busqueda"
        productoTableView.reloadData()
    }
   

}
