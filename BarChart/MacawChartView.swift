//
//  MacawCharView.swift
//  BarChart
//
//  Created by MacSpace on 2/26/20.
//  Copyright © 2020 Brahua. All rights reserved.
//

import Foundation
import Macaw

class MacawChartView: MacawView {
    
    static let lastFiveShows            = createDummyData()
    static let maxValue                 = 6000
    static let maxValueLineHeight       = 180
    static let lineWidth: Double        = 275
    static let dataDivisor              = Double(maxValue/maxValueLineHeight)
    static let adjustedData: [Double]   = lastFiveShows.map({ $0.budget / dataDivisor})
    static var animations: [Animation]  = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItems() -> [Node] {
        let maxLines            = 6
        let lineInterval        = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine   = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            let valueText   = Text(text: "\(i*lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill  = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = (Double(i)*50)
            
            let valueText = Text(text: lastFiveShows[i-1].month, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.white
            
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    private static func createBars() -> Group {
        let fill    = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items   = adjustedData.map{_ in Group()}
        
        animations = items.enumerated().map{ (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height  = adjustedData[i] * t
                let rect    = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    private static func createDummyData() -> [Budget] {
        let one     = Budget(month: "1", budget: 3200)
        let two     = Budget(month: "2", budget: 4200)
        let three   = Budget(month: "3", budget: 5200)
        let four    = Budget(month: "4", budget: 3800)
        let five    = Budget(month: "5", budget: 3990)
        
        return [one, two, three, four, five]
    }
}
