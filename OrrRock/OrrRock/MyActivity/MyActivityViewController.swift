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
    
    var firstDateForSummary: Date? = nil
    var highestLevelForSummary: Int = -1
    var mostVisitedGymNameForSummary: String = ""
    var mostVisitedGymCountForSummary: Int = 0
    
    
    var entireSolvedProblemsForBarChart: [[SolvedProblemsOfEachLevel]] = [[],[],[]]
    
    var entireProblemsForDonutChart: [ChartCellModel] = []
    var validTotalCountForDonutChart: Int = 0
    var validSuccessCountForDonutChart: Int = 0
    
    private lazy var DEBUGBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray300
        return view
    }()
    
    // 레이아웃
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .orrGray300
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .orrGray300
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 28, height: 24))
        button.setImage(UIImage(systemName: "square.and.arrow.down.fill"), for: .normal)
//            button.addTarget(self, action: T##Selector, for: .touchUpInside)
        return button
    }()
    
    private lazy var cardView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "CardLevel0"))
        return view
    }()
    
    // 도전
    private lazy var challengeTitle: UILabel = {
        let view = UILabel()
        view.text = "도전"
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    private lazy var challengeChartView: UIView = {
        let VC = UIHostingController(rootView: ChallengeChartView(chartData: ChartDataModel(dataModel: entireProblemsForDonutChart), totalCount: validTotalCountForDonutChart, successCount: validSuccessCountForDonutChart))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var growthChartView: UIView = {
        let VC = UIHostingController(rootView: GrowthChartView())
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
        let VC = UIHostingController(rootView: HomeGymChartView())
        return VC.view
    }()
    
    private lazy var historyView: UIView = {
        let VC = UIHostingController(rootView: HistoryView())
        return VC.view
    }()
    
    
//    private lazy var summaryView: UIView = {
//        let VC = UIHostingController(rootView: SummaryView(firstDate: firstDateForSummary, highestLevel: highestLevelForSummary, mostVisitedGymName: mostVisitedGymNameForSummary, mostVisitedGymCount: mostVisitedGymCountForSummary))
//        VC.view.backgroundColor = .clear
//        return VC.view
//    }()
    
//    private lazy var myChallengeChartView: UIView = {
//        let VC = UIHostingController(rootView: SolvedProblemsChartView(chartData: entireSolvedProblemsForBarChart))
//        VC.view.backgroundColor = .clear
//        return VC.view
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        setUpData()
        setUpLayout()
    }
    
    func setUpData() {
        let entireVideoInformationsByDate: [[VideoInformation]] = DataManager.shared.repository.sortVideoInformation(filterOption: .all, sortOption: .gymVisitDate)
        let entireVideoInformationsByName: [[VideoInformation]] = DataManager.shared.repository.sortVideoInformation(filterOption: .all, sortOption: .gymName)
        
        // summaryView
        (firstDateForSummary, highestLevelForSummary, (mostVisitedGymCountForSummary, mostVisitedGymNameForSummary)) = getSummaryData(fromDate: entireVideoInformationsByDate, fromName: entireVideoInformationsByName)
        
        // DonutChart
        (entireProblemsForDonutChart, validTotalCountForDonutChart, validSuccessCountForDonutChart) = getProblemsPerLevel(from: entireVideoInformationsByDate)
        
        // BarChart
        entireSolvedProblemsForBarChart[0] = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .week)
        entireSolvedProblemsForBarChart[1] = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .month)
        entireSolvedProblemsForBarChart[2] = getSolvedProblemsPerPeriod(from: entireVideoInformationsByDate, period: .year)
    }
    
    // 가장 처음 클라이밍장을 방문한 날짜, 혹은 사용자가 작성한 최초 클라이밍장 방문 날짜를 반환
    func getSummaryData(fromDate: [[VideoInformation]], fromName: [[VideoInformation]]) -> (Date?, Int, (Int, String)) {
        // 가장 처음 방문한 날짜를 반환, 기록이 없는 경우 nil 값을 반환
        // TODO: 사용자의 설정에 의한 값이 받아와질 수 있도록 이후 추가해야함
        let firstDate = fromDate.last?.first?.gymVisitDate ?? nil
        
        // 기록된 영상들의 정보 중 가장 높은 레벨을 반환
        // 이후 개선을 통해 UserDefault에 최고점에 대한 정보를 저장할 수 있도록 한다면 성능 최적화가 용이하다고 생각됨
        var highestLevel = -1
        let flatten = fromDate.flatMap { $0 }
        flatten.forEach { highestLevel = max(Int($0.problemLevel), highestLevel) }
        
        // 기록된 영상들의 정보 중 가장 많이 방문한 클라이밍장명을 반환
        // 이후 개선을 통해 UserDefault에 가장 많이 방문한 클라이밍장을 저장할 수 있도록 한다면 성능 최적화가 용이하다고 생각됨
        var (mostVisitedCount, mostVisitiedGymName): (Int, String) = (0, "")
        fromName.forEach { videoListOfEachGym in
            var visitedCount = 0
            var tempDate = Calendar.current.date(byAdding: .day, value: -1, to: firstDate!)
            
            videoListOfEachGym.forEach {
                if tempDate != $0.gymVisitDate {
                    visitedCount += 1
                    tempDate = $0.gymVisitDate
                }
            }
            
            if visitedCount > mostVisitedCount {
                mostVisitedCount = visitedCount
                mostVisitiedGymName = videoListOfEachGym.first?.gymName ?? ""
            }
        }
        
        return (firstDate, highestLevel, (mostVisitedCount, mostVisitiedGymName))
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
    func getSolvedProblemsPerPeriod(from: [[VideoInformation]], period: TimePeriodEnum) -> [SolvedProblemsOfEachLevel] {
        let timePeriodInterval: Int = {
            switch period {
            case .week:
                return 7
            case .month:
                return 28
            case .year:
                return 365
            }
        }()
        
        var result: [SolvedProblemsOfEachLevel] = []
        for level in 0...9 {
            result.append(SolvedProblemsOfEachLevel(name: "v\(level)", problems: []))
            for periodIndex in 0...5 {
                //
                result[level].problems.append(SolvedProblemsOfEachPeriod(periodName: periodIndex == 5 ? "이번 \(period.toString())" : "\(5 - periodIndex)\(period.toString()) 전", count: 0))
            }
        }
        
        // DateComponent Type의 경우에는 nil이 될 수 있으나, Date Type은 모든 값을 반드시 가지고 있기 때문에 nil이 되지 않아 강제 언래핑이 안전합니다!
        var lastDayOfThisPeriod: Date = Calendar.current.date(byAdding: .day, value: -timePeriodInterval, to: Date())!.timeToString().stringToDate()!
        var periodIndex: Int = 5
        
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
            
            // 차트에 포함되어야 하는 데이터이므로, Unit에 포함된 영상 데이터들 중 성공한 영상의 개수를 count 합니다.
            videoInformationUnit.forEach { videoInformation in
                if videoInformation.problemLevel >= 0 {
                    result[Int(videoInformation.problemLevel)].problems[periodIndex].count += videoInformation.isSucceeded ? 1 : 0
                }
            }
        }
        
        return result
    }
}

extension MyActivityViewController {
    func setUpLayout() {
        view.addSubview(DEBUGBackgroundView)
        DEBUGBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(OrrPd.pd16.rawValue)
            $0.top.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            
            $0.height.greaterThanOrEqualTo(UIScreen.main.bounds.height + 100)
        }
        
        // 내 활동
        contentView.addSubview(cardTitle)
        cardTitle.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        contentView.addSubview(cardSaveButton)
        cardSaveButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.height.equalTo(cardTitle.snp.height)
        }
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(cardTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        // 도전
        contentView.addSubview(challengeTitle)
        challengeTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(cardView.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        contentView.addSubview(challengeChartView)
        challengeChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(challengeTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        contentView.addSubview(growthChartView)
        growthChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(challengeChartView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        // 정보
        contentView.addSubview(informationTitle)
        informationTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(growthChartView.snp.bottom).offset(OrrPd.pd36.rawValue)
        }
        
        contentView.addSubview(homeGymChartView)
        homeGymChartView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(informationTitle.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        contentView.addSubview(historyView)
        historyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(homeGymChartView.snp.bottom).offset(OrrPd.pd16.rawValue)
        }
        
        contentView.addSubview(paddingView)
        paddingView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(historyView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(OrrPd.pd72.rawValue)
        }
    }
}


struct SolvedProblemsOfEachLevel: Identifiable {
    var id: String { name }
    
    let name: String
    var problems: [SolvedProblemsOfEachPeriod]
}

struct SolvedProblemsOfEachPeriod: Identifiable {
    var id: String { periodName }

    let periodName: String
    var count: Int
}
