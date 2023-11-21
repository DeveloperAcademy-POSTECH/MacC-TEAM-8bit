//
//  UnderlineSegmentedControl.swift
//  OrrRock
//
//  Created by 8Bit on 2022/11/24.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    override init(items: [Any]?) {
        super.init(items: items)
        self.removeBackgroundAndDivider()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var underlineView: UIView = {
        self.addSubview(underlineBaseView)
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let height = 3.0
        let xPosition = CGFloat(self.selectedSegmentIndex) * width
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .orrUPBlue
        self.addSubview(view)
        return view
    }()
    
    private lazy var underlineBaseView : UIView = {
        let width = self.bounds.size.width * 3
        let height = 3.0
        let xPosition = 0.0
        let yPosition = self.bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .orrGray200
        self.addSubview(view)
        return view
    }()
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
    
}
