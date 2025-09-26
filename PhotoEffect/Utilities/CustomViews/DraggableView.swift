//
//  DraggableView.swift
//  PhotoEffect
//
//  Created by Berkay on 26.09.2025.
//

import UIKit

final class DraggableView: UIView {
    
    var overlayItem: Overlay?
    
    lazy var draggableImageView: UIImageView = {
        let draggableImageView = UIImageView()
        draggableImageView.frame = self.bounds
        draggableImageView.backgroundColor = .clear
        draggableImageView.alpha = 0.5
        return draggableImageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let item = self.overlayItem else { return }
        guard let image = item.downloadedImage else { return }
        self.draggableImageView.image = image
    }
    
    func setupViews(overlayItem: Overlay?) {
        self.overlayItem = overlayItem
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(imageViewTapped))
        panGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(panGestureRecognizer)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        self.addGestureRecognizer(pinchGesture)
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        self.addSubview(draggableImageView)
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1.0
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc private func imageViewTapped(gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }

        switch gesture.state {
        case .began:
            let translation = gesture.translation(in: superview)
            let newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            self.center = newCenter
            gesture.setTranslation(.zero, in: superview)
        case .changed:
            let translation = gesture.translation(in: superview)
            let newCenter = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            self.center = newCenter
            gesture.setTranslation(.zero, in: superview)
        case .ended:
            let velocity = gesture.velocity(in: superview)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            let slideFactor = 0.1 * slideMultiplier
            var finalPoint = CGPoint(x: self.center.x + (velocity.x * slideFactor),
                                     y: self.center.y + (velocity.y * slideFactor))
            finalPoint.x = min(max(finalPoint.x, 0), superview.bounds.width)
            finalPoint.y = min(max(finalPoint.y, 0), superview.bounds.height - 100)

            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           options: [.curveEaseOut, .allowUserInteraction],
                           animations: {
                               self.center = finalPoint
                           },
                           completion: nil)
        default:
            break
        }
    }
}

extension DraggableView: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
    return true
  }
}
