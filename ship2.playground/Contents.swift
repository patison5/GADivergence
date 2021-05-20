import UIKit

var str = "Hello, playground"


/// Позиция на плоскости XY
struct Point: Equatable {

	/// X Координата
	let x: Double

	/// Y Координата
	let y: Double
}


class Road: NSObject {
	let start: Point
	let finish: Point
	var wayDots: [Point]
	var hasCollision: Bool = false

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

/// Уравнение прямой
struct Line: Equatable {

	let p1: Point

	let p2: Point

	/// Коэффициент А
	let a: Double

	/// Коэффициент B
	let b: Double

	/// Коэффициент C
	let c: Double

	/// Инициализатор уравнения прямой
	/// - Parameters:
	///   - p1: Первая точка
	///   - p2: Вторая точка
	init(p1: Point, p2: Point) {
		self.p1 = p1
		self.p2 = p2
		self.a = p1.y - p2.y
		self.b = p2.x - p1.x
		self.c = -(p1.x * p2.y - p2.x * p1.y)
	}
}

// MARK: - Math

extension Line {

	/// Точка пересечения двух прямых
	/// - Parameters:
	///   - line1: Первая прямая
	///   - line2: Вторая прямая
	static func intersection(line1: Line, line2: Line) -> Point? {
		let d = line1.a * line2.b - line1.b * line2.a
		let dx = line1.c * line2.b - line1.b * line2.c
		let dy = line1.a * line2.c - line1.c * line2.a
		if d != 0 {
			return Point(x: dx / d, y: dy / d)
		}
		return nil
	}

	static func pointBelongToSegment (A: Point, B: Point, C: Point) -> Bool {
//		if ((C.y - A.y) / (B.y - A.y) == (C.x - A.x) / (B.x - A.x)) {
			if (((A.x <= C.x) && (C.x <= B.x)) || ((B.x <= C.x) && (C.x <= A.x))) {
				return true
			}
//		}
		return false
	}

	static func getX(from line: Line, y: Double) -> Double {
		let x = (y - line.p1.y) / (line.p2.y - line.p1.y) * (line.p2.x - line.p1.x) + line.p1.x
		return x
	}
}

struct Math {
	/// Расстояние между двумя точками
	/// - Parameters:
	///   - start: Первая точка
	///   - finish: Вторая точка
	static func hypotenusus(start: Point, finish: Point) -> Double {
		let dx = finish.x - start.x
		let dy = finish.y - start.y
		return sqrt(pow(dx, 2) + pow(dy, 2))
	}

	/// Следующая точка корабля
	/// - Parameters:
	///   - start: Точка начала пути
	///   - finish: Конец маршрута
	///   - speed: Скорость судна
	///   - t: Текущее время
	static func nextPoint(start: Point, finish: Point, speed: Double, t: Double) -> Point {
		let delta = hypotenusus(start: start, finish: finish)
		let time = delta / speed
		let vx = (finish.x - start.x) / time
		let vy = (finish.y - start.y) / time
		let x = start.x + vx * Double(t)
		let y = start.y + vy * Double(t)
		return Point(x: x, y: y)
	}
}


class Ship {
	let road: Road
	let speed: Double
	let radius: Double

	init(road: Road, speed: Double, radius: Double) {
		self.road = road
		self.speed = speed
		self.radius = radius
	}
}

class GADevergence {
	let startIndex: Int = 0
	let finishIndex: Int = 100
	var currentIndex: Int = 0
	let speed: Double = 1
	let radius: Double = 1
	let concurentShip: [Ship]

	// массив всех возможных путей
	var childrenRoads: [Road] // [50]

	init(concuredShips: [Ship], startChildrens: [Road]) {
		self.concurentShip = concuredShips
		self.childrenRoads = startChildrens
	}

	/// Выборка элементов
	func selection() {
		for childrenRoad in childrenRoads {
			let fullRoad = createFullRoad(road: childrenRoad)
//			var fullRoadStr = ""
//			fullRoad.forEach { fullRoadStr += "\($0.x), \($0.y) : "}

			for concuredShip in concurentShip {
				var probableCollision: [Line] = []

				// Находим участки на которых происходит пересечение с вражеским кораблем
				for i in 0..<fullRoad.count - 1 {
					let point1 = fullRoad[i]
					let point2 = fullRoad[i+1]

					let intersection = Line.intersection(line1: Line(p1: point1, p2: point2), line2: Line(p1: concuredShip.road.start, p2: concuredShip.road.finish))
					guard let inter = intersection else {
//						print("!!!!!! someting went wrong !!!!!!")
						continue
					}

					let x = Line.getX(from: Line(p1: point1, p2: point2), y: inter.y)
					if (x == inter.x) && (Line.pointBelongToSegment(A: point1, B: point2, C: Point(x: x, y: inter.y))) {
//						print(inter)
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

//						print("(\(point1.x), \(point1.y)) - (\(intersection.x), \(intersection.y))")

						time += Math.hypotenusus(start: point1, finish: intersection) / speed
						let concuredShipPosition = Math.nextPoint(start: concuredShip.road.start, finish: concuredShip.road.finish, speed: concuredShip.speed, t: time)

						let delta = Math.hypotenusus(start: intersection, finish: concuredShipPosition)
						let maxRadius = max(self.radius, concuredShip.radius)
//						print("delta : \(delta)")
						if (delta <= maxRadius) {
							childrenRoad.hasCollision = true
//							print("происходит сталкивание ептить")
						}
					} else {
						time += Math.hypotenusus(start: point1, finish: point2) / speed
					}
				}
//				print("------")
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

//		print("\n#### with collision ####")
//		print(widthCollision.count)
//		widthCollision.forEach {
//			print($0.fullDistance)
//		}
		
//		print("\n#### with out collision ####")
//		print(widthOutCollision.count)
//		widthOutCollision.forEach {
//			print($0.fullDistance)
//		}

		var childrenRoadsFiltered = widthOutCollision
		childrenRoadsFiltered.append(contentsOf: widthCollision)

		childrenRoads = childrenRoadsFiltered

//		print("\n####### selection final #######")
//		print(childrenRoads.count)
//		childrenRoads.forEach {
//			var str = ""
//			$0.wayDots.forEach { (point) in
//				str += " (\(point.x), \(point.y)) "
//			}
//			print("\($0.fullDistance) \($0.hasCollision)")
//		}

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

//		for roadX in childrenRoads {
//			for roadY in childrenRoads {
//				if roadX == roadY {
//					childrenRoadsCrossed.append(Road(start: roadX.start, finish: roadX.finish, dots: roadX.wayDots))
//					continue
//				}
//
//				let mother = Array(roadX.wayDots[0 ..< 2])
//				let father = Array(roadY.wayDots[2 ..< 4])
//				var dots = mother
//				dots.append(contentsOf: father)
//				childrenRoadsCrossed.append(Road(start: roadX.start, finish: roadX.finish, dots: dots))
//			}
//		}

//		childrenRoads = childrenRoadsCrossed

//		print("\n####### crossig final #######")
//		print(childrenRoads.count)
//		childrenRoads.forEach {
//			var str = ""
//			$0.wayDots.forEach { (point) in
//				str += " (\(point.x), \(point.y)) "
//			}
//			print("\($0.fullDistance) \($0.hasCollision)")
//		}
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
			print("\n\n---------------- \(currentIndex) ----------------")
			selection()
			crossing()
			selection()
			print("\(childrenRoads[0].fullDistance)")
			mutating()

			currentIndex+=1
//			childrenRoads.forEach {
//				var str = ""
//				$0.wayDots.forEach { (point) in
//					str += " (\(point.x), \(point.y)) "
//				}
//				print("\($0.fullDistance) \($0.hasCollision) \(str)")
//			}
		}
		print("----------- Finish ---------")
		crossing()
//		childrenRoads.forEach {
//			var str = ""
//			$0.wayDots.forEach { (point) in
//				str += " (\(point.x), \(point.y)) "
//			}
//			print("\($0.fullDistance) \($0.hasCollision) \(str)")
//		}
		
		let res = Array(childrenRoads[0 ..< 5])
		res.forEach {
			var str = ""
			$0.wayDots.forEach { (point) in
				str += " (\(point.x), \(point.y)) "
			}
			print("\($0.fullDistance) \($0.hasCollision)")
		}
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



//let road1 = Road(start: Point(x: 13, y: 4), finish: Point(x: 0, y: 4), dots: [])
let road1 = Road(start: Point(x: 1, y: 6), finish: Point(x: 3, y: 6), dots: [])
let road2 = Road(start: Point(x: 8, y: 7), finish: Point(x: 8, y: 0), dots: [])
let road3 = Road(start: Point(x: 3, y: 8), finish: Point(x: 0, y: 8), dots: [])

let start1 = Road(start: Point(x: 1, y: 2), finish: Point(x: 15, y: 6), dots: [Point(x: 3, y: 6), Point(x: 6, y: 3), Point(x: 9, y: 2), Point(x: 12, y: 7)])
let start2 = Road(start: Point(x: 1, y: 2), finish: Point(x: 15, y: 6), dots: [Point(x: 39, y: 1), Point(x: 6, y: 1), Point(x: 9, y: 1), Point(x: 12, y: 1)])
let start3 = Road(start: Point(x: 1, y: 2), finish: Point(x: 15, y: 6), dots: [Point(x: 84, y: 100), Point(x: 12, y: 1), Point(x: 9, y: 3), Point(x: 12, y: 2)])
let start4 = Road(start: Point(x: 1, y: 2), finish: Point(x: 15, y: 6), dots: [Point(x: 100, y: 92), Point(x: 6, y: 93), Point(x: 9, y: 9), Point(x: 12, y: 1)])

let ship1 = Ship(road: start1, speed: 1, radius: 1)
//let ship2 = Ship(road: start2, speed: 1, radius: 1)

let concuredShip1 = Ship(road: road1, speed: 1, radius: 2)
let concuredShip2 = Ship(road: road2, speed: 1, radius: 1)
let concuredShip3 = Ship(road: road3, speed: 1, radius: 1)

let ga = GADevergence(concuredShips: [concuredShip1, concuredShip3], startChildrens: [start1, start2, start3, start4])
//ga.start()


func deg2rad(_ number: Double) -> Double {
	return number * .pi / 180
}

let clat: Double = 0
let clon: Double = 0
let zoom: Double = 1

let lat: Double = 31.2304
let lon: Double = 121.4737

func mercX (lon: Double) -> Double {
	let lon = deg2rad(lon)
	let a = (128 / Double.pi) * Double(pow(2.0, zoom))
	let b = lon + Double.pi
	return a * b
}
func mercY (lat: Double) -> Double {
	let lat = deg2rad(lat)
	let a = (128 / Double.pi) * Double(pow(2.0, zoom))
	let b = tan(Double.pi / 4 + lat / 2)
	let c = Double.pi - log(b)
	return a * c
}
print(mercX(lon: lon))
print(mercY(lat: lat))
