//
//  RouteViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit

class RouteViewController: UIViewController {
    
    private var routeDataManager: RouteDataManager = RouteDataManager()
    
    private var routeList: [RouteInformation]!

    private lazy var routeTableView = {
        let view = UITableView()
        
        return view
    }()
    
    private lazy var routeInfoView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var pageNumberLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var pointsNumberLabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 5
        
        return label
    }()
    
    private lazy var routeInfoUpdateButton = {
        let button = UIButton()
        button.setTitle("Route Info Update", for: .normal)
        button.setTitleColor(.yellow, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("nio")
        
        routeList = routeDataManager.getRouteFindingList().sorted(by: { $0.dataWrittenDate > $1.dataWrittenDate })
        routeTableView.reloadData()
    }
    
    func layoutConfigure() {
        [routeTableView, routeInfoView, routeInfoUpdateButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        [pageNumberLabel, pointsNumberLabel].forEach({
            routeInfoView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide
        let margin: CGFloat = 16
        
        NSLayoutConstraint.activate([
            routeInfoUpdateButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            routeInfoUpdateButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            routeInfoUpdateButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -margin),
            routeInfoUpdateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            routeInfoView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            routeInfoView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            routeInfoView.bottomAnchor.constraint(equalTo: routeInfoUpdateButton.topAnchor, constant: -margin),
            routeInfoView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            pointsNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            pointsNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            pointsNumberLabel.bottomAnchor.constraint(equalTo: routeInfoView.bottomAnchor),
            pointsNumberLabel.heightAnchor.constraint(equalToConstant: 72)
        ])
        
        NSLayoutConstraint.activate([
            pageNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            pageNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            pageNumberLabel.bottomAnchor.constraint(equalTo: pointsNumberLabel.topAnchor, constant: -margin),
            pageNumberLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            routeTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            routeTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        routeTableView.delegate = self
        routeTableView.dataSource = self
        routeTableView.register(RouteTableViewCell.self,
                                forCellReuseIdentifier: RouteTableViewCell.identifier)
    }
    
    func componentConfigure() {
        routeList = routeDataManager.getRouteFindingList()
        
        routeInfoUpdateButton.addTarget(self, action: #selector(routeInfoUpdateButtonClicked), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "ROUTE VC"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addRouteButtonClicked))
    }
}

extension RouteViewController {
    
    @objc func addRouteButtonClicked() {
        let rootVC = RenewalPageViewController()
        rootVC.routeDraft = RouteDataDraft(manager: routeDataManager, routeFinding: nil)
        
        
        let modalTypeNavigationVC = UINavigationController(rootViewController: rootVC)
        modalTypeNavigationVC.modalPresentationStyle = .fullScreen
        self.present(modalTypeNavigationVC, animated: true, completion: nil)
    }
    
    @objc func routeInfoUpdateButtonClicked() {
        if routeList.count > 0 {
            let index = Int.random(in: 0..<routeList.count)
            
            let tempRouteInfo = RouteInfo(imageLocalIdentifier: "", dataWrittenDate: Date(), gymName: "클라라", problemLevel: 5, isChallengeComplete: true, pages: [])
            routeDataManager.updateRoute(routeInfo: tempRouteInfo, routeInformation: routeList[index])
            
            print("ROUTE INFO UPDATE!")
            routeTableView.reloadData()
        }

    }
}

extension RouteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDataManager.getRouteFindingList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        
        let index = indexPath.row
        cell.labelConfigure(routeInfo: routeList[index])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let route = routeList[index]
        let pages = route.pages as! Set<PageInformation>
        let pageNum = pages.count
        let indices = pages.indices.map{$0}
        
        var pointsNumStr = "POINTS NO ORDER\n[ "
        for i in 0..<pageNum {
            let pointsNum = pages[indices[i]].points?.count
            pointsNumStr += " \(String(describing: pointsNum))"
        }
        pointsNumStr += " ]"
        
        pageNumberLabel.text = "PAGE FOR \(pageNum)"
        pointsNumberLabel.text = pointsNumStr
        
        let vc = RenewalPageViewController()
        
        vc.routeDraft = RouteDataDraft(manager: routeDataManager, routeFinding: route)
        vc.routeDraft.routeInfoForUI = route.routeInformationDraft()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let index = indexPath.row
            routeDataManager.deleteRouteData(routeInformation: routeList[index])
            routeList.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
