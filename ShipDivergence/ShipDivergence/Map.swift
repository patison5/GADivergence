//
//  Map.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation

import UIKit

/// Карта суден
class Map {

	/// Маршруты на карте
	var roads: [Road] = []

	/// Делегат карты
	weak var delegate: MapDelegate?

	/// Глобальное время на карте
	var currentTime: Double = 0

	/// Время обновления позиций суден
	let timeAccuracy: Double = 0.01

	/// Начать все маршруты
	func start() {
		let timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
//			print("start")
			self.resume()
//			let allFinished = self.roads.allSatisfy { $0.isFinished }
//			if !allFinished {
//				self.resume()
//			} else {
//				timer.invalidate()
//			}
		}
		timer.fire()
	}
	
	/// Продолжить исполнение маршрутов
	private func resume() {

		for road in roads {
			guard let ship = road.ship else { continue }
			if road.step < road.fullRoad.count - 1 {
				let finishPoint = road.fullRoad[road.step + 1]
				var remainedDistance = Math.hypotenusus(start: ship.currentPoint, finish: finishPoint)
				print(remainedDistance)
				print(road.remainedDistance)
				print(remainedDistance <= road.remainedDistance)
				if remainedDistance <= road.remainedDistance && !road.isFinished {
					road.remainedDistance = remainedDistance
					ship.currentPoint = Math.nextPoint(start: ship.currentPoint,
															finish: finishPoint,
															speed: ship.speed/10,
															t: currentTime)
				} else {
					road.step += 1
					if road.step >= road.fullRoad.count - 1 { continue }
					remainedDistance = Math.hypotenusus(start: ship.currentPoint, finish: road.fullRoad[road.step + 1])
					road.remainedDistance = remainedDistance
				}
			} else {
				ship.currentPoint = road.finish
				road.isFinished = true
			}
		}

		currentTime += 0.01
		delegate?.didUpdate()
	}
}
