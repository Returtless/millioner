//
//  RecordsTableViewController.swift
//  millioner
//
//  Created by Владислав Лихачев on 29.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    private var formatter: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "d MMM y HH:mm"
        return format
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Game.shared.records.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath)
        cell.textLabel?.text =  "\(formatter.string(from: Game.shared.records[indexPath.row].date)) - \(Game.shared.records[indexPath.row].score * 100)% правильных ответов"
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}
