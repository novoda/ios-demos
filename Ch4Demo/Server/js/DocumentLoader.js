
class DocumentLoader {

    constructor(baseURL) {
        // Bind callback methods to current context
        this.prepareURL = this.prepareURL.bind(this);
        this.prepareElement = this.prepareElement.bind(this);
        // Validate arguments
        if (typeof baseURL !== "string") {
            throw new TypeError("DocumentLoader: baseURL argument must be a string.");
        }
        this.baseURL = baseURL;
    }

    /*
     * Helper method to request templates from the server
     */
    fetch(options) {
        if (typeof options.url !== "string") {
            throw new TypeError("DocumentLoader.fetch: url option must be a string.");
        }
        // Cancel the previous request if it is still in-flight.
        if (options.concurrent !== true) {
            this.cancelFetch();
        }
        // Parse the request URL
        const docURL = this.prepareURL(options.url);
        const xhr = new XMLHttpRequest();
        xhr.open("GET", docURL);
        xhr.responseType = "document";
        xhr.onload = () => {
            const responseDoc = xhr.response;
            this.prepareDocument(responseDoc);
            if (typeof options.success === "function") {
                options.success(responseDoc);
            } else {
                navigationDocument.pushDocument(responseDoc);
            }
        };
        xhr.onerror = () => {
            if (typeof options.error === "function") {
                options.error(xhr);
            } else {
                const alertDocument = createLoadErrorAlertDocument(docURL, xhr, true);
                navigationDocument.presentModal(alertDocument);
            }
        };
        xhr.send();
        // Preserve the request so it can be cancelled by the next fetch
        if (options.concurrent !== true) {
            this._fetchXHR = xhr;
        }
    }

    /*
     * Helper method to cancel a running XMLHttpRequest
     */
    cancelFetch() {
        const xhr = this._fetchXHR;
        if (xhr && xhr.readyState !== XMLHttpRequest.DONE) {
            xhr.abort();
        }
        delete this._fetchXHR;
    }

    /*
     * Helper method to convert a relative URL into an absolute URL
     */
    prepareURL(url) {
        // Handle URLs relative to the "server root" (baseURL)
        if (url.indexOf("/") === 0) {
            url = this.baseURL + url.substr(1);
        }
        return url;
    }

    /*
     * Helper method to mangle relative URLs in XMLHttpRequest response documents
     */
    prepareDocument(document) {
        /**
         * Convenience function to iterate and recurse through a DOM tree
         */
        function traverseElements(elem, callback) {
            callback(elem);
            const children = elem.children;
            for (let i = 0; i < children.length; ++i) {
                traverseElements(children.item(i), callback);
            }
        }
        traverseElements(document.documentElement, this.prepareElement);
    }

    /*
     * Helper method to mangle relative URLs in DOM elements
     */
    prepareElement(elem) {
        if (elem.hasAttribute("src")) {
            const rawSrc = elem.getAttribute("src");
            const parsedSrc = this.prepareURL(rawSrc);
            elem.setAttribute("src", parsedSrc);
        }
        if (elem.hasAttribute("srcset")) {
            // TODO Prepare srcset attribute
        }
    }

}
