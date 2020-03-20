//
//  ListViewController.swift
//  FirebaseHelloWorld
//
//  Created by admin on 06/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
//Add datasource and delegate
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudStorage.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellInTableView")
        cell?.textLabel?.text = CloudStorage.getNoteAt(index:indexPath.row).head
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController{
            destination.rowNumber = tableView.indexPathForSelectedRow!.row
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segue1", sender: self) //Perform the segue
        
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CloudStorage.createNote(head: "Hej min ven", body: "sker der G")
        tableView.delegate = self //Handle vents for tableview
        tableView.dataSource = self //Provide data for the tableview
        
        CloudStorage.startListener(tableView: tableView)

    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData() //reloads data
    }
    

    
    

}
