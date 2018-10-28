//
//  PowerpointListTableViewController.swift
//  PowerPointPresenter
//
//  Created by Shubham Garg on 26/10/18.
//  Copyright © 2018 Shubham Garg. All rights reserved.
//

import UIKit
import Firebase
class PowerpointListTableViewController: UITableViewController {
    
    // MARK: Properties
    var items: [Powerpoint] = []
    var user: User!
    let ref = Database.database().reference(withPath: "powerpoint-items")
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Powerpoint] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let item = Powerpoint(snapshot: snapshot) {
                    newItems.append(item)
                }
            }
            let example1 = Powerpoint(name: "Worst-Presentation", addedByUser: self.user.uid, isDownloaded: false, path: "")
            let example2 = Powerpoint(name: "Presentation-Suggestions", addedByUser: self.user.uid, isDownloaded: false, path: "")
            let example3 = Powerpoint(name: "Presentations-Tips", addedByUser: self.user.uid, isDownloaded: false, path: "")
            newItems.append(example1)
            newItems.append(example2)
            newItems.append(example3)
            self.items = newItems
            
            self.tableView.reloadData()
        })
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(self.logout))
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    
    // Override to support conditional editing of the table view.Return false if you do not want the specified item to be editable.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = items[indexPath.row]
            item.ref?.removeValue()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PresentationViewController" ) as! PresentationViewController
        if !item.isDownloaded{
            vc.url = Bundle.main.url(forResource: item.name, withExtension: "ppt")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    @objc func downloadPPT() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DownloadPPTViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
