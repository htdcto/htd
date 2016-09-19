//
//  YAxisRenderer.swift
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

@objc(ChartYAxisRenderer)
open class YAxisRenderer: AxisRendererBase
{
    public init(viewPortHandler: ViewPortHandler?, yAxis: YAxis?, transformer: Transformer?)
    {
        super.init(viewPortHandler: viewPortHandler, transformer: transformer, axis: yAxis)
    }
    
    /// draws the y-axis labels to the screen
    open override func renderAxisLabels(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        if (!yAxis.isEnabled || !yAxis.isDrawLabelsEnabled)
        {
            return
        }
        
        let xoffset = yAxis.xOffset
        let yoffset = yAxis.labelFont.lineHeight / 2.5 + yAxis.yOffset
        
        let dependency = yAxis.axisDependency
        let labelPosition = yAxis.labelPosition
        
        var xPos = CGFloat(0.0)
        
        var textAlign: NSTextAlignment
        
        if (dependency == .left)
        {
            if (labelPosition == .outsideChart)
            {
                textAlign = .right
                xPos = viewPortHandler.offsetLeft - xoffset
            }
            else
            {
                textAlign = .left
                xPos = viewPortHandler.offsetLeft + xoffset
            }
            
        }
        else
        {
            if (labelPosition == .outsideChart)
            {
                textAlign = .left
                xPos = viewPortHandler.contentRight + xoffset
            }
            else
            {
                textAlign = .right
                xPos = viewPortHandler.contentRight - xoffset
            }
        }
        
        drawYLabels(
            context: context,
            fixedPosition: xPos,
            positions: transformedPositions(),
            offset: yoffset - yAxis.labelFont.lineHeight,
            textAlign: textAlign)
    }
    
    fileprivate var _axisLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open override func renderAxisLine(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis,
            let viewPortHandler = self.viewPortHandler
            else { return }
        
        if (!yAxis.isEnabled || !yAxis.drawAxisLineEnabled)
        {
            return
        }
        
        context.saveGState()
        
        context.setStrokeColor(yAxis.axisLineColor.cgColor)
        context.setLineWidth(yAxis.axisLineWidth)
        if (yAxis.axisLineDashLengths != nil)
        {
            CGContextSetLineDash(context, yAxis.axisLineDashPhase, yAxis.axisLineDashLengths, yAxis.axisLineDashLengths.count)
        }
        else
        {
            CGContextSetLineDash(context, 0.0, nil, 0)
        }
        
        if (yAxis.axisDependency == .left)
        {
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentTop
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentLeft
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
            CGContextStrokeLineSegments(context, _axisLineSegmentsBuffer, 2)
        }
        else
        {
            _axisLineSegmentsBuffer[0].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[0].y = viewPortHandler.contentTop
            _axisLineSegmentsBuffer[1].x = viewPortHandler.contentRight
            _axisLineSegmentsBuffer[1].y = viewPortHandler.contentBottom
            CGContextStrokeLineSegments(context, _axisLineSegmentsBuffer, 2)
        }
        
        context.restoreGState()
    }
    
    /// draws the y-labels on the specified x-position
    internal func drawYLabels(
        context: CGContext,
                fixedPosition: CGFloat,
                positions: [CGPoint],
                offset: CGFloat,
                textAlign: NSTextAlignment)
    {
        guard let
            yAxis = self.axis as? YAxis
            else { return }
        
        let labelFont = yAxis.labelFont
        let labelTextColor = yAxis.labelTextColor
        
        for i in 0 ..< yAxis.entryCount
        {
            let text = yAxis.getFormattedLabel(i)
            
            if (!yAxis.isDrawTopYLabelEntryEnabled && i >= yAxis.entryCount - 1)
            {
                break
            }
            
            ChartUtils.drawText(
                context: context,
                text: text,
                point: CGPoint(x: fixedPosition, y: positions[i].y + offset),
                align: textAlign,
                attributes: [NSFontAttributeName: labelFont, NSForegroundColorAttributeName: labelTextColor])
        }
    }
    
    open override func renderGridLines(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis
            else { return }
        
        if !yAxis.isEnabled
        {
            return
        }
        
        if yAxis.drawGridLinesEnabled
        {
            let positions = transformedPositions()
            
            context.saveGState()
            defer { context.restoreGState() }
            context.clip(to: self.gridClippingRect)
            
            context.setShouldAntialias(yAxis.gridAntialiasEnabled)
            context.setStrokeColor(yAxis.gridColor.cgColor)
            context.setLineWidth(yAxis.gridLineWidth)
            context.setLineCap(yAxis.gridLineCap)
            
            if (yAxis.gridLineDashLengths != nil)
            {
                CGContextSetLineDash(context, yAxis.gridLineDashPhase, yAxis.gridLineDashLengths, yAxis.gridLineDashLengths.count)
            }
            else
            {
                CGContextSetLineDash(context, 0.0, nil, 0)
            }
            
            // draw the grid
            for i in 0 ..< positions.count
            {
                drawGridLine(context: context, position: positions[i])
            }
        }

        if yAxis.drawZeroLineEnabled
        {
            // draw zero line
            drawZeroLine(context: context);
        }
    }
    
    open var gridClippingRect: CGRect
    {
        var contentRect = viewPortHandler?.contentRect ?? CGRect.zero
        contentRect.insetInPlace(dx: 0.0, dy: -(self.axis?.gridLineWidth ?? 0.0) / 2.0)
        return contentRect
    }
    
    fileprivate var _gridLineBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open func drawGridLine(
        context: CGContext,
                position: CGPoint)
    {
        guard let
            viewPortHandler = self.viewPortHandler
            else { return }
        
        _gridLineBuffer[0].x = viewPortHandler.contentLeft
        _gridLineBuffer[0].y = position.y
        _gridLineBuffer[1].x = viewPortHandler.contentRight
        _gridLineBuffer[1].y = position.y
        
        CGContextStrokeLineSegments(context, _gridLineBuffer, 2)
    }
    
    open func transformedPositions() -> [CGPoint]
    {
        guard let
            yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return [CGPoint]() }
        
        var positions = [CGPoint]()
        positions.reserveCapacity(yAxis.entryCount)
        
        let entries = yAxis.entries
        
        for i in stride(from: 0, to: yAxis.entryCount, by: 1)
        {
            positions.append(CGPoint(x: 0.0, y: entries[i]))
        }

        transformer.pointValuesToPixel(&positions)
        
        return positions
    }

    /// Draws the zero line at the specified position.
    open func drawZeroLine(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis,
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer,
            let zeroLineColor = yAxis.zeroLineColor
            else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        var clippingRect = viewPortHandler.contentRect
        clippingRect.insetInPlace(dx: 0.0, dy: yAxis.zeroLineWidth / 2.0)
        context.clip(to: clippingRect)
        
        context.setStrokeColor(zeroLineColor.cgColor)
        context.setLineWidth(yAxis.zeroLineWidth)
        
        let pos = transformer.pixelForValues(x: 0.0, y: 0.0)
    
        if yAxis.zeroLineDashLengths != nil
        {
            CGContextSetLineDash(context, yAxis.zeroLineDashPhase, yAxis.zeroLineDashLengths!, yAxis.zeroLineDashLengths!.count)
        }
        else
        {
            CGContextSetLineDash(context, 0.0, nil, 0)
        }
        
        context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: pos.y - 1.0))
        context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y: pos.y - 1.0))
        context.drawPath(using: CGPathDrawingMode.stroke)
    }
    
    fileprivate var _limitLineSegmentsBuffer = [CGPoint](repeating: CGPoint(), count: 2)
    
    open override func renderLimitLines(context: CGContext)
    {
        guard let
            yAxis = self.axis as? YAxis,
            let viewPortHandler = self.viewPortHandler,
            let transformer = self.transformer
            else { return }
        
        var limitLines = yAxis.limitLines
        
        if (limitLines.count == 0)
        {
            return
        }
        
        context.saveGState()
        
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
        
        context.restoreGState()
    }
}
