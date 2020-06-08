package com.fusion.plugin.extension.mobile;

import com.cybage.mobileFramework.IBaseMobileDriver;

public interface IMobileDriver extends IBaseMobileDriver {

	/**
	 * 
	 * Perform Enter Key operation
	 *
	 * @param element
	 *            Perform the enter operation on the given Element
	 *             
	 * @since version 1.00
	 * 
	 */
	public void pressEnterKey(Object element);
}
