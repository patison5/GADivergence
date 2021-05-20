//
//  Line.swift
//  Ships
//
//  Created by Beorn on 19.05.2021.
//

import Foundation

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

	/// Точка принадлежащая отрезку
	/// - Parameters:
	///   - A: Точка начала отрезка
	///   - B: Точка конца отрезка
	///   - C: Проверяемая точка
	/// - Returns: заключение о принадлежности
	static func pointBelongToSegment (A: Point, B: Point, C: Point) -> Bool {
//		if ((C.y - A.y) / (B.y - A.y) == (C.x - A.x) / (B.x - A.x)) {
			if (((A.x <= C.x) && (C.x <= B.x)) || ((B.x <= C.x) && (C.x <= A.x))) {
				return true
			}
//		}
		return false
	}

	/// Получить координату Х на прямой
	/// - Parameters:
	///   - line: Прямая
	///   - y: Координа У точки
	/// - Returns: Координата Х точки
	static func getX(from line: Line, y: Double) -> Double {
		let x = (y - line.p1.y) / (line.p2.y - line.p1.y) * (line.p2.x - line.p1.x) + line.p1.x
		return x
	}
}
