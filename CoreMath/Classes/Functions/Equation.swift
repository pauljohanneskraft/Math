//
//  Equation.swift
//  Math
//
//  Created by Paul Kraft on 31.07.16.
//  Copyright © 2016 pauljohanneskraft. All rights reserved.
//

public struct Equation {
    public var terms: [Function]
	
	public init(_ terms: Function...) {
        self.init(terms)
    }
    
	public init(_ terms: [Function]) {
        self.terms = terms
    }
}

extension Equation: Function {
	public var derivative: Function {
        return Equation(terms.map { $0.derivative.reduced }).reduced
    }
    
	public var integral: Function {
        return Equation(terms.map { $0.integral.reduced }).reduced
    }
	
	public var debugDescription: String {
		guard !terms.isEmpty else { return "Term()" }
		var arr = ""
		for i in terms.dropLast() { arr += "\(i.debugDescription), " }
		return "Equation(\(arr)\(terms.last?.debugDescription ?? "nil"))"
	}
	
	public var description: String {
        guard let first = terms.first else { return "0" }
		var result = "\(first.coefficientDescription(first: true))"
		for t in terms.dropFirst() { result += " \(t.coefficientDescription(first: false))" }
		return result
	}
	
	public var latex: String {
		if terms.isEmpty { return "0" }
		var result = "\(terms.first?.latex ?? "nil")"
		for t in terms.dropFirst() { result += " + \(t.latex)" }
		return result
	}
	
	public var reduced: Function {
		var this = self
		var i	 = 0
		var rest = 0.0
		var poly = PolynomialFunction(0)
		while i < this.terms.count {
			let term = this.terms[i].reduced
            switch term {
            case let term as ConstantFunction:
                rest += term.value
                this.terms.remove(at: i)
            case let term as PolynomialFunction:
                poly.polynomial += term.polynomial
                this.terms.remove(at: i)
            case let term as Equation:
                this.terms.remove(at: i)
                this.terms.append(contentsOf: term.terms)
            default:
                this.terms[i] = term
                i += 1
            }
		}
		if poly.polynomial != 0 { this.terms.append(poly.reduced) }
		if rest != 0.0 { this.terms.append(Constant(rest)) }
		if this.terms.count >  1 { return this }
		if this.terms.count == 1 { return this.terms[0] }
		return Constant(0.0)
	}
    
	public func call(x: Double) -> Double {
        return terms.reduce(into: 0) { $0 += $1.call(x: x) }
	}
	
	public func equals(to: Function) -> Bool {
        return terms == (to.reduced as? Equation)?.terms ?? []
	}
}
