//
//  dailyWeatherStackView.swift
//  LeBaluchon
//
//  Created by laz on 03/11/2022.
//

import UIKit

class DailyWeatherStackView: UIStackView {
    
    init(day: String, temp: String, icon: String) {
        super.init(frame: CGRect.zero)
        
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 3
        backgroundColor = .cyan
        
        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.text = day
        
        let iconImage = UIImageView()
        iconImage.contentMode = .scaleAspectFit
        iconImage.image = UIImage(systemName: icon)
        
        let tempLabel = UILabel()
        tempLabel.textAlignment = .center
        tempLabel.text = temp
        
        dayLabel.backgroundColor = .magenta
        iconImage.backgroundColor = .brown
        tempLabel.backgroundColor = .green
        
        addArrangedSubview(dayLabel)
        addArrangedSubview(iconImage)
        addArrangedSubview(tempLabel)
        
        iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor, multiplier: 1).isActive = true
        tempLabel.heightAnchor.constraint(equalTo: dayLabel.heightAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
