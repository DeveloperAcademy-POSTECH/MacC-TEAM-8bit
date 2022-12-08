//
//  MyActivityViewController.swift
//  OrrRock
//
//  Created by Park Sungmin on 2022/11/19.
//

import SwiftUI
import UIKit

import SnapKit

class MyActivityViewController: UIViewController {
    
    var firstDateOfClimbing: Date? = nil
    var highestLevel: Int = -1
    var mostVisitedGymCountForSummary: Int = 0
    
    var entireSolvedProblemsForGrowthChart: [[SolvedProblemsOfEachLevel]] = [[],[],[]]
    var periodDataForGrowthChart: [(Date, Date)] = [(Date(), Date()), (Date(), Date()), (Date(), Date())]
    
    var entireProblemsForChallengeChart: [ChartCellModel] = []
    var validTotalCountForChallengeChart: Int = 0
    var validSuccessCountForChallengeChart: Int = 0
    
    var frequentlyVisitedGymList: [(String, Int)] = [("", 0), ("", 0), ("", 0)]
    var totalGymVisitedDate: Int = 0
    
    // 레이아웃
    private lazy var headerView: UIView = {
        let view = UIView()
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints {
            $0.edges.equalTo(view.snp.edges)
        }
        
        return view
    }()
    
    private lazy var logoView: UIView = {
        let view = UIImageView(image: UIImage(named: "orrrock_logo"))
        view.frame = CGRect(x: 0, y: 0, width: 193, height: 40)
        return view
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .orrGray050
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .orrGray050
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var paddingView: UIView = {
        return UIView()
    }()
    
    // 내 활동
    private lazy var cardTitle: UILabel = {
        let view = UILabel()
        view.text = "내 활동"
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var cardSaveButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .orrGray600
        
        button.addTarget(self, action: #selector(tapCardSaveButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cardView: UIView = {
        let VC = UIHostingController(rootView: MyCardView(firstDate: firstDateOfClimbing, highestLevel: highestLevel, homeGymName: frequentlyVisitedGymList[0].0))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    // 도전
    private lazy var challengeTitle: UILabel = {
        let view = UILabel()
        view.text = "도전"
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var challengeChartView: UIView = {
        let VC = UIHostingController(rootView: ChallengeChartView(chartData: ChartDataModel(dataModel: entireProblemsForChallengeChart), totalCount: validTotalCountForChallengeChart, successCount: validSuccessCountForChallengeChart))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var growthChartView: UIView = {
        var mostFrequentLevelForPeriod: [Int] = [-1, -1, -1]

        mostFrequentLevelForPeriod[0] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[0])
        mostFrequentLevelForPeriod[1] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[1])
        mostFrequentLevelForPeriod[2] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[2])

        let VC = UIHostingController(rootView: GrowthChartView(chartData: entireSolvedProblemsForGrowthChart, periodData: periodDataForGrowthChart, mostFrequentLevelForPeriod: mostFrequentLevelForPeriod))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    // 정보
    private lazy var informationTitle: UILabel = {
        let view = UILabel()
        view.text = "정보"
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var homeGymChartView: UIView = {
        let VC = UIHostingController(rootView: HomeGymChartView(mostFrequentlyVisitedGymList: frequentlyVisitedGymList, totalGymVisitedDate: totalGymVisitedDate))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var historyView: UIView = {
        let VC = UIHostingController(rootView: HistoryView(fromDate: firstDateOfClimbing, tapEditButton: editFirstDateOfClimbing))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orrGray050
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        setUpData()
        setUpSubViews()
        setUpLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    func setUpData() {
        let entireVideoInformationsByDate: [[VideoInformation]] = DataManager.shared.repository.sortVideoInformation(filterOption: .all, sortOption: .gymVisitDate)
        let entireVideoInformationsByName: [[VideoInformation]] = DataManager.shared.repository.sortVideoInformation(filterOption: .all, sortOption: .gymName)
        
        resetFirstDateOfClimbing(from: entireVideoInformationsByDate)
        firstDateOfClimbing = UserDefaults.standard.string(forKey: "firstDateOfClimbing")?.stringToDate() ?? Date()
        
        (highestLevel, frequentlyVisitedGymList, totalGymVisitedDate) = getSummaryData(fromDate: entireVideoInformationsByDate, fromName: entireVideoInformationsByName)
        
        (entireProblemsForChallengeChart, validTotalCountForChallengeChart, validSuccessCountForChallengeChart) = getProblemsPerLevel(from: entireVideoInformationsByDate)
        
        (entireSolvedProblemsForGrowthChart[0], periodDataForGrowthChart[0]) = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .week)
        (entireSolvedProblemsForGrowthChart[1], periodDataForGrowthChart[1]) = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .month)
        (entireSolvedProblemsForGrowthChart[2], periodDataForGrowthChart[2]) = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .year)
    }
    
    func resetFirstDateOfClimbing(from: [[VideoInformation]]) {
        guard let firstDate = from.last?.first?.gymVisitDate else {
            UserDefaults.standard.set(Date().timeToString(), forKey: "firstDateOfClimbing")
            return
        }
        
        if let userData = UserDefaults.standard.string(forKey: "firstDateOfClimbing") {
            if firstDate < userData.stringToDate()! {
                UserDefaults.standard.set(firstDate.timeToString(), forKey: "firstDateOfClimbing")
            }
        } else {
            UserDefaults.standard.set(firstDate.timeToString(), forKey: "firstDateOfClimbing")
        }
    }
    
    // 가장 처음 클라이밍장을 방문한 날짜, 혹은 사용자가 작성한 최초 클라이밍장 방문 날짜를 반환
    func getSummaryData(fromDate: [[VideoInformation]], fromName: [[VideoInformation]]) -> (Int, [(String, Int)], Int) {
        // 기록된 영상들의 정보 중 가장 높은 레벨을 반환
        // 이후 개선을 통해 UserDefault에 최고점에 대한 정보를 저장할 수 있도록 한다면 성능 최적화가 용이하다고 생각됨
        var highestLevel = -1
        let flatten = fromDate.flatMap { $0 }
        flatten.forEach { highestLevel = max(Int($0.problemLevel), highestLevel) }
        
        // 기록된 영상들의 정보 중 많이 방문한 클라이밍장명 Top3를 반환
        // 이후 개선을 통해 UserDefault에 가장 많이 방문한 클라이밍장을 저장할 수 있도록 한다면 성능 최적화가 용이하다고 생각됨
        var visitedGymCount: [(String, Int)] = []
        var totalVisitCount: Int = 0
        //        var (mostVisitedCount, mostVisitiedGymName): (Int, String) = (0, "")
        fromName.forEach { videoListOfEachGym in
            var visitedCount = 0
            var tempDate = Calendar.current.date(byAdding: .day, value: -1, to: firstDateOfClimbing!)
            
            videoListOfEachGym.forEach {
                if tempDate != $0.gymVisitDate {
                    visitedCount += 1
                    tempDate = $0.gymVisitDate
                }
            }
            
            visitedGymCount.append((videoListOfEachGym.first!.gymName, visitedCount))
            totalVisitCount += visitedCount
        }
        
        visitedGymCount.sort { $0.1 > $1.1 }
        
        if visitedGymCount.count > 3 {
            // 방문한 클라이밍장이 3군데가 넘는다면 3개로 맞춰주기
            visitedGymCount.removeSubrange(3..<visitedGymCount.count)
        } else {
            // 방문한 클라이밍장이 3군데가 안된다면, 3개로 채워주기
            while visitedGymCount.count != 3 {
                visitedGymCount.append(("", 0))
            }
        }
        
        return (highestLevel, visitedGymCount, totalVisitCount)
    }
    
    // [[VideoInformation]]을 인자로 받아와 차트를 그릴 데이터 모델, 레벨 분류가 된 영상의 전체 개수, 성공한 개수를 반환
    func getProblemsPerLevel(from: [[VideoInformation]]) -> ([ChartCellModel], Int, Int) {
        var result: [ChartCellModel] = []
        var validCount = 0
        var successCount = 0
        
        for level in 0...9 {
            result.append(ChartCellModel(numOfSolvedProblems: 0, level: "v\(level)"))
        }
        
        let flatten = from.flatMap { $0 }
        flatten.forEach { videoInformation in
            if videoInformation.problemLevel >= 0 {
                result[Int(videoInformation.problemLevel)].numOfSolvedProblems += 1
                validCount += 1
                successCount += videoInformation.isSucceeded ? 1 : 0
            }
        }
        
        return (result, validCount, successCount)
    }
    
    // [[VideoInformation]]와 기간을 인자로 받아와 차트를 그릴 데이터 모델을 반환
    func getSolvedProblemsPerPeriod(from: [[VideoInformation]], period: TimePeriodEnum) -> ([SolvedProblemsOfEachLevel], (Date, Date)) {
        let iterationForPeriod: Int = {
            switch period {
            case .week:
                return 7
            case .month:
                return 5
            case .year:
                return 12
            }
        }()
        
        let timePeriodInterval: Int = {
            switch period {
            case .week:
                return 1
            case .month:
                return 7
            case .year:
                return 30
            }
        }()
        
        var result: [SolvedProblemsOfEachLevel] = []
        
        for level in 0...9 {
            result.append(SolvedProblemsOfEachLevel(level: level, name: "v\(level)", problems: []))
            for periodIndex in 0..<iterationForPeriod {
                //
                result[level].problems.append(SolvedProblemsOfEachPeriod(periodName: periodIndex == iterationForPeriod-1 ? period.thisString() : "\(iterationForPeriod - 1 - periodIndex)\(period.unitString()) 전", count: 0))
            }
        }
        
        // DateComponent Type의 경우에는 nil이 될 수 있으나, Date Type은 모든 값을 반드시 가지고 있기 때문에 nil이 되지 않아 강제 언래핑이 안전합니다!
        var lastDayOfThisPeriod: Date = Calendar.current.date(byAdding: .day, value: -timePeriodInterval, to: Date())!.timeToString().stringToDate()!
        var periodIndex: Int = iterationForPeriod-1
        
        // videoInformationUnit은 "같은 날짜에 같은 클라이밍장을 방문하여 기록한 영상의 뭉치"임
        searchVideoLoop: for videoInformationUnit in from {
            // 해당 배열에 아무 값도 없는 경우 continue (error)
            guard let sample = videoInformationUnit.first else { continue searchVideoLoop }
            
            // 해당 데이터가 속한 time period를 찾아감
            while (sample.gymVisitDate < lastDayOfThisPeriod) {
                lastDayOfThisPeriod = Calendar.current.date(byAdding: .day, value: -timePeriodInterval, to: lastDayOfThisPeriod)!
                periodIndex -= 1
            }
            
            // 영상 정보의 날짜가 차트로 만들고자 하는 time period를 넘어선 경우부터는 이후 영상 정보들을 데이터에 포함하지 않음
            if periodIndex < 0 { break }
            
            // 차트에 포함되어야 하는 데이터이므로, Unit에 포함된 영상 데이터들의 개수를 count 합니다.
            videoInformationUnit.forEach { videoInformation in
                if videoInformation.problemLevel >= 0 {
                    result[Int(videoInformation.problemLevel)].problems[periodIndex].count += 1
                }
            }
        }
        
        let periodData: (Date, Date) = (Calendar.current.date(byAdding: .day, value: -(iterationForPeriod * timePeriodInterval), to: Date())!, Date())
        
        return (result, periodData)
    }
    
    func getMostFrequentLevelOfList(from: [SolvedProblemsOfEachLevel]) -> Int {
        var maxCount = 0
        var mostFrequentLevel = -1
        
        from.forEach { setForLevel in
            var problemCount: Int = 0
            setForLevel.problems.forEach { solvedForEachDay in
                problemCount += solvedForEachDay.count
            }
            
            mostFrequentLevel = problemCount > maxCount ? setForLevel.level : mostFrequentLevel
            maxCount = problemCount > maxCount ? problemCount : maxCount
        }
        
        return mostFrequentLevel
    }
    
    private func editFirstDateOfClimbing() {
        let viewController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        let vc = FirstDateSettingViewController()
        vc.completioHandler = { [self] date in
            self.firstDateOfClimbing = date
            redrawViewWithFirstDateOfClimbing()
        }
        viewController.present(vc, animated: true)
    }
    
    func redrawViewWithFirstDateOfClimbing() {
        // myCardView
        cardView.removeFromSuperview()
        
        let myCardVC = UIHostingController(rootView: MyCardView(firstDate: firstDateOfClimbing, highestLevel: highestLevel, homeGymName: frequentlyVisitedGymList[0].0))
        myCardVC.view.backgroundColor = .clear
        cardView = myCardVC.view
        
        contentView.addSubview(cardView)
        
        // historyView
        historyView.removeFromSuperview()
        
        let historyVC = UIHostingController(rootView: HistoryView(fromDate: firstDateOfClimbing, tapEditButton: editFirstDateOfClimbing))
        historyVC.view.backgroundColor = .clear
        historyView = historyVC.view
        
        contentView.addSubview(historyView)
        
        removeLayout()
        setUpLayout()
    }
    
    @objc func tapCardSaveButton(_ sender: UIButton) {
        let card: UIView = {
            let VC = UIHostingController(rootView: ExportCardView(firstDate: firstDateOfClimbing, highestLevel: highestLevel, homeGymName: frequentlyVisitedGymList[0].0))
            VC.view.backgroundColor = .clear
            VC.view.layer.cornerRadius = 4
            VC.view.frame = CGRect(x: 0, y: 0, width: 262, height: 398)
            return VC.view
        }()
        
        // 공유하기
        var shareObject = [Any]()
        contentView.addSubview(card)
        shareObject.append(card.asImage())
        card.removeFromSuperview()
        
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func longPressedCardSaveButton() {
        let card: UIView = {
            let VC = UIHostingController(rootView: ExportCardView(firstDate: firstDateOfClimbing, highestLevel: highestLevel, homeGymName: frequentlyVisitedGymList[0].0))
            VC.view.backgroundColor = .clear
            VC.view.layer.cornerRadius = 4
            VC.view.frame = CGRect(x: 0, y: 0, width: 262, height: 398)
            return VC.view
        }()
        
        // 공유하기
        var shareObject = [Any]()
        contentView.addSubview(card)
        shareObject.append(card.asImage())
        card.removeFromSuperview()
        
        
        let activityViewController = UIActivityViewController(activityItems : shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func refreshView(_ sender: UIRefreshControl) {
        print("refresh")
        
        refreshView()
        
        sender.endRefreshing()
    }
}

extension MyActivityViewController {
    func setUpSubViews() {
        // Layout
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(paddingView)
        
        // 내 활동
        [cardTitle, cardSaveButton, cardView].forEach() {
            contentView.addSubview($0)
        }
        
        // 도전
        [challengeTitle, challengeChartView, growthChartView].forEach() {
            contentView.addSubview($0)
        }
        
        // 정보
        [informationTitle, homeGymChartView, historyView].forEach() {
            contentView.addSubview($0)
        }
        
        // Header
        view.addSubview(headerView)
        headerView.addSubview(logoView)
    }
    
    func removeLayout() {
        // Layout
        [headerView, logoView, scrollView, contentView].forEach {
            $0.snp.removeConstraints()
        }
        
        // 내 활동
        [cardTitle, cardSaveButton, cardView].forEach() {
            $0.snp.removeConstraints()
        }
        
        // 도전
        [challengeTitle, challengeChartView, growthChartView].forEach() {
            $0.snp.removeConstraints()
        }
        
        // 정보
        [informationTitle, homeGymChartView, historyView].forEach() {
            $0.snp.removeConstraints()
        }
    }
    
    func setUpLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.bottom.equalTo(view.forLastBaselineLayout.snp_topMargin).offset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        logoView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(OrrPd.pd16.rawValue)
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            
            $0.height.greaterThanOrEqualTo(UIScreen.main.bounds.height + 100)
        }
        
        // 내 활동
        cardTitle.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        cardSaveButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.height.equalTo(cardTitle.snp.height)
        }
        
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(cardTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        // 도전
        challengeTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        challengeChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(challengeTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        growthChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(challengeChartView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        // 정보
        informationTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(growthChartView.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        homeGymChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(informationTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        historyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(homeGymChartView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        paddingView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(historyView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(OrrPd.pd72.rawValue)
        }
    }
    
    func refreshView() {
        // 내 정보 카드
        cardView.removeFromSuperview()
        
        let cardVC = UIHostingController(rootView: MyCardView(firstDate: firstDateOfClimbing, highestLevel: highestLevel, homeGymName: frequentlyVisitedGymList[0].0))
        cardVC.view.backgroundColor = .clear
        cardView = cardVC.view
        
        contentView.addSubview(cardView)
        
        // 도전 차트
        challengeChartView.removeFromSuperview()
        
        let challengeChartVC = UIHostingController(rootView: ChallengeChartView(chartData: ChartDataModel(dataModel: entireProblemsForChallengeChart), totalCount: validTotalCountForChallengeChart, successCount: validSuccessCountForChallengeChart))
        challengeChartVC.view.backgroundColor = .clear
        challengeChartView = challengeChartVC.view
        
        contentView.addSubview(challengeChartView)
        
        // 성장 차트
        growthChartView.removeFromSuperview()
        
        var mostFrequentLevelForPeriod: [Int] = [-1, -1, -1]
        mostFrequentLevelForPeriod[0] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[0])
        mostFrequentLevelForPeriod[1] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[1])
        mostFrequentLevelForPeriod[2] = getMostFrequentLevelOfList(from: entireSolvedProblemsForGrowthChart[2])
        
        let growthChartVC = UIHostingController(rootView: GrowthChartView(chartData: entireSolvedProblemsForGrowthChart, periodData: periodDataForGrowthChart, mostFrequentLevelForPeriod: mostFrequentLevelForPeriod))
        growthChartVC.view.backgroundColor = .clear
        growthChartView = growthChartVC.view
        
        contentView.addSubview(growthChartView)
        
        // 홈짐 차트
        homeGymChartView.removeFromSuperview()
        
        let homeGymChartVC = UIHostingController(rootView: HomeGymChartView(mostFrequentlyVisitedGymList: frequentlyVisitedGymList, totalGymVisitedDate: totalGymVisitedDate))
        homeGymChartVC.view.backgroundColor = .clear
        homeGymChartView = homeGymChartVC.view
        
        contentView.addSubview(homeGymChartView)
        
        // 경력 차트
        historyView.removeFromSuperview()
        
        let historyVC = UIHostingController(rootView: HistoryView(fromDate: firstDateOfClimbing, tapEditButton: editFirstDateOfClimbing))
        historyVC.view.backgroundColor = .clear
        historyView = historyVC.view
        
        contentView.addSubview(historyView)
        
        // 레이아웃 재배치
        removeLayout()
        setUpLayout()
    }
}


struct SolvedProblemsOfEachLevel: Identifiable {
    var id: String { name }
    
    let level: Int
    let name: String
    var problems: [SolvedProblemsOfEachPeriod]
}

struct SolvedProblemsOfEachPeriod: Identifiable {
    var id: String { periodName }
    
    let periodName: String
    var count: Int
}
