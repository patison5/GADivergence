//
//  MapShip.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import UIKit

/// Класс корабля
class MapShip: UIImageView {
	
	/// Маршрут, к которому прикреплен корабль
	weak var road: MapRoad?
	
	/// Идентификатор корабля
	let id: Int
	
	/// Текущая позиция корабля
	var currentPoint: Point = .init(x: 0, y: 0)
	
	/// Радиус корабля
	let radius: Double
	
	/// Скорость корабля
	let speed: Double

	// MARK: - Init

	/// Инициализатор
	/// - Parameters:
	///   - id: Идентификатор корабля
	///   - radius: Радиус корабля
	init(id: Int, radius: Double, speed: Double) {
		self.id = id
		self.radius = radius
		self.speed = speed
		super.init(frame: .init(x: 0, y: 0, width: 18, height: 18))
		layer.cornerRadius = 9
		backgroundColor = .red
	}

	required init?(coder: NSCoder) { fatalError("coder") }
}
