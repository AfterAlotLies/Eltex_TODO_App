//
//  SnakePageControl.swift
//  Eltex_Project
//
//  Created by Vyacheslav Gusev on 19.12.2024.
//

import UIKit

class SnakePageControl: UIView {
    
    var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    
    var progress: CGFloat = 0 {
        didSet {
            layoutActivePageIndicator(progress)
        }
    }
    
    var currentPage: Int {
        return Int(round(progress))
    }
    
    // MARK: - Appearance
    var activeTint: UIColor = .white {
        didSet {
            activeLayer.backgroundColor = activeTint.cgColor
        }
    }
    var inactiveTint: UIColor = .white {
        didSet {
            inactiveLayers.forEach() { $0.backgroundColor = inactiveTint.cgColor }
        }
    }
    var indicatorPadding: CGFloat = 30 {
        didSet {
            layoutInactivePageIndicators(inactiveLayers)
            layoutActivePageIndicator(progress)
            self.invalidateIntrinsicContentSize()
        }
    }
    var indicatorRadius: CGFloat = 5 {
        didSet {
            layoutInactivePageIndicators(inactiveLayers)
            layoutActivePageIndicator(progress)
            self.invalidateIntrinsicContentSize()
        }
    }
    
    fileprivate var indicatorDiameter: CGFloat {
        return indicatorRadius * 1.5
    }
    
    fileprivate var inactiveLayers = [CALayer]()
    
    fileprivate lazy var activeLayer: CALayer = { [unowned self] in
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.indicatorDiameter,
                                          height: self.indicatorDiameter))
        layer.backgroundColor = self.activeTint.cgColor
        layer.cornerRadius = self.indicatorRadius
        return layer
    }()
    
    
    // MARK: - State Update
    
    fileprivate func updateNumberOfPages(_ count: Int) {
        guard count != inactiveLayers.count else { return }
        inactiveLayers.forEach() { $0.removeFromSuperlayer() }
        inactiveLayers = [CALayer]()
        inactiveLayers = stride(from: 0, to:count, by:1).map() { _ in
            let layer = CALayer()
            layer.backgroundColor = self.inactiveTint.cgColor
            self.layer.addSublayer(layer)
            return layer
        }
        layoutInactivePageIndicators(inactiveLayers)
        self.layer.addSublayer(activeLayer)
        layoutActivePageIndicator(progress)
        self.invalidateIntrinsicContentSize()
    }
    
// MARK: - Layout
    fileprivate func layoutActivePageIndicator(_ progress: CGFloat) {
        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else { return }
        let denormalizedProgress = progress * (indicatorDiameter + indicatorPadding)
        let distanceFromPage = abs(round(progress) - progress)
        let width = indicatorDiameter * 4
        + indicatorPadding * (distanceFromPage * 2)
        var newFrame = CGRect(x: 0,
                              y: activeLayer.frame.origin.y,
                              width: width,
                              height: indicatorDiameter)
        newFrame.origin.x = denormalizedProgress
        activeLayer.cornerRadius = indicatorRadius
        activeLayer.frame = newFrame
    }
    
    fileprivate func layoutInactivePageIndicators(_ layers: [CALayer]) {
        var layerFrame = CGRect(x: 0, y: 0, width: indicatorDiameter * 4, height: indicatorDiameter)
        layers.forEach() { layer in
            layer.cornerRadius = indicatorRadius
            layer.frame = layerFrame
            layerFrame.origin.x += indicatorDiameter + indicatorPadding
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactiveLayers.count) * indicatorDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding,
                      height: indicatorDiameter)
    }
    
}
