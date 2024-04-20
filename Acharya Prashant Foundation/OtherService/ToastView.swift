//
//  ToastView.swift
//  Acharya Prashant Foundation
//
//  Created by Ashok Singh on 20/04/24.
//

import UIKit

import UIKit

class ToastView: UIView {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    init(message: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.1333333333, blue: 0.2549019608, alpha: 1)
        layer.cornerRadius = 12

        setupView()
        messageLabel.text = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

extension UIView {
    static func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastView = ToastView(message: message)
        toastView.tag = 10055
        toastView.alpha = 0.0
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.viewWithTag(10055)?.removeFromSuperview()
                toastView.center = window.center
                window.addSubview(toastView)
                
                NSLayoutConstraint.activate([
                    toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                    toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
                    toastView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -40)
                ])

            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: { [weak toastView] in
            toastView?.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: [.curveEaseInOut], animations: { [weak toastView] in
                toastView?.alpha = 0.0
            }, completion: { [weak toastView] _ in
                toastView?.removeFromSuperview()
            })
        }
    }
}
