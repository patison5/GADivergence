//
//  ViewController.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import UIKit

class ViewController: UIViewController {

	let map = Map()
	let size = UIScreen.main.bounds
	let insetBottom = Double(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
	let insetLeft = Double(UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0)
	let zoomLvl = 3.0

	override func viewDidLoad() {
		super.viewDidLoad()		
		view.backgroundColor = .cyan

		let road1 = Road(start: Point(x: 170, y: 40), finish: Point(x: 0, y: 40), dots: [])
//		let road1 = Road(start: Point(x: 10, y: 60), finish: Point(x: 30, y: 60), dots: [])
		let road2 = Road(start: Point(x: 80, y: 70), finish: Point(x: 80, y: 00), dots: [])
		let road3 = Road(start: Point(x: 10, y: 50), finish: Point(x: 95, y: 20), dots: [])

		let start1 = Road(start: Point(x: 10, y: 20), finish: Point(x: 150, y: 60), dots: [Point(x: 30, y: 140), Point(x: 60, y: 60), Point(x: 90, y: 20), Point(x: 120, y: 70)])
		let start2 = Road(start: Point(x: 10, y: 20), finish: Point(x: 150, y: 60), dots: [Point(x: 390, y: 90), Point(x: 60, y: 90), Point(x: 90, y: 10), Point(x: 120, y: 10)])
		let start3 = Road(start: Point(x: 10, y: 20), finish: Point(x: 150, y: 60), dots: [Point(x: 840, y: 1000), Point(x: 120, y: 10), Point(x: 90, y: 30), Point(x: 120, y: 500)])
		let start4 = Road(start: Point(x: 10, y: 20), finish: Point(x: 150, y: 60), dots: [Point(x: 1000, y: 920), Point(x: 60, y: 930), Point(x: 90, y: 90), Point(x: 120, y: 1000)])

		let concuredShip1 = Ship(road: road1, speed: 40, radius: 20)
		let concuredShip2 = Ship(road: road2, speed: 40, radius: 10)
		let concuredShip3 = Ship(road: road3, speed: 40, radius: 10)

		road1.ship = concuredShip1
		road2.ship = concuredShip2
		road3.ship = concuredShip3

		let genetic = GADivergence(concuredShips: [concuredShip1, concuredShip3],
								   startChildrens: [start1, start2, start3, start4],
								   populationAmount: 2,
								   shipSpeed: 10,
								   shipRadius: 10)
		genetic.start()
		
		let bestRoad = genetic.getBestRoad()
		let bestShip = Ship(road: bestRoad, speed: 10, radius: 10)

		bestRoad.ship = bestShip
		print(bestRoad.fullRoad)

		[bestShip, concuredShip1, concuredShip2, concuredShip3].forEach {
			view.addSubview($0)
		}

		drawLines(array: [bestShip.road, concuredShip1.road, concuredShip2.road, concuredShip3.road])

		map.roads = [bestShip.road, concuredShip1.road, concuredShip2.road, concuredShip3.road,]
		map.delegate = self
		map.start()
	}

	func drawLines (array: [Road]) {
		array.forEach {
			for i in 0...$0.fullRoad.count - 2 {
				let line = CAShapeLayer()
				let linePath = UIBezierPath()
				let start = convertCoords(point: $0.fullRoad[i], zoom: zoomLvl)
				let stop = convertCoords(point:  $0.fullRoad[i+1], zoom: zoomLvl)
				linePath.move(to: .init(x: start.x, y: start.y))
				linePath.addLine(to: .init(x: stop.x, y: stop.y))
				line.path = linePath.cgPath
				line.strokeColor = UIColor.red.cgColor
				line.lineWidth = 1
				line.lineJoin = CAShapeLayerLineJoin.round
				self.view.layer.addSublayer(line)
			}
		}
	}

	func convertCoords(point: Point, zoom: Double) -> Point {
		var newPoint = Point(x: point.x * zoom + insetLeft, y: Double(size.height) - point.y * zoom - insetBottom)
		return newPoint
	}
}

extension ViewController: MapDelegate {

	func didUpdate() {
		for road in map.roads {
			guard let ship = road.ship else { return }
//			if road.wayDots.count > 0 {
//				continue
//			}
			let point = convertCoords(point: ship.currentPoint, zoom: zoomLvl)
			ship.center = CGPoint(x: point.x, y: point.y)
		}
	}
}
