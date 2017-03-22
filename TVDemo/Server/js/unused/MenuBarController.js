
class MenuBarController extends DocumentController {

    fetchDocument(documentURL, loadingDocument) {
        this._documentLoader.fetch({
            url: documentURL,
            success: (menuBarDocument) => {
                const menuBarElem = menuBarDocument.getElementsByTagName("menuBar").item(0);
                menuBarElem.addEventListener("select", (event) => {
                    this.selectMenuItem(event.target);
                });

                // Pre-load the document for the initial focused menu item or first item,
                // before presenting the menuBarTemplate on navigation stack.
                // NOTE: Pre-loading is optional
                const initialMenuItemElem = this.findInitialMenuItem(menuBarElem);
                const initialMenuItemController = this.selectMenuItem(initialMenuItemElem, true, () => {
                    this.handleDocument(menuBarDocument, loadingDocument);
                });
            },
            error: (xhr) => {
                const alertDocument = createLoadErrorAlertDocument(documentURL, xhr, false);
                this.handleDocument(alertDocument, loadingDocument);
            }
        });
    }

    findInitialMenuItem(menuBarElem) {
        let highlightIndex = 0;
        const menuItemElems = menuBarElem.childNodes;
        for (let i = 0; i < menuItemElems.length; i++) {
            if (menuItemElems.item(i).hasAttribute("autoHighlight")) {
                highlightIndex = i;
                break;
            }
        }
        return menuItemElems.item(highlightIndex);
    }

    selectMenuItem(menuItemElem, isInitialItem, doneCallback) {
        const menuBarElem = menuItemElem.parentNode;
        const menuBarFeature = menuBarElem.getFeature("MenuBarDocument");
        const existingDocument = menuBarFeature.getDocument(menuItemElem);

        if (!existingDocument) {
            const controllerOptions = resolveControllerFromElement(menuItemElem);
            if (controllerOptions) {
                if (!isInitialItem) {
                    menuBarFeature.setDocument(createLoadingDocument(), menuItemElem);
                }
                const controllerClass = controllerOptions.type;
                const documentURL = controllerOptions.url;
                const controller = new controllerClass(this._documentLoader, documentURL);
                controller.handleDocument = (document) => {
                    if (isInitialItem) {
                        menuBarFeature.setDocument(document, menuItemElem);
                    } else {
                        // Force timeout to convey intent of displaying loading while the
                        // content is being loaded from server
                        setTimeout(function() {
                            // Override the presentation of controller since this controller
                            // is child of menuBar and doesn't get pushed on the navigation stack
                            menuBarFeature.setDocument(document, menuItemElem);
                        }, 1000);
                    }
                    doneCallback && doneCallback();
                };
            }
        }
    }

}

registerAttributeName('menuBarDocumentURL', MenuBarController);
