package com.mobile.pages;

import com.fusion.plugin.extension.mobile.IMobileDriver;

public class MobilePageWrapper {

	public SiteListPage siteListPage;
	public NewSitePage newSitePage;
	public ConsentViewPage consentViewPage;
	public ConsentViewPage consentViewPage1;
	public EditSitePage editSitePage;
	public SiteDebugInfoPage siteDebugInfoPage;
	public PrivacyManagerPage privacyManagerPage;
	
	public MobilePageWrapper(IMobileDriver mobileDriver) {
		
		siteListPage = new SiteListPage(mobileDriver);
		newSitePage = new NewSitePage(mobileDriver);
		consentViewPage = new ConsentViewPage(mobileDriver);
		consentViewPage1 = new ConsentViewPage(mobileDriver);
		editSitePage = new EditSitePage(mobileDriver);
		siteDebugInfoPage = new SiteDebugInfoPage(mobileDriver);
		privacyManagerPage = new PrivacyManagerPage(mobileDriver);
	}
}
