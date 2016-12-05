"use strict"

ITEMS_PER_PAGE = 10

# init the module
filmsApp = angular.module "filmsApp", [
  'ngRoute'
  'ngResource'
  'infinite-scroll'
  'ngMaterial'
]

# configure routing
filmsApp.config [
  "$routeProvider"
  "$locationProvider"
  ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode
      enabled: true
      requireBase: false
    $routeProvider
    .when "/",
      templateUrl: "src/template/home.html"
      controller: "FilmsListCtrl"
    .when "/:filmId",
      templateUrl: "src/template/view.html"
      controller: "ViewCtrl"
    .otherwise
      redirectTo: "/"
]

filmsApp.controller "FilmsListCtrl", [
  "$scope"
  "$http"
  ($scope, $http) ->

    $scope.data =
      group: ""

    $scope.films = []
    $scope.busy = false
    page = 1
    lastPage = 1
    oldSearch = ''
    $scope.fetch = ->
      return if $scope.busy

      if oldSearch isnt $scope.search
        oldSearch = $scope.search
        page = 1
        lastPage = 1
        $scope.films = []
        $scope.totalResults = 0
      if $scope.search and page <= lastPage
        $scope.busy = true
        $http.get("http://www.omdbapi.com/?s=#{$scope.search}&page=#{page}")
        .then((response) ->
          $scope.busy = false
          $scope.status = response.data.Response
          $scope.totalResults = parseInt response.data.totalResults, 10
          lastPage = Math.ceil $scope.totalResults / ITEMS_PER_PAGE
          $scope.errorMessage = response.data.Error
          if response.data.Search
            for film in response.data.Search
              $scope.films.push film
            page += 1
          else
            $scope.films = []
        )
]


# view page controller
filmsApp.controller "ViewCtrl", [
  "$scope"
  "$http"
  "$location"
  "$routeParams"
  ($scope, $http, $location, $routeParams) ->
    $scope.busy = true
    $http.get("http://www.omdbapi.com/?i=#{$routeParams.filmId}&plot=full")
      .then (response) ->
        $scope.busy = false
        $scope.status = response.data.Response
        $scope.errorMessage = response.data.Error
        $scope.film = response.data
]