//
//  dailyWeatherStackView.swift
//  LeBaluchon
//
//  Created by laz on 03/11/2022.
//

import UIKit

class DailyWeatherStackView: UIStackView {

    init(day: Date, temp: Double, icon: String) {
        super.init(frame: CGRect.zero)

        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 3

        let dayLabel = UILabel()
        dayLabel.textAlignment = .center
        dayLabel.adjustsFontSizeToFitWidth = true

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E d"

        dayLabel.text = dateFormatter.string(from: day)

        let iconImage = UIImageView()
        iconImage.contentMode = .scaleAspectFit
        iconImage.tintColor = .white
        iconImage.image = UIImage(systemName: icon)

        let tempLabel = UILabel()
        tempLabel.textAlignment = .center
        tempLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String(format: "%.0f℃", temp)

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
