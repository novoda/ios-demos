
class ModalController extends DocumentController {

	handleDocument(document) {
		navigationDocument.presentModal(document);
	}

	handleEvent(event) {
    	navigationDocument.dismissModal();
	}

}

// Prevent parent DocumentController from displaying the loadingTemplate
ModalController.preventLoadingDocument = true;

registerAttributeName('modalDocumentURL', ModalController);
