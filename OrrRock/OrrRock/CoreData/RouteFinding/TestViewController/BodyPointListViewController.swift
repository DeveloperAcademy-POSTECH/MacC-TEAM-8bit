//
//  BodyPointListViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit

class BodyPointListViewController: UIViewController {

    var pageInfo: PageInfo!
    
    private lazy var bodyPointTableView = {
        let view = UITableView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [bodyPointTableView].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide

        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            bodyPointTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            bodyPointTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bodyPointTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            bodyPointTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin)
        ])
        

    }
    
    func componentConfigure() {
        
        bodyPointTableView.delegate = self
        bodyPointTableView.dataSource = self
        bodyPointTableView.register(BodyPointListTableViewCell.self,
                      forCellReuseIdentifier: BodyPointListTableViewCell.identifier)
        
        view.backgroundColor = .black
        bodyPointTableView.backgroundColor = .black
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "BODY POINT VC"
    }
}

extension BodyPointListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageInfo.points?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BodyPointListTableViewCell.identifier, for: indexPath) as! BodyPointListTableViewCell
        
        let index = indexPath.row
        cell.numberLabel.text = "POINT \(pageInfo.points?[index].position)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("CURRENT SELECTED POINT: \(index)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

