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
    var labelColor = UILabel()
    var valorInicial = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate y dataSource TableView & Search Bar
        productoTableView.delegate = self
        productoTableView.dataSource = self
        barraBusqueda.delegate = self
        
        //gesto de tabla
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        productoTableView.addGestureRecognizer(tapGesture)
        
        //Registro de ProductoCell.xib
        productoTableView.register(UINib(nibName: "ProductoCell", bundle: nil), forCellReuseIdentifier: "customProductoCell")
        
        mensaje = "Busca el producto que necesitas"
        
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - Metodos TableView DataSource
    
    
    //cellForRowAtIndexPath:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customProductoCell", for: indexPath) as! ProductoCell
        
        // Verificar si el precio de descuento es mayo a cero estonces mostrarlo, si no solo mostrar el precio sin descuento
        if arrayProductos[indexPath.row].precioDescuento > 0 {
            cell.precioNoDescuento.isHidden = false
            cell.precioDescuento.text = "$ \(arrayProductos[indexPath.row].precioDescuento)"
            cell.precioNoDescuento.text = "$ \(arrayProductos[indexPath.row].precioNoDescuento)"
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(arrayProductos[indexPath.row].precioNoDescuento)")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            cell.precioNoDescuento.attributedText = attributeString

        } else {
            cell.precioDescuento.text = "$ \(arrayProductos[indexPath.row].precioNoDescuento)"
            cell.precioNoDescuento.isHidden = true
        }
        
        valorInicial = 7
        for valor in arrayProductos[indexPath.row].arrayColor.arrayValue {
            
            labelColor = UILabel(frame: CGRect(x: valorInicial, y: 130, width: 15, height: 15))
            labelColor.textColor = UIColor.white
            labelColor.font = UIFont.systemFont(ofSize: 24.0)
            labelColor.layer.cornerRadius = 15.0 / 2
            labelColor.layer.borderWidth = 3.0
            labelColor.layer.masksToBounds = true
            print(index)
            
            let color = stringToColor(hexString: valor["colorHex"].stringValue)
            
            labelColor.layer.backgroundColor = color.cgColor
            labelColor.layer.borderColor = color.cgColor
            valorInicial = valorInicial + 19
            cell.contenerdorView.addSubview(labelColor)
            print(valor["colorHex"])
        }
        
      
        
        cell.productoNombre.text = arrayProductos[indexPath.row].nombreProducto
        //COMO PLACEHOLDER USE UNA IMAGEN DE UNA BOLSA QUE DESCARGUE DE UNA URL
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
    
    /////////////////////////////////
    
    //MARK: - Metodos SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        barraBusqueda.endEditing(true)
        arrayProductos.removeAll()
        busqueda = barraBusqueda.text!
        paginas = 1
        cargaDatos(pagina: paginas, busqueda: busqueda)
    }
    
    //Funcion de termino de edicion de barra de busqueda al tocar la tabla
    @objc func tableViewTapped() {
        barraBusqueda.endEditing(true)
    }
    
    /////////////////////////////////////////
    
    //MARK: - Funcion para la carga de datos con paginacion.
    
    func cargaDatos(pagina : Int, busqueda: String) {
        let params : [String : String] = ["search-string" : busqueda, "page-number" : "\(pagina)"]
        Alamofire.request(urlProductos, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                
                let productoJSON : JSON = JSON(response.result.value!)
                if let tempResult = productoJSON["plpResults"].dictionary {
                    if let record = tempResult["records"]?.arrayValue {
                        if record.count > 0 {
                            //Ciclo para recorrer el array que nos devuelve la bsuqueda y agregar datos al arrayProducots
                            for i in 1...record.count {
                               
                                //print(record[i-1]["variantsColor"][0]["colorHex"])
                                self.arrayProductos.append(Productos.init(nombreProducto: record[i-1]["productDisplayName"].stringValue, precioNoDescuento: Double(record[i-1]["listPrice"].stringValue)!, precioDescuento: Double(record[i-1]["promoPrice"].stringValue)!, imagen: record[i-1]["smImage"].stringValue, arrayColor: record[i-1]["variantsColor"]))
                                
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
    
    
    ///////////////////////////////
    
    //MARK: -Funciono que remueve los datos del array de productos, en caso de no encontrar un producto
    func productoNoEncontrado() {
        arrayProductos.removeAll()
        mensaje = "Producto no encontrado prueba con otra busqueda"
        productoTableView.reloadData()
    }
    
    //////////////////////////////
    
    //MARK: -Funciones para convertir el color hexadecimal a UIColor
    
    func stringToColor(hexString: String) -> UIColor {
        // Convert hex string to an Int
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let rojo = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let verde = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let azul = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = 1.0
        // Create color object, specifying alpha as well
        return UIColor(red: rojo, green: verde, blue: azul, alpha: CGFloat(alpha))
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // scanner eviat el simbolo #
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan valor hex
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
   

}
