
App.onLaunch = function(options) {

    const baseURL = options.baseURL;

    const helperScriptURLs = [
        "DocumentLoader",
        "DocumentController"//,
//        "ListController",
//        "MenuBarController",
//        "ModalController",
//        "SearchController",
//        "SlideshowController"
    ].map(moduleName => `${baseURL}js/${moduleName}.js`);

    const loadingDocument = createLoadingDocument();
    navigationDocument.pushDocument(loadingDocument);

    evaluateScripts(helperScriptURLs, function(scriptsAreLoaded) {
        if (scriptsAreLoaded) {
            const documentLoader = new DocumentLoader(baseURL);
            const startDocURL = documentLoader.prepareURL("/templates/Index.xml");
            new DocumentController(documentLoader, startDocURL, loadingDocument);
        } else {
            const alertDocument = createEvalErrorAlertDocument();
            navigationDocument.replaceDocument(alertDocument, loadingDocument);
            throw new EvalError("TVDemo application.js: unable to evaluate scripts.");
        }
    });
};


function createLoadingDocument(title) {

    title = title || "Loading...";

    const template = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
            <loadingTemplate>
                <activityIndicator>
                    <title>${title}</title>
                </activityIndicator>
            </loadingTemplate>
        </document>
    `;

    return new DOMParser().parseFromString(template, "application/xml");
}


function createAlertDocument(title, description) {
    const template = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
            <alertTemplate>
                <title>${title}</title>
                <description>${description}</description>
            </alertTemplate>
        </document>
    `;

    return new DOMParser().parseFromString(template, "application/xml");
}


function createDescriptiveAlertDocument(title, description) {
    const template = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
            <descriptiveAlertTemplate>
                <title>${title}</title>
                <description>${description}</description>
            </descriptiveAlertTemplate>
        </document>
    `;

    return new DOMParser().parseFromString(template, "application/xml");
}


function createEvalErrorAlertDocument() {

    const title = "Evaluate Scripts Error";
    const description = [
        "There was an error attempting to evaluate the external JavaScript files.",
        "Please check your network connection and try again later."
    ].join("\n\n");

    return createAlertDocument(title, description);
}


function createLoadErrorAlertDocument(url, xhr) {

    const title = (xhr.status) ? `Fetch Error ${xhr.status}` : "Fetch Error";
    const description = `Could not load document:\n${url}\n(${xhr.statusText})`;

    return createAlertDocument(title, description);
}


function setupMediaContent(target, src, artworkURL) {

    const mediaContentList = target.getElementsByTagName('mediaContent');

    for (let i = 0; i < mediaContentList.length; i++) {

        const mediaContent = mediaContentList.item(i);
        const image = mediaContent.getElementsByTagName('img').item(0);
        const mediaSource = src ? src : mediaContent.getAttribute('mediaContent');
        const imageSrc = artworkURL ? artworkURL : mediaContent.getAttribute('artworkURL');

        if (image) {
            image.setAttribute("src", imageSrc);
        }

        const player = mediaContent.getFeature('Player');

        if (player && mediaSource) {
            const mediaItem = new MediaItem('video', mediaSource);
            mediaItem.artworkImageURL = mediaContent.getAttribute('artworkURL');

            player.playlist = new Playlist();
            player.playlist.push(mediaItem);
        }
        
    }

}


function presentVideo(target) {

    const mediaContent = target.getElementsByTagName('mediaContent').item(0);
    const player = mediaContent.getFeature('Player');
    player.present();

}

