//
//  OrdenamientoViewController.swift
//  liverpool-test
//
//  Created by Luis Fernando Nava on 12/29/18.
//  Copyright © 2018 Luis Fernando Nava. All rights reserved.
//

import UIKit

class OrdenamientoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedRow: Int = 0
    var parametro = ""
    @IBOutlet weak var tablaFiltrado: UITableView!
    
    //Array de prueba para mostrar las opciones de filtrado
    let arrayOpciones = ["Predefinida", "Menor Precio", "Mayor Precio"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tablaFiltrado.delegate = self
        tablaFiltrado.dataSource = self

        
    }
    
    //MARK: - Funciones del table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOpciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrdenamiento") as! OrdenamientoCell
        
        cell.ordenamientoLabel.text = arrayOpciones[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
    //Accion del boton filtrado
    @IBAction func filtrado(_ sender: Any) {
      navigationController?.popToRootViewController(animated: true)
        
    }
    
}


// MARK: - Clase de la celda de ordenamiento
class OrdenamientoCell: UITableViewCell {
    
    
    @IBOutlet weak var ordenamientoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
