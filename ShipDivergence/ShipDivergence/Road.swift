//
//  Road.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation

class Road: NSObject {

	weak var ship: Ship?

	let start: Point
	let finish: Point
	var wayDots: [Point]
	var hasCollision: Bool = false

	/// Закончен ли маршрут
	var isFinished: Bool = false
	var step: Int = 0
	/// Оставшийся путь до конца маршрута
	lazy var remainedDistance: Double = Math.hypotenusus(start: start, finish: finish)
	

	lazy var fullDistance: Double = {
		var distance = 0.0
		for i in 0..<fullRoad.count - 1 {
			let point1 = fullRoad[i]
			let point2 = fullRoad[i+1]
			distance += Math.hypotenusus(start: point1, finish: point2)
		}
		return distance
	}()

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
