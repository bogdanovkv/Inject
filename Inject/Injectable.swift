//
//  Injectable.swift
//  Instruments
//
//  Created by Константин Богданов on 25.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

import Foundation

@propertyWrapper
public class Injectable<PropertyType, InjectType> {

	public var wrappedValue: PropertyType? {
		if let cache = cache {
			return cache
		}

		do {
			let value: InjectType = try Container.shared.get(from: scope)
			guard let property = value as? PropertyType else {
				return nil
			}
			cache = property
			return property
		} catch {
			return nil
		}
	}

	private var cache: PropertyType?
	private let scope: String
	private let type: InjectType.Type

	public init(scope: String, type: InjectType.Type) {
		self.scope = scope
		self.type = type
	}
}

@propertyWrapper
public class WeakInjectable<PropertyType: AnyObject, InjectType: AnyObject> {
	public var wrappedValue: PropertyType? {
		if let cache = cache {
			return cache
		}

		do {
			let value: InjectType = try Container.shared.get(from: scope)
			guard let property = value as? PropertyType else {
				return nil
			}
			cache = property
			return property
		} catch {
			return nil
		}
	}

	private weak var cache: PropertyType?
	private let scope: String
	private let type: InjectType.Type

	public init(scope: String, type: InjectType.Type) {
		self.scope = scope
		self.type = type
	}
}



