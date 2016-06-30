
function SlideshowController(documentLoader, imageURLsString) {
	const imageURLs = imageURLsString.split(/\s+/).map(documentLoader.prepareURL);
	Slideshow.start(imageURLs, { showSettings: false });
}

// Prevent the DocumentController to display loadingTemplate
SlideshowController.preventLoadingDocument = true;

registerAttributeName("slideshowImageURLs", SlideshowController);
