//
//  DateAndGymEditViewController+TableViewExtensions.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/15.
//

import UIKit

extension DateAndGymEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(maxTableViewCellCount, filteredVisitedGymList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = autocompleteTableView.dequeueReusableCell(withIdentifier: AutocompleteTableViewCell.identifier, for: indexPath) as! AutocompleteTableViewCell
        cell.setUpData(data: filteredVisitedGymList[indexPath.row])
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
}

extension DateAndGymEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gymTextField.text = filteredVisitedGymList[indexPath.row].name
        saveButton.isEnabled = true
        pressSaveButton()
    }
}

extension DateAndGymEditViewController: AutocompleteTableViewCellDelegate {
    func tapDeleteButton(deleteTarget: VisitedClimbingGym) {
        DataManager.shared.deleteVisitedClimbingGym(deleteTarget: deleteTarget)
        visitedGymList = DataManager.shared.repository.visitedClimbingGyms
        
        setUpTableViewData()
        searchGymName(textField: gymTextField)
        resetAutocompleteTableView()
    }
}
