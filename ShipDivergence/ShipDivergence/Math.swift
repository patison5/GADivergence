//
//  Math.swift
//  ShipDivergence
//
//  Created by Fedor Penin on 20.05.2021.
//

import Foundation


/// Библиотека для расчета внутри карты кораблей
struct Math {

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

	/// Расстояние между двумя точками
	/// - Parameters:
	///   - start: Первая точка
	///   - finish: Вторая точка
	static func hypotenusus(start: Point, finish: Point) -> Double {
		let dx = finish.x - start.x
		let dy = finish.y - start.y
		return sqrt(pow(dx, 2) + pow(dy, 2))
	}

	/// Перевод градусов в радианы
	/// - Parameter number: Значение в градусах
	/// - Returns: Значение в радианах
	static func deg2rad(_ number: Double) -> Double {
		return number * .pi / 180
	}

	/// Перевод значения широты в X координату плоскости
	/// - Parameters:
	///   - lon: Значение широты
	///   - zoom: Уровень приближения
	/// - Returns: Х координата
	static func mercX (lon: Double, zoom: Double) -> Double {
		let lon = deg2rad(lon)
		let a = (128 / Double.pi) * Double(pow(2.0, zoom))
		let b = lon + Double.pi
		return a * b
	}

	/// Перевод значения долготы в У координату плоскости
	/// - Parameters:
	///   - lon: Значение долготы
	///   - zoom: Уровень приближения
	/// - Returns: У координата
	static func mercY (lat: Double, zoom: Double) -> Double {
		let lat = deg2rad(lat)
		let a = (128 / Double.pi) * Double(pow(2.0, zoom))
		let b = tan(Double.pi / 4 + lat / 2)
		let c = Double.pi - log(b)
		return a * c
	}
}
