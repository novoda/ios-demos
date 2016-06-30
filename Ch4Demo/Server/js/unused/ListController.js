
class ListController extends DocumentController {

    setupDocument(document) {
        super.setupDocument(document);

        const listElem = document.getElementsByTagName('list').item(0);
        const selectorElem = findSelectorElement();

        if (selectorElem) {
            selectItem(selectorElem.firstChild);
            selectorElem.addEventListener('highlight', function(event) {
                selectItem(event.target);
            });
        }

        function findSelectorElement() {
            const tumblerBarElems = document.getElementsByTagName('tumblerBar');
            if (tumblerBarElems.length) {
                return tumblerBarElems.item(0);
            }
            const segmentBarElems = document.getElementsByTagName('segmentBar');
            if (segmentBarElems.length) {
                return segmentBarElems.item(0);
            }
        }

        function selectItem(selectedElem) {
            clearResults();
            const sectionElem = document.createElement('section');
            const newItemsCount = selectedElem.getAttribute("numberOfItemsToCreate");
            for (let i = 1, lockupElem; i <= newItemsCount; i++) {
                lockupElem = createResultLockup(i);
                sectionElem.appendChild(lockupElem);
            }
            listElem.appendChild(sectionElem);
        }

        function clearResults() {
            const sectionElems = document.getElementsByTagName('section');
            for (let i = sectionElems.length - 1, elem; i >= 0; i--) {
                elem = sectionElems.item(i);
                elem.parentNode.removeChild(elem);
            }
        }

        function createResultLockup(i) {
            const lockupElem = document.createElement("listItemLockup");
            const titleElem = document.createElement("title");
            titleElem.textContent = 'Title ' + i;
            lockupElem.appendChild(titleElem);
            return lockupElem;
        }
    }

}

registerAttributeName('listDocumentURL', ListController);
