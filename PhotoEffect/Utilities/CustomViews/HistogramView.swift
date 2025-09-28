//
//  HistogramView.swift
//  PhotoEffect
//
//  Created by Berkay on 27.09.2025.
//

import UIKit

class HistogramView: UIView {
    
    private var redHistogram: [Int] = []
    private var greenHistogram: [Int] = []
    private var blueHistogram: [Int] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 8
    }
    
    func updateHistogram(red: [Int], green: [Int], blue: [Int]) {
        self.redHistogram = red
        self.greenHistogram = green
        self.blueHistogram = blue
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        guard redHistogram.count == 256 && greenHistogram.count == 256 && blueHistogram.count == 256 else {
            drawEmptyHistogram(in: rect, context: context)
            return
        }
        
        let normalizedRed = normalizeHistogram(redHistogram)
        let normalizedGreen = normalizeHistogram(greenHistogram)
        let normalizedBlue = normalizeHistogram(blueHistogram)
        
        let width = rect.width
        let height = rect.height
        let barWidth = width / 256.0
        
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(1.0)
        
        for i in 0..<256 {
            let x = CGFloat(i) * barWidth
            let barHeight = normalizedRed[i] * height
            let y = height - barHeight
            
            context.move(to: CGPoint(x: x, y: height))
            context.addLine(to: CGPoint(x: x, y: y))
        }
        context.strokePath()
        
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(1.0)
        
        for i in 0..<256 {
            let x = CGFloat(i) * barWidth
            let barHeight = normalizedGreen[i] * height
            let y = height - barHeight
            
            context.move(to: CGPoint(x: x, y: height))
            context.addLine(to: CGPoint(x: x, y: y))
        }
        context.strokePath()
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(1.0)
        
        for i in 0..<256 {
            let x = CGFloat(i) * barWidth
            let barHeight = normalizedBlue[i] * height
            let y = height - barHeight
            
            context.move(to: CGPoint(x: x, y: height))
            context.addLine(to: CGPoint(x: x, y: y))
        }
        context.strokePath()
        
        let title = "Histogram"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        let titleSize = title.size(withAttributes: attributes)
        let titleRect = CGRect(x: (width - titleSize.width) / 2, y: 4, width: titleSize.width, height: titleSize.height)
        title.draw(in: titleRect, withAttributes: attributes)
    }
    
    private func drawEmptyHistogram(in rect: CGRect, context: CGContext) {
        let title = "Histogram"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        let titleSize = title.size(withAttributes: attributes)
        let titleRect = CGRect(x: (rect.width - titleSize.width) / 2, y: 4, width: titleSize.width, height: titleSize.height)
        title.draw(in: titleRect, withAttributes: attributes)
        
        let noDataText = "No data"
        let noDataAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        let noDataSize = noDataText.size(withAttributes: noDataAttributes)
        let noDataRect = CGRect(x: (rect.width - noDataSize.width) / 2, y: rect.height / 2, width: noDataSize.width, height: noDataSize.height)
        noDataText.draw(in: noDataRect, withAttributes: noDataAttributes)
    }
    
    private func normalizeHistogram(_ histogram: [Int]) -> [CGFloat] {
        guard !histogram.isEmpty else { return [] }
        
        let maxValue = histogram.max() ?? 1
        return histogram.map { CGFloat($0) / CGFloat(maxValue) }
    }
}
