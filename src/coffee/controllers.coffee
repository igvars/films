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
  "$window"
  ($scope, $http, $window) ->

    $scope.data =
      group: ""

    $scope.films = []
    $scope.busy = false
    page = 1
    lastPage = 1
    oldSearch = ''
    getAllFilms = ->
      if JSON.parse(localStorage.getItem "savedFilms") isnt null
        JSON.parse localStorage.getItem "savedFilms"
      else
        false
    getQuery = (query) ->
      if getAllFilms()
        if getAllFilms()[query] isnt undefined
          getAllFilms()[query]
        else
          false
      else
        false
    getQueryItems = (query) ->
      getQuery(query).items
    getQueryPage = (query) ->
      if getQuery(query)
        parseInt getQuery(query).page, 10
      else
        1
    getQueryTotalResult = (query) ->
      parseInt getQuery(query).totalResults, 10
    getLastPage = (totalResults) ->
      Math.ceil(parseInt(totalResults,10) / ITEMS_PER_PAGE) || 1
    getResponseTotalResults = (totalResults) ->
      parseInt totalResults,10
    saveFilms = (query, films, page, totalResults) ->
      savedFilms = do getAllFilms
      if not savedFilms
        savedFilms = {}
      savedFilms[query] =
        "items": films
        "page": page
        "totalResults": totalResults
      localStorage.setItem "savedFilms", JSON.stringify savedFilms
    updateScope = (films, status, errorMessage, totalResults, newPage) ->
      $scope.films = films
      $scope.status = status
      $scope.errorMessage = errorMessage
      $scope.totalResults = totalResults
      lastPage = getLastPage $scope.totalResults
      page = newPage
      $scope.busy = false
    checkInput = ->
      $scope.search = do $scope.search.trim
      $scope.search = encodeURI $scope.search

    $scope.clearWebStorage = ->
      localStorage.removeItem "savedFilms"
      localStorage.removeItem "savedSingleFilms"
      $window.location.href = "/";

    $scope.fetch = ->
      return if $scope.busy
      do checkInput
      if oldSearch isnt $scope.search
        oldSearch = $scope.search
        if getQuery $scope.search
          page = getQueryPage $scope.search
          $scope.films = getQueryItems $scope.search
          $scope.totalResults = getQueryTotalResult $scope.search
          lastPage = getLastPage $scope.totalResults

        else
          page = 1
          lastPage = 1
          $scope.films = []
          $scope.totalResults = 0

      if $scope.search and page <= lastPage
        if getQuery($scope.search) and page <= getQueryPage $scope.search
          updateScope getQueryItems($scope.search), "True", "", getQueryTotalResult($scope.search), getQueryPage($scope.search) + 1
        else
          $scope.busy = true
          $http.get("http://www.omdbapi.com/?s=#{$scope.search}&page=#{page}")
          .success((response) ->
            if response.Response == "True"
              for film in response.Search
                $scope.films.push film
              saveFilms $scope.search, $scope.films, page, $scope.totalResults
              updateScope $scope.films, response.Response, response.Error, getResponseTotalResults(response.totalResults), page + 1
            else
              $scope.films = []
              saveFilms $scope.search, [], 1, 0
              updateScope [], response.Response, response.Error, 0, 1
          )
          .error( (data, code) ->
            $scope.busy = false
            saveFilms $scope.search, [], 1, 0
            updateScope [], "False", "Something went wrong", 0, 1
          )
]


# view page controller
filmsApp.controller "ViewCtrl", [
  "$scope"
  "$http"
  "$location"
  "$routeParams"
  ($scope, $http, $location, $routeParams) ->

    getSavedSingleFilms = ->
      if JSON.parse(localStorage.getItem "savedSingleFilms") isnt null
        JSON.parse localStorage.getItem "savedSingleFilms"
      else
        false
    getSavedSingleFilm = (id) ->
      if getSavedSingleFilms()
        if getSavedSingleFilms()[id] isnt undefined
          getSavedSingleFilms()[id]
        else
          false
      else
        false
    saveSingleFilms = (id, data) ->
      savedSingleFilms = do getSavedSingleFilms
      if not savedSingleFilms
        savedSingleFilms = {}
      savedSingleFilms[id] =
        "id": id
        "data": data
      localStorage.setItem "savedSingleFilms", JSON.stringify savedSingleFilms

    updateScope = (film, status, errorMessage) ->
      $scope.film = film
      $scope.status = status
      $scope.errorMessage = errorMessage
      $scope.busy = false

    if getSavedSingleFilm $routeParams.filmId
      film = getSavedSingleFilm $routeParams.filmId
      updateScope film.data, film.data.Response, film.data.Error
    else
      $scope.busy = true
      $http.get("http://www.omdbapi.com/?i=#{$routeParams.filmId}&plot=full")
        .then (response) ->
          updateScope response.data, response.data.Response, response.data.Error
          saveSingleFilms $routeParams.filmId, response.data
]