/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0
import QtLocation 5.0

TestCase {
    id: testCase

    name: "Place"

    Plugin {
        id: testPlugin
        name: "qmlgeo.test.plugin"
    }

    Place { id: emptyPlace }

    Place { id: emptyPlace2 }

    Place { id: testPlace }

    Place {
        id: savePlace

        name: "Test place"

        visibility: Place.DeviceVisibility

        location: Location {
            address: Address {
                country: "country"
                countryCode: "cc"
                state: "state"
                county: "county"
                city: "city"
                district: "district"
                street: "123 Fake Street"
                postalCode: "1234"
            }

            coordinate: Coordinate {
                latitude: 10
                longitude: 10
                altitude: 100
            }

            boundingBox: BoundingBox {
                center: Coordinate {
                    latitude: 10
                    longitude: 10
                    altitude: 100
                }
                width: 100
                height: 100
            }
        }

        ratings: Ratings {
            average: 3.5
            count: 10
        }

        supplier: Supplier {
            name: "Supplier 1"
            supplierId: "supplier-id-1"
            url: "http://www.example.com/supplier-id-1/"
            icon: Icon{
                plugin: testPlugin
                Component.onCompleted:  {
                    parameters.singleUrl = "http://www.example.com/supplier-id-1/icon"
                }
            }
        }

        categories: [
            Category {
                name: "Category 1"
                categoryId: "category-id-1"
                plugin: testPlugin
            },
            Category {
                name: "Category 2"
                categoryId: "category-id-2"
                plugin: testPlugin
            }
        ]

        icon: Icon {
            Component.onCompleted: {
                savePlace.icon.parameters.singleUrl = "http://example.com/test-place.png";
            }
        }
    }

     Place {
         id: dummyPlace
         placeId: "487"
         name: "dummyPlace"
         visibility: Place.PublicVisibility
     }

    // compares two coordinates property by property
    function compare_coordinate(coord1, coord2) {
        return coord1.latitude === coord2.latitude &&
               coord1.longitude === coord2.longitude &&
               coord1.altitude === coord2.altitude;
    }

    // compares two places property by property
    function compare_place(place1, place2) {
        // check simple properties
        var simpleProperties = ["name", "placeId", "primaryPhone", "primaryFax", "primaryEmail",
                                "primaryUrl", "visibility"];
        for (x in simpleProperties) {
            if (place1[simpleProperties[x]] !== place2[simpleProperties[x]])
                return false;
        }

        // check categories
        if (place1.categories.length !== place2.categories.length)
            return false;
        for (var i = 0; i < place1.categories.length; ++i) {
            // fixme, what if the order of the two lists are not the same
            if (place1.categories[i].categoryId !== place2.categories[i].categoryId)
                return false;
            if (place1.categories[i].name !== place2.categories[i].name)
                return false;
        }

        // check supplier
        if (place1.supplier === null && place2.supplier !== null)
            return false;
        if (place1.supplier !== null && place2.supplier === null)
            return false;
        if (place1.supplier !== null && place2.supplier !== null) {
            if (place1.supplier.supplierId !== place2.supplier.supplierId)
                return false;
            if (place1.supplier.name !== place2.supplier.name)
                return false;
            if (place1.supplier.url !== place2.supplier.url)
                return false;

            // check supplier icon
            if (place1.supplier.icon === null && place2.supplier.icon !== null)
                return false;
            if (place1.supplier.icon !== null && place2.supplier.icon === null)
                return false;
            if (place1.supplier.icon !== null && place2.supplier.icon !== null) {
                if (place1.supplier.icon.parameters.keys().length !== place2.supplier.icon.parameters.keys().length) {
                    return false;
                }

                var keys = place1.supplier.icon.parameters.keys() + place2.supplier.icon.parameters.keys();
                for (var i = 0; i < keys.length; ++i) {
                    if (place1.supplier.icon.parameters[keys[i]] != place2.supplier.icon.parameters[keys[i]]) {
                        return false;
                    }
                }

                if (place1.supplier.icon.plugin !== place2.supplier.icon.plugin)
                    return false;
            }
        }

        // check ratings
        if (place1. ratings === null && place2.ratings !== null)
            return false;
        if (place1.ratings !== null && place2.ratings === null)
            return false;
        if (place1.ratings !== null && place2.ratings !== null) {
            if (place1.ratings.average !== place2.ratings.average)
                return false;
            if (place1.ratings.count !== place2.ratings.count)
                return false;
        }

        // check location
        if (place1.location === null && place2.location !== null)
            return false;
        if (place1.location !== null && place2.location === null)
            return false;
        if (place1.location !== null && place2.location !== null) {
            if (place1.location.address.country !== place2.location.address.country)
                return false;
            if (place1.location.address.countryCode !== place2.location.address.countryCode)
                return false;
            if (place1.location.address.state !== place2.location.address.state)
                return false;
            if (place1.location.address.county !== place2.location.address.county)
                return false;
            if (place1.location.address.city !== place2.location.address.city)
                return false;
            if (place1.location.address.district !== place2.location.address.district)
                return false;
            if (place1.location.address.street !== place2.location.address.street)
                return false;
            if (place1.location.address.postalCode !== place2.location.address.postalCode)
                return false;

            /*
            if (!compare_coordinate(place1.location.coordinate, place2.location.coordinate))
                return false;
            console.log("location.coordinate is equal");
            if (!compare_coordinate(place1.location.boundingBox.bottomLeft, place2.location.boundingBox.bottomLeft))
                return false;
            console.log("location.boundingBox.bottomLeft is equal");
            if (!compare_coordinate(place1.location.boundingBox.bottomRight, place2.location.boundingBox.bottomRight))
                return false;
            console.log("location.boundingBox.bottomRight is equal");
            if (!compare_coordinate(place1.location.boundingBox.topLeft, place2.location.boundingBox.topLeft))
                return false;
            console.log("location.boundingBox.topLeft is equal");
            if (!compare_coordinate(place1.location.boundingBox.topRight, place2.location.boundingBox.topRight))
                return false;
            console.log("location.boundingBox.topRight is equal");
            if (!compare_coordinate(place1.location.boundingBox.center, place2.location.boundingBox.center))
                return false;
            console.log("location.boundingBox.center is equal");
            console.log(place1.location.boundingBox.height + " eq " + place2.location.boundingBox.height);
            if (place1.location.boundingBox.height !== place2.location.boundingBox.height)
                return false;
            console.log(place1.location.boundingBox.width + " eq " + place2.location.boundingBox.width);
            if (place1.location.boundingBox.width !== place2.location.boundingBox.width)
                return false;
            console.log("location.boundingBox is equal");
            */
        }

        // check icon
        if (place1.icon === null && place2.icon !== null) {
            console.log("f1");
            return false;
        }
        if (place1.icon !== null && place2.icon === null) {
            console.log("f2");
            return false;
        }
        if (place1.icon !== null && place2.icon !== null) {
            if (place1.icon.plugin !== place2.icon.plugin) {
                console.log("f3");
                console.log(place1.icon.plugin + " " + place2.icon.plugin);
                return false;
            }

            if (place1.icon.parameters.keys().length !== place2.icon.parameters.keys().length) {
                console.log("f4");
                return false;
            }

            var keys = place1.icon.parameters.keys() + place2.icon.parameters.keys();
            for (var i = 0; i < keys.length; ++i) {
                if (place1.icon.parameters[keys[i]]
                        != place2.icon.parameters[keys[i]]) {
                    return false;
                }
            }
        }

        // check extended attributes

        return true;
    }

    function test_emptyPlace() {
        // basic properties
        compare(emptyPlace.plugin, null);
        compare(emptyPlace.categories.length, 0);
        compare(emptyPlace.name, "");
        compare(emptyPlace.placeId, "");
        compare(emptyPlace.detailsFetched, false);
        compare(emptyPlace.status, Place.Ready);
        compare(emptyPlace.primaryPhone, "");
        compare(emptyPlace.primaryFax, "");
        compare(emptyPlace.primaryEmail, "");
        compare(emptyPlace.primaryWebsite, "");
        compare(emptyPlace.visibility, Place.UnspecifiedVisibility);
        compare(emptyPlace.attribution, "");

        // complex properties
        compare(emptyPlace.ratings.average, 0);
        compare(emptyPlace.location.address.street, '');
        compare(emptyPlace.location.address.district, '');
        compare(emptyPlace.location.address.city, '');
        compare(emptyPlace.location.address.county, '');
        compare(emptyPlace.location.address.state, '');
        compare(emptyPlace.location.address.country, '');

        compare(emptyPlace.icon.plugin, null);

        compare(emptyPlace.supplier.name, '');
        compare(emptyPlace.supplier.supplierId, '');
        compare(emptyPlace.supplier.url, '');

        compare(emptyPlace.supplier.icon.plugin, null);

        compare(emptyPlace.reviewModel.totalCount, -1);
        compare(emptyPlace.imageModel.totalCount, -1);
        compare(emptyPlace.editorialModel.totalCount, -1);
        compare(emptyPlace.categories.length, 0);

        verify(compare_place(emptyPlace, emptyPlace));
        verify(compare_place(emptyPlace, emptyPlace2));
    }

    function test_basicProperties_data() {
        return [
            { tag: "name", property: "name", signal: "nameChanged", value: "Test Place", reset: "" },
            { tag: "placeId", property: "placeId", signal: "placeIdChanged", value: "test-place-id-1", reset: "" },
            { tag: "visibility", property: "visibility", signal: "visibilityChanged", value: Place.PublicVisibility, reset: Place.UnspecifiedVisibility },
            { tag: "attribution", property: "attribution", signal: "attributionChanged", value: "Place data from...", reset: "" }
        ];
    }

    function test_basicProperties(data) {
        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = testPlace;
        signalSpy.signalName = data.signal;

        // set it property to something new
        testPlace[data.property] = data.value;
        compare(testPlace[data.property], data.value);
        compare(signalSpy.count, 1);

        // set it to the same (signal spy should not increase)
        testPlace[data.property] = data.value;
        compare(testPlace[data.property], data.value);
        compare(signalSpy.count, 1);

        // reset it
        testPlace[data.property] = data.reset;
        compare(testPlace[data.property], data.reset);
        compare(signalSpy.count, 2);

        signalSpy.destroy();
    }

    function test_categories() {
        var categories = new Array(2);
        categories[0] = Qt.createQmlObject('import QtLocation 5.0; Category { categoryId: "cat-id-1"; name: "Category 1" }', testCase, "Category1");
        categories[1] = Qt.createQmlObject('import QtLocation 5.0; Category { categoryId: "cat-id-2"; name: "Category 2" }', testCase, "Category2");

        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = testPlace;
        signalSpy.signalName = "categoriesChanged";

        // set categories to something new
        testPlace.categories = categories;
        compare(testPlace.categories.length, categories.length);

        for (var i = 0; i < categories.length; ++i) {
            compare(testPlace.categories[i].categoryId, categories[i].categoryId);
            compare(testPlace.categories[i].name, categories[i].name);
        }

        compare(signalSpy.count, 2);

        // set categories to the same (signal spy should not increase?)
        testPlace.categories = categories;
        compare(testPlace.categories.length, categories.length);

        for (var i = 0; i < categories.length; ++i) {
            compare(testPlace.categories[i].categoryId, categories[i].categoryId);
            compare(testPlace.categories[i].name, categories[i].name);
        }

        compare(signalSpy.count, 5);    // clear + append + append

        // reset by assignment
        testPlace.categories = new Array(0);
        compare(testPlace.categories.length, 0);
        compare(signalSpy.count, 6);

        signalSpy.destroy();
    }

    function test_supplier() {
        var supplier = Qt.createQmlObject('import QtLocation 5.0; Supplier { supplierId: "sup-id-1"; name: "Category 1" }', testCase, "Supplier1");

        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = testPlace;
        signalSpy.signalName = "supplierChanged";

        // set supplier to something new
        testPlace.supplier = supplier;
        compare(testPlace.supplier, supplier);

        compare(testPlace.supplier.supplierId, supplier.supplierId);
        compare(testPlace.supplier.name, supplier.name);

        compare(signalSpy.count, 1);

        // set supplier to the same
        testPlace.supplier = supplier;
        compare(testPlace.supplier, supplier);

        compare(testPlace.supplier.supplierId, supplier.supplierId);
        compare(testPlace.supplier.name, supplier.name);

        compare(signalSpy.count, 1);

        // reset by assignment
        testPlace.supplier = null;
        compare(testPlace.supplier, null);
        compare(signalSpy.count, 2);

        signalSpy.destroy();
    }

    function test_location() {
        var location = Qt.createQmlObject('import QtLocation 5.0; Location { coordinate: Coordinate{ latitude:10.0 } }', testCase, "Location1");

        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = testPlace;
        signalSpy.signalName = "locationChanged";

        testPlace.location = location;
        compare(testPlace.location.coordinate.latitude, 10.0);
        compare(signalSpy.count, 1);

        testPlace.location = location;
        compare(testPlace.location.coordinate.latitude, 10.0);
        compare(signalSpy.count, 1);

        testPlace.location = null;
        compare(testPlace.location, null);
        compare(signalSpy.count, 2);

        location.destroy();
        signalSpy.destroy();
    }

    function test_ratings() {
        var ratings = Qt.createQmlObject('import QtLocation 5.0; Ratings { average: 3; count: 100 }', testCase, "Rating1");

        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = testPlace;
        signalSpy.signalName = "ratingsChanged";

        testPlace.ratings = ratings;
        compare(testPlace.ratings.average, 3);
        compare(testPlace.ratings.count, 100);
        compare(signalSpy.count, 1);

        testPlace.ratings = ratings;
        compare(testPlace.ratings.average, 3);
        compare(testPlace.ratings.count, 100);
        compare(signalSpy.count, 1);

        testPlace.ratings = null;
        compare(testPlace.ratings, null);
        compare(signalSpy.count, 2);

        ratings.destroy();
        signalSpy.destroy();
    }

    function test_extendedAttributes() {
        verify(testPlace.extendedAttributes);

        testPlace.extendedAttributes["foo"] = Qt.createQmlObject('import QtLocation 5.0; PlaceAttribute { text: "Foo"; label: "Foo label" }', testCase, 'PlaceAttribute');

        verify(testPlace.extendedAttributes.foo);
        compare(testPlace.extendedAttributes.foo.text, "Foo");
        compare(testPlace.extendedAttributes.foo.label, "Foo label");

        testPlace.extendedAttributes["foo"] = null;
        verify(!testPlace.extendedAttributes.foo);
    }

    function test_contactDetailsProperty() {
        verify(testPlace.contactDetails);

        testPlace.contactDetails["phone"] = Qt.createQmlObject('import QtLocation 5.0; ContactDetail { label: "Test Label"; value: "Detail Value" }', testCase, 'ContactDetail');

        verify(testPlace.contactDetails.phone);
        compare(testPlace.contactDetails.phone[0].label, "Test Label");
        compare(testPlace.contactDetails.phone[0].value, "Detail Value");

        testPlace.contactDetails["phone"] = null;
        verify(!testPlace.contactDetails.phone);
    }

    function test_saveload() {
        // Save a place
        var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = savePlace;
        signalSpy.signalName = "statusChanged";

        savePlace.plugin = testPlugin;
        savePlace.icon.plugin = testPlugin;
        savePlace.placeId = "invalid-place-id";

        savePlace.save();

        compare(savePlace.status, Place.Saving);

        // SignalSpy.wait() doesn't seem to work here
        //signalSpy.wait();
        wait(0);
        compare(savePlace.status, Place.Error);

        // try again without an invalid placeId
        savePlace.placeId = "";
        savePlace.save();

        compare(savePlace.status, Place.Saving);

        wait(0);

        compare(savePlace.status, Place.Ready);

        verify(savePlace.placeId !== "");

        signalSpy.destroy();


        // Read a place
        var readPlace = Qt.createQmlObject('import QtLocation 5.0; Place { }', testCase, "test_saveload");

        signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = readPlace;
        signalSpy.signalName = "statusChanged";

        readPlace.plugin = testPlugin;

        readPlace.getDetails();

        compare(readPlace.status, Place.Fetching);

        wait(0);

        compare(readPlace.status, Place.Error);

        readPlace.placeId = "invalid-id";

        readPlace.getDetails();

        compare(readPlace.status, Place.Fetching);

        wait(0);

        compare(readPlace.status, Place.Error);

        readPlace.placeId = savePlace.placeId;

        // verify that read place is not currently the same as what we saved
        verify(!compare_place(readPlace, savePlace));

        readPlace.getDetails();

        compare(readPlace.status, Place.Fetching);

        wait(0);

        compare(readPlace.status, Place.Ready);

        // verify that read place is the same as what we saved
        verify(compare_place(readPlace, savePlace));

        signalSpy.destroy();


        // Remove a place
        var removePlace = Qt.createQmlObject('import QtLocation 5.0; Place { }', testCase, "test_saveload");

        signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
        signalSpy.target = removePlace;
        signalSpy.signalName = "statusChanged";

        removePlace.plugin = testPlugin;

        removePlace.remove();

        compare(removePlace.status, Place.Removing);

        wait(0);

        compare(removePlace.status, Place.Error);

        removePlace.placeId = "invalid-id";

        removePlace.remove();

        compare(removePlace.status, Place.Removing);

        wait(0);

        compare(removePlace.status, Place.Error);

        removePlace.placeId = savePlace.placeId;

        removePlace.remove();

        compare(removePlace.status, Place.Removing);

        wait(0);

        compare(removePlace.status, Place.Ready);

        removePlace.getDetails();

        compare(removePlace.status, Place.Fetching);

        wait(0);

        compare(removePlace.status, Place.Error);

        signalSpy.destroy();
    }

     function test_copy() {
         var place = Qt.createQmlObject('import QtLocation 5.0; Place { }', this);
         place.plugin = testPlugin;
         place.copyFrom(dummyPlace);
         compare(place.placeId, "");
         compare(place.name, "dummyPlace");
         compare(place.visibility, Place.UnspecifiedVisibility);
     }

     function test_contactDetails(data) {
         var place = Qt.createQmlObject('import QtLocation 5.0; Place {}', this);

         var signalSpy = Qt.createQmlObject('import QtTest 1.0; SignalSpy {}', testCase, "SignalSpy");
         signalSpy.target = place;
         signalSpy.signalName = data.signalName;

         var detail1 = Qt.createQmlObject('import QtLocation 5.0; ContactDetail {}', this);
         detail1.label = "Detail1";
         detail1.value = "555-detail1";

         place.contactDetails[data.contactType] = detail1;
         compare(place.contactDetails[data.contactType].length, 1);
         compare(place.contactDetails[data.contactType][0].label, "Detail1");
         compare(place.contactDetails[data.contactType][0].value, "555-detail1");

         compare(place[data.primaryValue], "555-detail1");
         compare(signalSpy.count, 1);
         signalSpy.clear();

         var listView = Qt.createQmlObject('import QtQuick 2.0; ListView { delegate:Text{text:modelData.label + ":" + modelData.value } }', this);
         listView.model = place.contactDetails[data.contactType];
         compare(listView.count, 1);

         var detail2 = Qt.createQmlObject('import QtLocation 5.0; ContactDetail {}', this);
         detail2.label = "Detail2";
         detail2.value = "555-detail2";

         var details = new Array();
         details.push(detail2);
         details.push(detail1);

         place.contactDetails[data.contactType] = details;
         compare(place.contactDetails[data.contactType].length, 2);
         compare(place.contactDetails[data.contactType][0].label, "Detail2");
         compare(place.contactDetails[data.contactType][0].value, "555-detail2");
         compare(place.contactDetails[data.contactType][1].label, "Detail1");
         compare(place.contactDetails[data.contactType][1].value, "555-detail1");

         compare(place[data.primaryValue], "555-detail2");
         compare(signalSpy.count, 1);
         signalSpy.clear();
         listView.model = place.contactDetails[data.contactType];
         compare(listView.count, 2);
     }

     function test_contactDetails_data() {
         return [
                     { tag: "phone", contactType: "phone", signalName: "primaryPhoneChanged", primaryValue: "primaryPhone"},
                     { tag: "fax", contactType: "fax", signalName: "primaryFaxChanged", primaryValue: "primaryFax"},
                     { tag: "email", contactType: "email", signalName: "primaryEmailChanged", primaryValue: "primaryEmail"},
                     { tag: "website", contactType: "website", signalName: "primaryWebsiteChanged", primaryValue: "primaryWebsite"}
         ];
     }
}
