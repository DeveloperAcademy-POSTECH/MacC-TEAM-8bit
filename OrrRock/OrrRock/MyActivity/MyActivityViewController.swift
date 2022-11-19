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
    
    var entireSolvedProblemsForBarChart: [[SolvedProblemsOfEachLevel]] = [[],[],[]]
    var entireProblemsForDonutChart: [ChartCellModel] = []
    var validTotalCountForDonutChart: Int = 0
    var validSuccessCountForDonutChart: Int = 0
    
    private lazy var DEBUGBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .orrGray2
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .orrGray2
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .orrGray2
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private lazy var summaryView: UIView = {
        let VC = UIHostingController(rootView: SummaryView())
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var challengeChartView: UIView = {
        let VC = UIHostingController(rootView: ChallengeChartView(chartData: ChartDataModel(dataModel: entireProblemsForDonutChart), totalCount: validTotalCountForDonutChart, successCount: validSuccessCountForDonutChart))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var solvedProblemsChartView: UIView = {
        let VC = UIHostingController(rootView: SolvedProblemsChartView(chartData: entireSolvedProblemsForBarChart))
        VC.view.backgroundColor = .clear
        return VC.view
    }()
    
    private lazy var paddingView: UIView = {
        return UIView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let entireVideoInformations: [[VideoInformation]] = DataManager.shared.repository.sortVideoInformation(filterOption: .all, sortOption: .gymVisitDate)
        
        // DonutChart
        (entireProblemsForDonutChart, validTotalCountForDonutChart, validSuccessCountForDonutChart) = getProblemsPerLevel(from: entireVideoInformations)
        
        // BarChart
        entireSolvedProblemsForBarChart[0] = getSolvedProblemsPerPeriod(from: entireVideoInformations, period: .week)
        entireSolvedProblemsForBarChart[1] = getSolvedProblemsPerPeriod(from: entireVideoInformations, period: .month)
        entireSolvedProblemsForBarChart[2] = getSolvedProblemsPerPeriod(from: entireVideoInformations, period: .year)
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
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.centerX.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            
            $0.height.greaterThanOrEqualTo(UIScreen.main.bounds.height + 100)
        }
        
        contentView.addSubview(summaryView)
        summaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(contentView)
        }
        
        contentView.addSubview(challengeChartView)
        challengeChartView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(summaryView.snp.bottom).offset(16)
        }
        
        contentView.addSubview(solvedProblemsChartView)
        solvedProblemsChartView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(challengeChartView.snp.bottom).offset(16)
        }
        
        contentView.addSubview(paddingView)
        paddingView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(solvedProblemsChartView.snp.bottom)
            $0.bottom.equalToSuperview()
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
