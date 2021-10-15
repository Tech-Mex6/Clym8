//
//  CurrentLocationButton.swift
//  Clym8
//
//  Created by meekam okeke on 6/24/21.
//

import UIKit

class CurrentLocationButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .regular, scale: .small)
        let locationImage = UIImage(systemName: "location.circle.fill", withConfiguration: config)
        setBackgroundImage(locationImage, for: .normal)
        tintColor = .black
    }
}
    
