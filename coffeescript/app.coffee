window.lightlist = angular.module "lightlist", [ "ngRoute", "ngAnimate", "LocalStorageModule" ]

lightlist.config ( $routeProvider ) ->
    $routeProvider.when "/",
        templateUrl : "partials/home.html"
        controller : "HomeController"
    $routeProvider.when "/addContact",
        templateUrl : "partials/addContact.html"
        controller : "AddContactController"
    $routeProvider.when "/contact/:id",
        templateUrl : "partials/contact.html"
        controller : "ContactController"
    $routeProvider.when "/editContact/:id",
        templateUrl : "partials/editContact.html"
        controller : "EditController"
    return

lightlist.factory "ContactListService", ( localStorageService ) ->
    pub = {}
    pub.contacts = []

    pub.add = ( info ) ->
        if not info? || not info.name? || not info.phone?
            return false

        curLength = this.contacts.length

        info.displayName = info.name
        if info.surname?
            info.displayName += " " + info.surname

        info.id = this.contacts.length
        this.contacts.push info

        this.save()
        
        return info.id

    pub.update = ( contact ) ->
        if not contact? || not contact.name? || not contact.phone? || not contact.id?
            return false

        contact.displayName = contact.name
        if contact.surname?
            contact.displayName += " " + contact.surname

        oldContact = this.get contact.id
        for key, value of contact
            oldContact[ key ] = value

        this.save()

        return true

    pub.get = ( id ) ->
        for contact in this.contacts
            if contact.id == parseInt( id )
                return contact

    pub.save = ->
        localStorageService.remove "contacts"
        localStorageService.add "contacts", this.contacts


    pub.restore = ->
        this.contacts = localStorageService.get "contacts"
        if not this.contacts?
            this.contacts = []
    pub.removeAll = ->
        this.contacts = []
        this.save()

    return pub

lightlist.factory "GroupService", ( localStorageService ) ->
    pub = {}
    pub.groups = [
        { id : 0, name : "friends" }
        { id : 1, name : "acquaintances" }
    ]
    pub.add = ( name ) ->
        if not name?
            return false
        this.groups.push name
        this.save()
    pub.getName = ( id ) ->
        group = this.getGroup id
        if not group?
            return false
        return group.name

    pub.getGroup = ( id ) ->
        for group in this.groups
            if group.id == parseInt( id )
                return group

    pub.save = ->
        localStorageService.remove "groups"
        localStorageService.add "groups", this.groups
        
    pub.restore = ->
        this.groups = localStorageService.get "groups"
        if not this.groups?
            this.groups = []

    return pub


lightlist.controller "HomeController",  ( $scope, ContactListService ) ->
    $scope.CLS = ContactListService
    ContactListService.restore()

    $scope.orderBy = 'displayName'
    $scope.reverse = false

    $scope.toggleSort = ( orderBy ) ->
        if $scope.orderBy = orderBy
            $scope.reverse = !$scope.reverse
        else
            $scope.orderBy = orderBy

    return

lightlist.controller "ListController", ( $scope, $location, ContactListService, GroupService ) ->
    $scope.CLS = ContactListService
    $scope.GS = GroupService

    ContactListService.restore()

    # // Some test data
    if $scope.CLS.contacts.length == 0
        ContactListService.add
            name : "Ronnie"
            surname : "O'Sullivan"
            phone : "555-6000"

        ContactListService.add
            name : "Peter"
            surname : "Parker"
            phone : "555-6001"

        ContactListService.add
            name : "Tyrion"
            surname : "Lannister"
            phone : "555-6002"

    $scope.openContact = ( id ) ->
        $location.path "/contact/" + id

    return

lightlist.controller "AddContactController", ( $scope, $location, ContactListService, GroupService ) ->
    $scope.GS = GroupService
    $scope.CLS = ContactListService
    $scope.newcontact = {}

    $scope.add = ->
        if ContactListService.add $scope.newcontact
            $location.path "/"
        else
            alert "THIS IS UNACCEPTABLE!!"

    return

lightlist.controller "ContactController", ( $scope, $routeParams, ContactListService, GroupService ) ->
    $scope.GS = GroupService

    ContactListService.restore()
    $scope.contact = ContactListService.get $routeParams.id

    return

lightlist.controller "EditController", ( $scope, $routeParams, $location, ContactListService, GroupService ) ->
    $scope.GS = GroupService

    ContactListService.restore()
    $scope.contact = clone( ContactListService.get $routeParams.id )

    $scope.edit = ->
        if ContactListService.update $scope.contact
            $location.path "/"
        else
            alert "THIS IS UNACCEPTABLE!!"