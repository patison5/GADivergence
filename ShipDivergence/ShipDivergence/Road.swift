//
//  Road.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation

class Road: NSObject {

	/// Ссылка на корабль
	weak var ship: Ship?

	/// Старовая точка маршрута
	let start: Point

	/// Финишная точка маршрута
	let finish: Point

	/// Набор точек внутри всего маршрута
	var wayDots: [Point]
	
	/// Присутствует столкновение на пути
	var hasCollision: Bool = false

	/// Закончен ли маршрут
	var isFinished: Bool = false

	/// Шаг итерации по маршруту
	var step: Int = 0

	/// Оставшийся путь до конца маршрута
	lazy var remainedDistance: Double = Math.hypotenusus(start: start, finish: finish)

	/// Полная дистанция маршрута
	lazy var fullDistance: Double = {
		var distance = 0.0
		for i in 0..<fullRoad.count - 1 {
			let point1 = fullRoad[i]
			let point2 = fullRoad[i+1]
			distance += Math.hypotenusus(start: point1, finish: point2)
		}
		return distance
	}()

	/// Полный маршрут (набор точек маршрута)
	lazy var fullRoad: [Point] = {
		var fullRoad: [Point] = []
		fullRoad.append(start)
		for item in wayDots {
			fullRoad.append(item)
		}
		fullRoad.append(finish)
		return fullRoad
	}()

	init(start: Point, finish: Point, dots: [Point]) {
		self.start = start
		self.finish = finish
		self.wayDots = dots
	}
}
