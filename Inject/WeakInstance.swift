//
//  WeakInstance.swift
//  Instruments
//
//  Created by Константин Богданов on 14.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

final class WeakContainer<Element> {
	var value: Element? {
		return element as? Element
	}

	private weak var element: AnyObject?
	init(element: Element) {
		self.element = element as AnyObject
	}
}
