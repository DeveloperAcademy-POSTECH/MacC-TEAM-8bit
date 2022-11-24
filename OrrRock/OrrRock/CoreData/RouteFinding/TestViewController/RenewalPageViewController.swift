//
//  RenewalPageViewController.swift
//  OrrRock
//
//  Created by 황정현 on 2022/11/24.
//

import UIKit

class RenewalPageViewController: UIViewController {

    var routeDraft: RouteDataDraft!
    
    private lazy var pageTableView = {
        let view = UITableView()
        
        return view
    }()
    
    private lazy var seperatorView = {
        let view = UIView()
        view.backgroundColor = .yellow
        
        return view
    }()
    
    private lazy var addPageButton = {
        let button = UIButton()
        button.setTitle("ADD PAGE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.yellow.cgColor
        
        return button
    }()
    
    private lazy var saveRouteButton = {
        let button = UIButton()
        button.setTitle("SAVE ROUTE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.yellow.cgColor
        
        return button
    }()
    
    private lazy var removePointButton = {
        let button = UIButton()
        button.setTitle("REMOVE POINT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.blue.cgColor
        
        return button
    }()
    
    private lazy var updatePointButton = {
        let button = UIButton()
        button.setTitle("UPDATE POINT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor.blue.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if routeDraft.route != nil {
            routeDraft.pages = Array(routeDraft.route?.pages as! Set<PageInformation>)
        }
        
        layoutConfigure()
        componentConfigure()
        navigationBarConfigure()
    }
    
    func layoutConfigure() {
        [pageTableView, seperatorView, addPageButton, saveRouteButton, removePointButton, updatePointButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let safeArea = view.safeAreaLayoutGuide
        
        let margin: CGFloat = 16
        let buttonHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            saveRouteButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            saveRouteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            saveRouteButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            saveRouteButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            addPageButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            addPageButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            addPageButton.bottomAnchor.constraint(equalTo: saveRouteButton.topAnchor, constant: -margin),
            addPageButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            removePointButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            removePointButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            removePointButton.bottomAnchor.constraint(equalTo: addPageButton.topAnchor, constant: -margin),
            removePointButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            updatePointButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: margin),
            updatePointButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -margin),
            updatePointButton.bottomAnchor.constraint(equalTo: removePointButton.topAnchor, constant: -margin),
            updatePointButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: updatePointButton.topAnchor, constant: -margin),
            seperatorView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        NSLayoutConstraint.activate([
            pageTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pageTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pageTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            pageTableView.bottomAnchor.constraint(equalTo: seperatorView.topAnchor, constant: -margin)
        ])
        
    }
    
    func componentConfigure() {
        pageTableView.delegate = self
        pageTableView.dataSource = self
        pageTableView.register(PageTableViewCell.self,
                               forCellReuseIdentifier: PageTableViewCell.identifier)
        
        view.backgroundColor = .black
        pageTableView.backgroundColor = .black
        
        addPageButton.addTarget(self, action: #selector(addPageButtonClicked), for: .touchUpInside)
        
        saveRouteButton.addTarget(self, action: #selector(saveRouteButtonClicked), for: .touchUpInside)
        
        removePointButton.addTarget(self, action: #selector(removeBodyPointButtonClickedObjc), for: .touchUpInside)
        
        updatePointButton.addTarget(self, action: #selector(updatePointDataObjc), for: .touchUpInside)
    }
    
    func navigationBarConfigure() {
        self.navigationItem.title = "MAKE NEW ROUTE VC"
    }
}

extension RenewalPageViewController {
    
    // MARK: CREATE PAGE
    @objc func addPageButtonClicked() {
        let pageInfo = PageInfo(rowOrder: routeDraft.routeInfoForUI.pages.count , points: [])
        
        routeDraft.routeInfoForUI.pages.append(pageInfo)
        routeDraft.newPageInfo.append(pageInfo)
        
        pageTableView.reloadData()
    }
    
    // MARK: SAVE DATA(ROUTE)
    @objc func saveRouteButtonClicked() {
        routeDraft.save()
        
        if routeDraft.route == nil {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    // MARK: DELETE POINT
    @objc func removeBodyPointButtonClickedObjc() {
        let pageIndex = 0
        let pointIndex = 0
        routeDraft.removePointData(pageIndex: pageIndex, pointIndex: pointIndex)
    }
    
    // MARK: UPDATE POINT
    @objc func updatePointDataObjc() {
        let pageIndex = 0
        let pointIndex = 0
        let afterPoint: PointInfo = PointInfo(footOrHand: FootOrHand.foot, isForce: true, position: CGPoint(x: 3, y: 3), forceDirection: ForceDirection.pi4)
        routeDraft.updatePointData(pageIndex: pageIndex, pointIndex: pointIndex, targetPointInfo: afterPoint)
    }
}

extension RenewalPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeDraft.routeInfoForUI.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PageTableViewCell.identifier, for: indexPath) as! PageTableViewCell
        
        let index = indexPath.row
        cell.numberLabel.text = "PAGE \(index)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = BodyPointListViewController()
        vc.pageInfo = routeDraft.routeInfoForUI.pages[index]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let index = indexPath.row
        let point = PointInfo(footOrHand: FootOrHand.foot, isForce: false, position: CGPoint(x: 0, y: 0), forceDirection: ForceDirection.pi0)
        routeDraft.addPointData(pageIndex: index, pointInfo: point)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let index = indexPath.row
        
        if editingStyle == .delete {
            routeDraft.removePageData(pageIndex: index)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
