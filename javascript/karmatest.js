'use strict';

describe('Contact List Service tests', function () {
    var scope;

    beforeEach(angular.mock.module('lightlist'));
    beforeEach( angular.mock.inject( function ( ContactListService ) {
        ContactListService.removeAll();
        ContactListService.restore();
    }));

    it(
        "should increase the number of total contacts if a valid contact is added",
        angular.mock.inject( function ( ContactListService ) {

            expect( ContactListService.contacts.length ).toBe(0);

            ContactListService.add({
                name : "Jon",
                phone : 555666444
            })

            expect( ContactListService.contacts.length ).toBe(1);
        })
    );

    it(
        "should add a display name when a valid contact is inserted",
        angular.mock.inject( function ( ContactListService ) {

            var id = ContactListService.add({
                name : "Jon",
                surname : "Snow",
                phone : 5564777
            });

            var contact = ContactListService.get( id );

            expect( typeof contact ).not.toBeUndefined();
            expect( contact.id ).toBe( 0 );
            expect( contact.displayName ).toBe( "Jon Snow" );

        })
    );

    it(
        "should be able to change the user info if a valid userobject with valid ID is provided",
        angular.mock.inject( function ( ContactListService ) {

            var id = ContactListService.add({
                name : "Jon",
                surname : "Snow",
                phone : 5564777
            });

            var contact = ContactListService.get( id );
            var changedContact = clone( ContactListService.get( id ) );


            changedContact.name = "Ygritte";

            expect( changedContact ).not.toEqual( contact );

            ContactListService.update( changedContact );

            expect( changedContact ).toEqual( contact );

        })
    );
});