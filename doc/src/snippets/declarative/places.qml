/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the documentation of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

//! [QtQuick import]
import QtQuick 2.0
//! [QtQuick import]
//! [QtLocation import]
import QtLocation 5.0
//! [QtLocation import]

Item {
    Plugin {
        id: myPlugin
    }

    Place {
        id: place
    }

    //! [Category]
    Category {
        id: category

        plugin: myPlugin
        name: "New Category"
        visibility: Category.PrivateVisibility
    }
    //! [Category]

    function saveCategory() {
        //! [Category save]
        category.save();
        //! [Category save]
    }

    //! [CategoryView]
    ListView {
        model: CategoryModel {
            plugin: myPlugin
            hierarchical: false
        }
        delegate: Text { text: category.name }
    }
    //! [CategoryView]

    //! [ExtendedAttributes]
    ListView {
        model: place.extendedAttributes.keys()
        delegate: Text {
            text: "<b>" + place.extendedAttributes[modelData].label + ": </b>" +
                  place.extendedAttributes[modelData].text
        }
    }
    //! [ExtendedAttributes]

    //! [ExtendedAttributes read]
    function printExtendedAttributes(extendedAttributes) {
        var keys = extendedAttributes.keys();
        for (var i = 0; i < keys.length; ++i) {
            var key = keys[i];
            if (extendedAttributes[key].label !== "")
                console.log(extendedAttributes[key].label + ": " + extendedAttributes[key].text);
        }
    }
    //! [ExtendedAttributes read]

    //! [Icon]
    Image {
        source: icon.url(Qt.size(64, 64))
    }
    //! [Icon]

    Image {
    //! [Icon default]
    source: icon.url()
    //! [Icon default]
    }

    //! [PlaceSearchModel]
    PlaceSearchModel {
        id: searchModel

        searchTerm: "Pizza"
        searchArea: BoundingCircle {
            center: Coordinate {
                // Brisbane
                longitude: 153.02778
                latitude: -27.46778
            }
        }

        Component.onCompleted: execute()
    }

    ListView {
        model: searchModel
        delegate: Text { text: 'Name: ' + place.name }
    }
    //! [PlaceSearchModel]

    //! [RecommendationModel]
    PlaceRecommendationModel {
        id: recommendationModel

        placeId: place.placeId
        searchArea: BoundingCircle {
            center: Coordinate {
                // Brisbane
                longitude: 153.02778
                latitude: -27.46778
            }
        }

        Component.onCompleted: execute()
    }

    ListView {
        model: recommendationModel
        delegate: Text { text: 'Name: ' + place.name }
    }
    //! [RecommendationModel]

    //! [SearchSuggestionModel]
    PlaceSearchSuggestionModel {
        id: suggestionModel
        searchArea: BoundingCircle {
            center: Coordinate {
                // Brisbane
                longitude: 153.02778
                latitude: -27.46778
            }
        }

        onSearchTermChanged: execute()
    }

    ListView {
        model: suggestionModel
        delegate: Text { text: suggestion }
    }
    //! [SearchSuggestionModel]

    //! [Ratings]
    Text {
        text: "This place is rated " + place.ratings.average + " out of " + place.ratings.maximum + " stars."
    }
    //! [Ratings]

    //! [ContactDetails read]
    function printContactDetails(contactDetails) {
        var keys = contactDetails.keys();
        for (var i = 0; i < keys.length; ++i) {
            var contactList = contactDetails[keys[i]];
            for (var j = 0; j < contactList.length; ++j) {
                console.log(contactList[j].label + ": " + contactList[j].value);
            }
        }
    }
    //! [ContactDetails read]

    //! [ContactDetails write single]
    function writeSingle() {
        var phoneNumber = Qt.createQmlObject('import QtLocation 5.0; ContactDetail {}', place);
        phoneNumber.label = "Phone";
        phoneNumber.value = "555-5555"
        place.contactDetails.phone = phoneNumber;
    }
    //! [ContactDetails write single]

    //! [ContactDetails write multiple]
    function writeMultiple() {
        var bob = Qt.createQmlObject('import QtLocation 5.0; ContactDetail {}', place);
        bob.label = "Bob";
        bob.value = "555-5555"

        var alice = Qt.createQmlObject('import QtLocation 5.0; ContactDetail {}', place);
        alice.label = "Alice";
        alice.value = "555-8745"

        var numbers = new Array();
        numbers.push(bob);
        numbers.push(alice);

        place.contactDetails.phone = numbers;
    }
    //! [ContactDetails write multiple]


    //! [ContactDetails phoneList]
    ListView {
        model: place.contactDetails.phone;
        delegate: Text { text: modelData.label + ": " + modelData.value }
    }
    //! [ContactDetails phoneList]

    //! [Place savePlace def]
    Place {
        id: myPlace
        plugin: myPlugin

        name: "Nokia Brisbane"
        location: Location {
            address: Address {
                street: "53 Brandl Street"
                city: "Eight Mile Plains"
                postalCode: "4113"
                country: "Australia"
            }
            coordinate: Coordinate {
                latitude: -27.579646
                longitude: 153.100308
            }
        }

        visibility: Place.PrivateVisibility
    }
    //! [Place savePlace def]

    function savePlace() {
    //! [Place savePlace]
        myPlace.save();
    //! [Place savePlace]
    }

    function saveToNewPlugin() {
        //! [Place save to different plugin]
        place = Qt.createQmlObject('import QtLocation 5.0; Place { }', parent);
        place.plugin = destinationPlugin;
        place.copyFrom(originalPlace);
        place.save();
        //! [Place save to different plugin]
    }

    function getPlaceForId() {
    //! [Place placeId]
        place.plugin = myPlugin;
        place.placeId = "known-place-id";
        place.getDetails();
    //! [Place placeId]
    }

    function primaryContacts() {
    //! [Place primaryPhone]
        var primaryPhone;
        if (place.contactDetails["phone"].length > 0)
            primaryPhone = place.contactDetails["phone"][0].value;
    //! [Place primaryPhone]
    //! [Place primaryFax]
        var primaryFax;
        if (place.contactDetails["fax"].length > 0)
            primaryFax = place.contactDetails["fax"][0].value;
    //! [Place primaryFax]
    //! [Place primaryEmail]
        var primaryEmail;
        if (place.contactDetails["email"].length > 0)
            primaryEmail = place.contactDetails["email"][0].value;
    //! [Place primaryEmail]
    //! [Place primaryWebsite]
        var primaryWebsite;
        if (place.contactDetails["website"].length > 0)
            primaryWebsite = place.contactDetails["website"][0].value;
    //! [Place primaryWebsite]
    }

    //! [Place favorite]
    Text { text: place.favorite ? place.favorite.name : place.name }
    //! [Place favorite]

    function saveFavorite() {
        var place;
        var destinationPlugin
        //! [Place saveFavorite]
        place.initializeFavorite(destinationPlugin);
        //if necessary customizations to the favorite can be made here.
        //...
        place.favorite.save();
        //! [Place saveFavorite]
    }

    function removeFavorite() {
        var place;
        //! [Place removeFavorite 1]
        place.favorite.remove();
        //! [Place removeFavorite 1]

        //! [Place removeFavorite 2]
        //after detecting successful favorite removal by checking its status
        place.favorite = null;
        //! [Place removeFavorite 2]
    }

    function connectStatusChangedHandler() {
        //! [Place checkStatus]
        place.statusChanged.connect(statusChangedHandler);
        //! [Place checkStatus]
    }

    //! [Place checkStatus handler]
    function statusChangedHandler() {
        if (statusChangedHandler.prevStatus === Place.Saving) {
            switch (place.status) {
            case Place.Ready:
                console.log('Save successful');
                break;
            case Place.Error:
                console.log('Save failed');
                break;
            default:
                break;
            }
        }
        statusChangedHandler.prevStatus = place.status;
    }
    //! [Place checkStatus handler]
}
