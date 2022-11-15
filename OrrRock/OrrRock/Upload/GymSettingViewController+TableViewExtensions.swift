//
//  GymSettingViewController+TableViewExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/15.
//

import Foundation
import UIKit

extension GymSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(maxTableViewCellCount, visitedGymList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = autocompleteTableView.dequeueReusableCell(withIdentifier: AutocompleteTableViewCell.identifier, for: indexPath) as! AutocompleteTableViewCell
        cell.setUpData(data: visitedGymList[indexPath.row])
        
        return cell
    }
}

extension GymSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}



