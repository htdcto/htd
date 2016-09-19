//
//  XAxisRendererHorizontalBarChart.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

#if !os(OSX)
    import UIKit
#endif

open class XAxisRendererHorizontalBarChart: XAxisRenderer
{
    internal var chart: BarChartView?
    
    public init(viewPortHandler: ViewPortHandler?, xAxis: XAxis?, transformer: Transformer?, chart: BarChartView?)
    {
        super.init(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: transformer)
        
        self.chart = chart
    }
    
    open override func computeAxis(min: Double, max: Double, inverted: Bool)
    {
        guard let
            viewPortHandler = self.viewPortHandler
            else { return }
        
        var min = min, max = max
        
        if let transformer = self.transformer
        {
            // calculate the starting and entry point of the y-labels (depending on
            // zoom / contentrect bounds)
            if viewPortHandler.contentWidth > 10 && !viewPortHandler.isFullyZoomedOutX
            {
                let p1 = transformer.valueForTouchPoint(CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentBottom))
                let p2 = transformer.valueForTouchPoint(CGPoint(x: viewPortHandler.contentLeft, y: viewPortHandler.contentTop))
                
                if inverted
                {
                    min = Double(p2.y)
                    max = Double(p1.y)
                }
                else
                {
                    min = Double(p1.y)
                    max = Double(p2.y)
                }
            }
        }
        
        computeAxisValues(min: min, max: max);
    }
    
    open override func computeSize()
    {
        guard let
            xAxis = self.axis as? XAxis
            else { return }
       
        let longest = xAxis.getLongestLabel() as NSString
        
        let labelSize = longest.size(attributes: [NSFontAttributeName: xAxis.labelFont])
        
        let labelWidth = floor(labelSize.width + xAxis.xOffset * 3.5)
        let labelHeight = labelSize.height
        
        let labelRotatedSize = ChartUtils.sizeOfRotatedRectangle(rectangleWidth: labelSize.width, rectangleHeight:  labelHeight, degrees: xAxis.labelRotationAngle)
        
        xAxis.labelWidth = labelWidth
        xAxis.labelHeight = labelHeight
        xAxis.labelRotatedWidth = round(labelRotatedSize.width + xAxis.xOffset * 3.5)
        xAxis.labelRotatedHeight = round(labelRotatedSize.height)
    }

    open override func renderAxisLabels(context: CGContext)
    {
        guard let
            xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        if !xAxis.isEnabled || !xAxis.isDrawLabelsEnabled || chart?.data === nil
        {
            return
        }
        
        let xoffset = xAxis.xOffset
        
        if (xAxis.labelPosition == .top)
        {
            drawLabels(context: context, pos: viewPortHandler.contentRight + xoffset, anchor: CGPoint(x: 0.0, y: 0.5))
        }
        else if (xAxis.labelPosition == .topInside)
        {
            drawLabels(context: context, pos: viewPortHandler.contentRight - xoffset, anchor: CGPoint(x: 1.0, y: 0.5))
        }
        else if (xAxis.labelPosition == .bottom)
        {
            drawLabels(context: context, pos: viewPortHandler.contentLeft - xoffset, anchor: CGPoint(x: 1.0, y: 0.5))
        }
        else if (xAxis.labelPosition == .bottomInside)
        {
            drawLabels(context: context, pos: viewPortHandler.contentLeft + xoffset, anchor: CGPoint(x: 0.0, y: 0.5))
        }
        else
        { // BOTH SIDED
            drawLabels(context: context, pos: viewPortHandler.contentRight + xoffset, anchor: CGPoint(x: 0.0, y: 0.5))
            drawLabels(context: context, pos: viewPortHandler.contentLeft - xoffset, anchor: CGPoint(x: 1.0, y: 0.5))
        }
    }

    /// draws the x-labels on the specified y-position
    open override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint)
    {
        guard let
            xAxis = self.axis as? XAxis,
            let transformer = self.transformer,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        let labelFont = xAxis.labelFont
        let labelTextColor = xAxis.labelTextColor
        let labelRotationAngleRadians = xAxis.labelRotationAngle * ChartUtils.Math.FDEG2RAD
        
        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
        
        // pre allocate to save performance (dont allocate in loop)
        var position = CGPoint(x: 0.0, y: 0.0)
        
        for i in stride(from: 0, to: xAxis.entryCount, by: 1)
        {
            // only fill x values
            
            position.x = 0.0
            
            if centeringEnabled
            {
                position.y = CGFloat(xAxis.centeredEntries[i])
            }
            else
            {
                position.y = CGFloat(xAxis.entries[i])
            }
            
            transformer.pointValueToPixel(&position)
            
            if viewPortHandler.isInBoundsY(position.y)
            {
                if let label = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis)
                {
                    drawLabel(
                        context: context,
                        formattedLabel: label,
                        x: pos,
                        y: position.y,
                        attributes: [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelTextColor],
                        anchor: anchor,
                        angleRadians: labelRotationAngleRadians)
                }
            }
        }
    }
    
    open func drawLabel(
        context: CGContext,
                formattedLabel: String,
                x: CGFloat,
                y: CGFloat,
                attributes: [String: NSObject],
                anchor: CGPoint,
                angleRadians: CGFloat)
    {
        ChartUtils.drawText(
            context: context,
            text: formattedLabel,
            point: CGPoint(x: x, y: y),
            attributes: attributes,
            anchor: anchor,
            angleRadians: angleRadians)
    }
    
    open override var gridClippingRect: CGRect
    {
        var contentRect = viewPortHandler?.contentRect ?? CGRect.zero
        contentRect.insetInPlace(dx: 0.0, dy: -(self.axis?.gridLineWidth ?? 0.0) / 2.0)
        return contentRect
    }
    
    fileprivate var _gridLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open override func drawGridLine(context: CGContext, x: CGFloat, y: CGFloat)
    {
        guard let
            viewPortHandler = self.viewPortHandler
            else { return }
        
        if viewPortHandler.isInBoundsY(y)
        {
            _gridLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _gridLineSegmentsBuffer[0].y = y
            _gridLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _gridLineSegmentsBuffer[1].y = y
            CGContextStrokeLineSegments(context, _gridLineSegmentsBuffer, 2)
        }
    }
    
    fileprivate var _axisLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open override func renderAxisLine(context: CGContext)
    {
        guard let
            xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        if (!xAxis.isEnabled || !xAxis.isDrawAxisLineEnabled)
        {
            return
        }
        
        context.saveGState()
        
        context.setStrokeColor(xAxis.axisLineColor.cgColor)
        context.setLineWidth(xAxis.axisLineWidth)
        if (xAxis.axisLineDashLengths != nil)
        {
            CGContextSetLineDash(context, xAxis.axisLineDashPhase, xAxis.axisLineDashLengths, xAxis.axisLineDashLengths.count)
        }
        else
        {
            CGContextSetLineDash(context, 0.0, nil, 0)
        }
        
        if (xAxis.labelPosition == .top
            || xAxis.labelPosition == .topInside
            || xAxis.labelPosition == .bothSided)
        {
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentTop
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
            CGContextStrokeLineSegments(context, _axisLineSegmentsBuffer, 2)
        }
        
        if (xAxis.labelPosition == .bottom
            || xAxis.labelPosition == .bottomInside
            || xAxis.labelPosition == .bothSided)
        {
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentTop
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
            CGContextStrokeLineSegments(context, _axisLineSegmentsBuffer, 2)
        }
        
        context.restoreGState()
    }
    
    fileprivate var _limitLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open override func renderLimitLines(context: CGContext)
    {
        guard let
            xAxis = self.axis as? XAxis,
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer
            else { return }
        
        var limitLines = xAxis.limitLines
        
        if (limitLines.count == 0)
        {
            return
        }
        
        let trans = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        for i in 0 ..< limitLines.count
        {
            let l = limitLines[i]
            
            if !l.isEnabled
            {
                continue
            }
            
            context.saveGState()
            defer { context.restoreGState() }
            var clippingRect = viewPortHandler.contentRect
            clippingRect.insetInPlace(dx: 0.0, dy: -l.lineWidth / 2.0)
            context.clip(to: clippingRect)

            position.x = 0.0
            position.y = CGFloat(l.limit)
            position = position.applying(trans)
            
            _limitLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _limitLineSegmentsBuffer[0].y = position.y
            _limitLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _limitLineSegmentsBuffer[1].y = position.y
            
            context.setStrokeColor(l.lineColor.cgColor)
            context.setLineWidth(l.lineWidth)
            if (l.lineDashLengths != nil)
            {
                CGContextSetLineDash(context, l.lineDashPhase, l.lineDashLengths!, l.lineDashLengths!.count)
            }
            else
            {
                CGContextSetLineDash(context, 0.0, nil, 0)
            }
            
            CGContextStrokeLineSegments(context, _limitLineSegmentsBuffer, 2)
            
            let label = l.label
            
            // if drawing the limit-value label is enabled
            if (l.drawLabelEnabled && label.characters.count > 0)
            {
                let labelLineHeight = l.valueFont.lineHeight
                
                let xOffset: CGFloat = 4.0 + l.xOffset
                let yOffset: CGFloat = l.lineWidth + labelLineHeight + l.yOffset
                
                if (l.labelPosition == .rightTop)
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y - yOffset),
                        align: .right,
                        attributes: [NSFontAttributeName: l.valueFont, NSForegroundColorAttributeName: l.valueTextColor])
                }
                else if (l.labelPosition == .rightBottom)
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentRight - xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .right,
                        attributes: [NSFontAttributeName: l.valueFont, NSForegroundColorAttributeName: l.valueTextColor])
                }
                else if (l.labelPosition == .leftTop)
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y - yOffset),
                        align: .left,
                        attributes: [NSFontAttributeName: l.valueFont, NSForegroundColorAttributeName: l.valueTextColor])
                }
                else
                {
                    ChartUtils.drawText(context: context,
                        text: label,
                        point: CGPoint(
                            x: viewPortHandler.contentLeft + xOffset,
                            y: position.y + yOffset - labelLineHeight),
                        align: .left,
                        attributes: [NSFontAttributeName: l.valueFont, NSForegroundColorAttributeName: l.valueTextColor])
                }
            }
        }
    }
}
