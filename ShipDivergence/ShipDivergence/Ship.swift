//
//  Ship.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import UIKit

class Ship: UIImageView {

	let road: Road
	let speed: Double
	let radius: Double

	/// Текущая позиция корабля
	var currentPoint: Point = .init(x: 0, y: 0)

	init(road: Road, speed: Double, radius: Double) {
		self.road = road
		self.speed = speed
		self.radius = radius
		super.init(frame: .init(x: 0, y: 0, width: 18, height: 18))
		layer.cornerRadius = 9
		backgroundColor = .red

		self.currentPoint = self.road.start

		road.ship = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
