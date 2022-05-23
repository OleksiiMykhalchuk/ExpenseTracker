//
//  BackgroundView.swift
//  ExpenseTracker
//
//  Created by Oleksii Mykhalchuk on 5/3/22.
//

import UIKit

class BackgroundView: UIView {
  private let curveOffset: CGFloat = 50
  private let viewDevider: CGFloat = 3
  private let colors: [Color] = [
    Color(UIColor(white: 1.0, alpha: 0.1)),
    Color(UIColor(white: 1.0, alpha: 0.0)),
    Color(UIColor(red: 0.259, green: 0.587, blue: 0.564, alpha: 1)),
    Color(UIColor(red: 0.167, green: 0.488, blue: 0.464, alpha: 1))]
  private struct Color {
    let color: UIColor?
    init(_ color: UIColor) {
      self.color = color
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .clear
  }
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .clear
  }
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    drawSquare(in: rect, in: context, with: colorSpace)
    drawCurve(in: rect, in: context, with: colorSpace)
    drawCircle(in: rect, in: context, with: colorSpace)
  }
  // MARK: - Private
  private func drawGradient(in rect: CGRect, in context: CGContext, with colorSpace: CGColorSpace) {
    let color1 = colors[2].color!
    let color2 = colors[3].color!
    let colors = [color1.cgColor, color2.cgColor]
    let locations: [CGFloat] = [0, 1]
    let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: locations)
    let startPoint = CGPoint(x: rect.origin.x, y: rect.size.height)
    let endPoint = CGPoint(x: rect.size.width, y: rect.size.height)
    context.drawLinearGradient(
      gradient!,
      start: startPoint,
      end: endPoint,
      options: [])
  }
  private func drawSquare(in rect: CGRect, in context: CGContext, with colorSpace: CGColorSpace) {
    context.saveGState()
    defer { context.restoreGState() }
    let path = CGMutablePath()
    path.move(
      to: rect.origin,
      transform: .identity)
    path.addRect(CGRect(
      x: rect.origin.x,
      y: rect.origin.y,
      width: rect.size.width,
      height: rect.size.height / viewDevider))
    path.closeSubpath()
    context.addPath(path)
    context.clip()
    drawGradient(in: rect, in: context, with: colorSpace)
  }
  private func drawCurve(in rect: CGRect, in context: CGContext, with colorSpace: CGColorSpace?) {
    context.saveGState()
    defer { context.restoreGState() }
    let color1 = colors[2].color!
    let color2 = colors[3].color!
    let colors = [color1.cgColor, color2.cgColor]
    let locations: [CGFloat] = [0, 1]
    let gradient = CGGradient.init(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: locations)
    let startPoint = CGPoint(
      x: rect.origin.x,
      y: rect.size.height / viewDevider)
    let endPoint = CGPoint(
      x: rect.size.width,
      y: rect.size.height / viewDevider)
    context.saveGState()
    defer { context.restoreGState() }
    let path = CGMutablePath()
    path.move(
      to: CGPoint(x: 0, y: rect.size.height / viewDevider),
      transform: .identity)
    path.addQuadCurve(
      to: CGPoint(x: rect.size.width, y: rect.size.height / viewDevider),
      control: CGPoint(x: rect.size.width / 2, y: rect.size.height / viewDevider + curveOffset),
      transform: .identity)
    path.closeSubpath()
    context.addPath(path)
    context.clip()
    context.drawLinearGradient(
      gradient!,
      start: startPoint,
      end: endPoint,
      options: [])
    context.setStrokeColor(UIColor.black.cgColor)
    context.strokePath()
  }
  private func drawCircle(in rect: CGRect, in context: CGContext, with colorSpace: CGColorSpace) {
    let color1 = colors[0].color!
    let color2 = colors[1].color!
    let colors = [color1.cgColor, color2.cgColor]
    let locations: [CGFloat] = [0, 1]
    let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: locations)
    let startPoint = CGPoint(x: rect.origin.x + rect.size.height / 15, y: rect.origin.y)
    let endPoint = CGPoint(x: rect.size.height / 2.6, y: rect.origin.y)
    context.saveGState()
    defer { context.restoreGState() }
    let path = CGMutablePath()
    path.move(to: CGPoint(
      x: rect.origin.x,
      y: rect.origin.y),
              transform: .identity)
    path.addEllipse(in: CGRect(
      x: rect.origin.x + rect.size.height / 12.8,
      y: rect.origin.y,
      width: rect.size.height / 5.6,
      height: rect.size.height / 5.6),
                    transform: .identity)
    path.addEllipse(in: CGRect(
      x: rect.origin.x + rect.size.height / 6,
      y: rect.origin.y - 50,
      width: rect.size.height / 6.9,
      height: rect.size.height / 6.9),
                    transform: .identity)
    path.closeSubpath()
    context.setLineWidth(rect.size.height / 74.66)
    context.addPath(path)
    context.replacePathWithStrokedPath()
    context.clip()
    context.drawLinearGradient(
      gradient!,
      start: startPoint,
      end: endPoint,
      options: [])
    context.strokePath()
  }
}
