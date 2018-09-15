//
//  DrugsTableViewController.swift
//  DrugDrone
//
//  Created by Michal Švácha on 15/09/2018.
//  Copyright © 2018 Michal Švácha. All rights reserved.
//

import UIKit
import MBProgressHUD

class DrugsTableViewController: UITableViewController {
    let viewModel = DrugsTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parent?.title = "Drug Drone 🚁"
        
        tableView.apply(Stylesheet.General.tableView)
        bindTableView()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let pendingAction = UserDefaults.standard.string(forKey: "pendingAction"), let index = Int(pendingAction) {
            UserDefaults.standard.removeObject(forKey: "pendingAction")
            self.handleOrder(for: viewModel.drugs[index])
        }
    }
    
    func bindTableView() {
        viewModel.drugs.bind(to: tableView) { [unowned self] drugs, indexPath, tableView in
            let cell = tableView.dequeueReusableCell(withIdentifier: "drugCell") as! DrugTableViewCell
            let drug = drugs[indexPath.row]
            cell.configure(with: drug)
            cell.apply(Stylesheet.General.cell)
            cell.orderButton.reactive.tap.bind(to: self) { me, _ in
                me.orderButtonPressed(drug: drug)
            }.dispose(in: self.bag)
            return cell
        }.dispose(in: bag)
    }
    
    func orderButtonPressed(drug: Drug) {
        let ac = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to order a drone delivery of \(drug.name)?",
            preferredStyle: UIAlertControllerStyle.alert)
        ac.addAction(UIAlertAction(
            title: "No",
            style: UIAlertActionStyle.cancel,
            handler: nil))
        ac.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.default) { [unowned self] _ in
                self.handleOrder(for: drug)
        })
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func handleOrder(for drug: Drug) {
        viewModel.placeOrder(for: drug).bind(to: self) { me, result in
            switch result {
            case .loading:
                MBProgressHUD.showAdded(to: me.parent!.view, animated: true)
            case .loaded(let value):
                MBProgressHUD.hide(for: me.parent!.view, animated: true)
                self.performSegue(withIdentifier: "deliverySegue", sender: value)
            case .failed(let error):
                MBProgressHUD.hide(for: me.parent!.view, animated: true)
                me.presentSimpleAlertDialog(header: "Error", message: error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DrugDeliveryViewController
        viewController.viewModel.order = sender as? OrderDTO
    }
}
