describe "course collaborators", ->
  scope = $httpBackend = null
  beforeEach ->
    module 'shinebox'
    inject ($rootScope, $controller, $injector, $http) ->
      $rootScope.course = {id: 1}
      scope = $rootScope.$new()
      $httpBackend = $injector.get('$httpBackend')
      ctrl = $controller(CollaboratorsCtrl, {$scope: scope, $http: $http})

  describe 'when login', ->
    describe 'do not exists', ->
      it "should be add", ->
        scope.items = []
        scope.login = 'saberma'
        $httpBackend.when('POST', '/courses/1/collaborators').respond({id: 1})
        scope.add()
        $httpBackend.flush()
        expect(scope.items).toEqual([{id: 1}])
    describe 'exists', ->
      it "should not be add", ->
        scope.items = [{id: 1, login: 'saberma'}]
        scope.login = 'saberma'
        scope.add()
        expect(scope.items).toEqual([{id: 1, login: 'saberma'}])
        expect(scope.error).toBe(true)
  it "should be remove", ->
    scope.items = [{id: 1}]
    $httpBackend.when('DELETE', '/courses/1/collaborators/1').respond()
    scope.remove(0)
    $httpBackend.flush()
    expect(scope.items).toEqual([])
