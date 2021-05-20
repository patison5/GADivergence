//
//  MapRoad.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation

/// Маршрут судна
class MapRoad {

	/// Точка начала маршрута
	let start: Point

	/// Точка конца маршрута
	let finish: Point

	/// Судно на маршруте
	let ship: MapShip

	/// Оставшийся путь до конца маршрута
//	lazy var remainedDistance: Double = Math.hypotenusus(start: start, finish: finish)

	/// Закончен ли маршрут
	var isFinished: Bool = false

	/// Инициализатор
	/// - Parameters:
	///   - start: Точка начала маршрута
	///   - finish: Точка конца маршрута
	///   - speed: Скорость судна
	///   - startTime: Время начала пути
	///   - ship: Судно на маршруте
	init(start: Point, finish: Point, ship: MapShip) {
		self.start = start
		self.finish = finish
		self.ship = ship
		self.ship.currentPoint = self.start
		self.ship.road = self
	}
}
