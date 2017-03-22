
class SearchController extends DocumentController {

    setupDocument(document) {
        super.setupDocument(document);

        // Obtain references to some useful elements in the searchTemplate
        const searchTemplateElem = document.getElementsByTagName('searchTemplate').item(0);
        const searchFieldElem = document.getElementsByTagName('searchField').item(0);
        const separatorElem = document.getElementsByTagName('separator').item(0);
        const messageElem = document.getElementById("message");
        const suggestionsElem = document.getElementById("suggestions");
        const defaultResultsElem = document.getElementById("defaultResults");
        const resultsModeElem = document.getElementById("resultsMode");
        const resultsListElem = document.getElementById("resultsList");
        const resultsShelfContainerElem = document.getElementById("resultsShelfContainer");
        const resultsGridContainerElem = document.getElementById("resultsGridContainer");
        const resultsSectionElem = document.getElementById("resultsSection");

        // Clean up the document for initial presentation
        let resultsContainerElem = resultsShelfContainerElem;
        resultsListElem.removeChild(resultsGridContainerElem);
        toggleDefaultResults(true);

        // Define some search-related constants
        const searchBaseURL = "https://itunes.apple.com/search?";
        const searchResultsLimit = 25;
        const searchMediaType = "movie";
        const searchMediaArtworkWidth = 250;
        const searchMediaArtworkAspectRatio = 1.5;
        const searchMediaTitleFunc = function(item) {
            return item.trackCensoredName || item.trackName ||
                   item.collectionCensoredName || item.collectionName;
        };
        const searchMediaItemIDFunc = function(item) {
            return item.trackId || item.collectionId;
        };
        const searchMediaArtworkURLFunc = function(item) {
            let result = item.artworkUrl60;
            if (typeof result === "string") {
                // WORKAROUND: Obtain high-resolution artwork
                result = result.replace("/60x60", "/600x600");
            }
            return result;
        };

        // Retain the XHR between searches so it can be cancelled mid-flight
        let searchRequest;
        // Retain the query between searches to determine changes
        let searchTextCache;
        // Retain the result items to handle selection events
        const searchResultsCache = [];

        const searchKeyboard = searchFieldElem.getFeature("Keyboard");
        // Register an event handler for search input changes
        searchKeyboard.onTextChange = performSearchRequest;

        // Register an event handler for search result mode selection
        resultsModeElem.addEventListener("highlight", function(event) {
            const selectedElement = event.target;
            const selectedMode = selectedElement.getAttribute("value");
            setResultsMode(selectedMode);
        });

        // Register an event handler for search suggestions selection
        suggestionsElem.addEventListener("select", function(event) {
            const selectedElement = event.target;
            const searchValue = selectedElement.getAttribute("value");
            searchKeyboard.text = searchValue;
            performSearchRequest();
        });

        // Register an event handler for search result selection
        resultsSectionElem.addEventListener("select", function(event) {
            const selectedElement = event.target;
            const resultIndex = selectedElement.getAttribute("resultIndex");
            const resultItem = searchResultsCache[resultIndex];
            handleSelectionForItem(resultItem);
        });

        /*
         * Show or hide the message in the search body.
         * Sets the content of the message if it is to be shown.
         */
        function toggleSearchMessage(bool, message) {
            if (bool) {
                // Set the message text
                if (message) {
                    messageElem.textContent = message;
                }
                // Show the message if it's hidden
                if (!messageElem.parentNode) {
                    searchTemplateElem.appendChild(messageElem);
                }
                toggleModeButtons(false);
            } else {
                // Hide the message if it's visible
                if (messageElem.parentNode) {
                    searchTemplateElem.removeChild(messageElem);
                }
                toggleModeButtons(true);
            }
        }

        function toggleSearchSuggestions(bool) {
            if (bool) {
                // Show the suggestions if they're hidden
                if (!suggestionsElem.parentNode) {
                    searchTemplateElem.appendChild(suggestionsElem);
                }
                toggleSearchMessage(false);
                toggleModeButtons(false);
            } else {
                // Hide the suggestions if they're visible
                if (suggestionsElem.parentNode) {
                    searchTemplateElem.removeChild(suggestionsElem);
                }
                toggleModeButtons(true);
            }
        }

        function toggleDefaultResults(bool) {
            if (bool) {
                // Swap the default results in for the container
                if (resultsContainerElem.parentNode) {
                    resultsListElem.removeChild(resultsContainerElem);
                    resultsListElem.appendChild(defaultResultsElem);
                }
                toggleSearchMessage(false);
                toggleSearchSuggestions(false);
                toggleModeButtons(false);
            } else {
                // Swap the default results out and the container in
                if (!resultsContainerElem.parentNode) {
                    resultsListElem.removeChild(defaultResultsElem);
                    resultsListElem.appendChild(resultsContainerElem);
                }
                toggleModeButtons(true);
            }
        }

        function toggleModeButtons(bool) {
            if (bool) {
                if (!separatorElem.parentNode) {
                    searchTemplateElem.appendChild(separatorElem);
                }
            } else {
                if (separatorElem.parentNode) {
                    searchTemplateElem.removeChild(separatorElem);
                }
            }
        }

        function setResultsMode(mode) {
            // Remove existing results container
            while (resultsListElem.firstChild) {
                resultsListElem.removeChild(resultsListElem.firstChild);
            }
            // Determine the new results container element
            if (mode === "shelf") {
                resultsContainerElem = resultsShelfContainerElem;
            }
            if (mode === "grid") {
                resultsContainerElem = resultsGridContainerElem;
            }
            // Show the new results container in the collectionList
            resultsListElem.appendChild(resultsContainerElem);
            resultsContainerElem.appendChild(resultsSectionElem);
        }

        function performSearchRequest() {
            // Strip leading, trailing, and multiple whitespaces from the query
            const searchText = searchKeyboard.text.trim().replace(/\s+/g, " ");

            // Do nothing if the query hasn't meaningfully changed
            if (searchTextCache && searchText === searchTextCache) {
                return;
            }
            // Retain this query for the next time the input changes
            searchTextCache = searchText;

            // If there's already a search in-progress, cancel it.
            if (searchRequest && searchRequest.readyState !== XMLHttpRequest.DONE) {
                searchRequest.abort();
            }

            // Show the initial message and stop if there's no search query
            if (searchText.length === 0) {
                toggleDefaultResults(true);
                return;
            }

            // Build the URL for the search query
            const searchParams = [
                `media=${searchMediaType}`,
                `limit=${searchResultsLimit}`,
                `term=${encodeURIComponent(searchText)}`
            ].join("&");
            const searchURL = searchBaseURL + searchParams;

            // Perform the search request
            searchRequest = new XMLHttpRequest();
            searchRequest.open("GET", searchURL);
            searchRequest.responseType = "json";
            searchRequest.onload = showSearchResponse;
            searchRequest.onerror = showSearchError;
            searchRequest.send();

            searchFieldElem.setAttribute("showSpinner", true);
        }

        /*
         * Show a generic error message in the search body
         */
        function showSearchError() {
            toggleSearchMessage(true, "An error occurred during your search.");
            searchFieldElem.setAttribute("showSpinner", false);
        }

        /*
         * Parse the XHR response and show the results or a message
         */
        function showSearchResponse() {
            // Prepare the document for new search results
            toggleDefaultResults(false);
            toggleSearchSuggestions(false);
            clearSearchResults();
            searchFieldElem.setAttribute("showSpinner", false);

            // Show the results (or lack thereof)
            const searchResponse = searchRequest.response;
            const searchResults = searchResponse.results;
            if (searchResults.length > 0) {
                appendSearchResults(searchResults);
                toggleSearchMessage(false);
            } else {
                if (searchTextCache.length > 3) {
                    toggleSearchMessage(true, `No results for ${searchTextCache}.`);
                } else {
                    toggleSearchSuggestions(true);
                }
            }
        }

        /*
         * Empty the results cache and remove all results lockup elements.
         */
        function clearSearchResults() {
            searchResultsCache.length = 0;
            // Remove all existing search results
            while (resultsSectionElem.firstChild) {
                resultsSectionElem.removeChild(resultsSectionElem.firstChild);
            }
        }

        /*
         * Create lockup elements for the search results and cache
         * the data to be referenced by the selection handler.
         */
        function appendSearchResults(results) {
            const startIndex = searchResultsCache.length;
            // Create new lockups for the results
            results.forEach(function(item, index) {
                index += startIndex;
                // Create item lockup element
                const lockupElem = document.createElement("lockup");
                // Set the result array index on the lockup
                lockupElem.setAttribute("resultIndex", index);
                // Populate the lockup element details
                populateLockupWithItem(lockupElem, item);
                // Add the lockup to the results collection
                resultsSectionElem.appendChild(lockupElem);
                // Add the item to the search results cache
                searchResultsCache.push(item);
            });
        }

        /*
         * Inserts elements containing data from a search result into the
         * empty lockup element created to display the result.
         * Shows an image, title, and subtitle in the lockup.
         */
        function populateLockupWithItem(lockupElem, item) {
            // Determine the lockup image attributes
            const titleText = searchMediaTitleFunc(item);
            const itemID = searchMediaItemIDFunc(item);
            const imgURL = searchMediaArtworkURLFunc(item);
            const imgWidth = searchMediaArtworkWidth;
            const imgHeight = imgWidth * searchMediaArtworkAspectRatio;
            // Create the child nodes of the lockup element
            const imgElem = document.createElement("img");
            const titleElem = document.createElement("title");
            // Set the lockup image attributes
            imgElem.setAttribute("src", imgURL);
            imgElem.setAttribute("width", imgWidth);
            imgElem.setAttribute("height", imgHeight);
            // Set the lockup element text from the item
            titleElem.setAttribute("class", "showTextOnHighlight");
            titleElem.textContent = titleText;
            // Put the child nodes into the lockup
            lockupElem.setAttribute("itemID", itemID);
            lockupElem.appendChild(imgElem);
            lockupElem.appendChild(titleElem);
        }

        /*
         * Called when a search result is selected, passing in the
         * JSON Object that was returned by the API for the result.
         */
        function handleSelectionForItem(item) {
            console.log("handleSelectionForItem: " + JSON.stringify(item));
            // TODO Something more interesting than logging
        }
    }

}

registerAttributeName('searchDocumentURL', SearchController);
