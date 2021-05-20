//
//  GADivergence.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation


class GADivergence {
	let startIndex: Int = 0
	var finishIndex: Int = 100
	var currentIndex: Int = 0
	var speed: Double = 1
	var radius: Double = 1
	let concurentShip: [Ship]

	// массив всех возможных путей
	var childrenRoads: [Road] // [50]
	var bestRoad: Road?

	init(concuredShips: [Ship], startChildrens: [Road], populationAmount: Int, shipSpeed: Double, shipRadius: Double) {
		self.concurentShip = concuredShips
		self.childrenRoads = startChildrens
		self.finishIndex = populationAmount
		self.speed = shipSpeed
		self.radius = shipRadius
	}

	/// Выборка элементов
	func selection() {
		for childrenRoad in childrenRoads {
			let fullRoad = createFullRoad(road: childrenRoad)

			for concuredShip in concurentShip {
				var probableCollision: [Line] = []

				// Находим участки на которых происходит пересечение с вражеским кораблем
				for i in 0..<fullRoad.count - 1 {
					let point1 = fullRoad[i]
					let point2 = fullRoad[i+1]

					let intersection = Line.intersection(line1: Line(p1: point1, p2: point2), line2: Line(p1: concuredShip.road.start, p2: concuredShip.road.finish))
					guard let inter = intersection else {
						continue
					}

					let x = Line.getX(from: Line(p1: point1, p2: point2), y: inter.y)
					if (x == inter.x) && (Line.pointBelongToSegment(A: point1, B: point2, C: Point(x: x, y: inter.y))) {
						probableCollision.append(Line(p1: point1, p2: point2))
					}
				}

				// Проверяем будет ли столкновение на каждом из найденных участков
				var time: Double = 0.0
				for i in 0..<fullRoad.count - 1 {
					let point1 = fullRoad[i]
					let point2 = fullRoad[i+1]

					let contains = probableCollision.contains(Line(p1: point1, p2: point2))
					if contains {
						guard let intersection = Line.intersection(line1: Line(p1: point1, p2: point2), line2: Line(p1: concuredShip.road.start, p2: concuredShip.road.finish)) else { return }

						time += Math.hypotenusus(start: point1, finish: intersection) / speed
						let concuredShipPosition = Math.nextPoint(start: concuredShip.road.start, finish: concuredShip.road.finish, speed: concuredShip.speed, t: time)

						let delta = Math.hypotenusus(start: intersection, finish: concuredShipPosition)
						let maxRadius = max(self.radius, concuredShip.radius)
						if (delta <= maxRadius) {
							childrenRoad.hasCollision = true
						}
					} else {
						time += Math.hypotenusus(start: point1, finish: point2) / speed
					}
				}
			}
		}

		var widthCollision = childrenRoads.filter { $0.hasCollision }
		var widthOutCollision = childrenRoads.filter { !$0.hasCollision }

		widthCollision.sort { (road1, road2) -> Bool in
			road1.fullDistance < road2.fullDistance
		}

		widthOutCollision.sort { (road1, road2) -> Bool in
			road1.fullDistance < road2.fullDistance
		}

		var childrenRoadsFiltered = widthOutCollision
		childrenRoadsFiltered.append(contentsOf: widthCollision)

		childrenRoads = childrenRoadsFiltered

		if childrenRoads.count > 20 {
			childrenRoads = Array(childrenRoads[0 ..< 20])
		}
	}

	/// Кроссинговер - скрещивания
	func crossing() {
//		print("Происходит скрещивание")
//		var childrenRoadsCrossed: [Road] = []

		for i in 0...childrenRoads.count - 2 where i % 2 == 0 {
			let roadX = childrenRoads[i]
			let roadY = childrenRoads[i+1]
			let mother = Array(roadX.wayDots[0 ..< 2])
			let father = Array(roadY.wayDots[2 ..< 4])
			var dots = mother
			dots.append(contentsOf: father)
			childrenRoads.append(Road(start: roadX.start, finish: roadX.finish, dots: dots))
		}
	}

	/// Мутация
	func mutating() {
//		print("Происходит мутация элементов")

		let randomAmount = Int.random(in: 5..<10)
		for _ in 0..<randomAmount {
			let randmonId = Int.random(in: 0..<childrenRoads.count - 1)
			let randmonDotsAmount = Int.random(in: 1..<3)
			for i in 0..<randmonDotsAmount {
				childrenRoads[randmonId].wayDots[i] = Point(x: childrenRoads[randmonId].wayDots[i].x, y: Double.random(in: 1..<100))
			}
		}
	}

	/// Основной цикл ГА
	func start() {
		while currentIndex < finishIndex {
			print("---------------- \(currentIndex) ----------------")
			selection()
			crossing()
			selection()
			print("\(childrenRoads[0].fullDistance)")
			mutating()

			currentIndex+=1
		}
		print("----------- Finish ---------")
		crossing()

		let res = Array(childrenRoads[0 ..< 5])
		res.forEach {
			var str = ""
			$0.wayDots.forEach { (point) in
				str += " (\(point.x), \(point.y)) "
			}
			print("\($0.fullDistance) \($0.hasCollision)")
		}

		bestRoad = childrenRoads[0]
	}

	func getBestRoad() -> Road {
		guard let road = bestRoad else {
			return Road(start: .init(x: 0, y: 0), finish: .init(x: 0, y: 0), dots: [])
		}
		return road
	}

	func createFullRoad(road: Road) -> [Point] {
		var fullRoad: [Point] = []
		fullRoad.append(road.start)
		fullRoad.append(road.wayDots[0])
		fullRoad.append(road.wayDots[1])
		fullRoad.append(road.wayDots[2])
		fullRoad.append(road.wayDots[3])
		fullRoad.append(road.finish)
		return fullRoad
	}
}
