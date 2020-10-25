//
//  WeakInstance.swift
//  Instruments
//
//  Created by Константин Богданов on 14.10.2020.
//  Copyright © 2020 Константин Богданов. All rights reserved.
//

final class WeakContainer {
	var value: Any? {
		return element
	}

	private weak var element: AnyObject?
	init(element: Any) {
		self.element = element as AnyObject
	}
}
