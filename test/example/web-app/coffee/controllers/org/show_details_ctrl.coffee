class ShowDetailsCtrl

  @$inject = ["$scope", "$location", "pathWithContext", "alerts", "org"]
  constructor: ($scope, $location, pathWithContext, alerts, org) ->
    $scope.org = org

    $scope.initGrid = =>
      $scope.gridOptions =
        url: pathWithContext("/org/listContacts/#{org.id}.json")
        colModel: [
          { name: "id", label: "ID", width: 30 }
          { name: "firstName", label: "First name", width: 50 }
          { name: "lastName", label: "Last name", width: 50 }
          { name: "email", label: "Email", width: 70, formatter: "email" }
        ]
        multiselect: false # turn off multiselect
        shrinkToFit: true # makes columns fit to width
        autowidth: true
        sortname: "email"
        sortorder: "asc"

    $scope.save = (org) ->
      return if $scope.editForm.$invalid

      $scope.saving = true

      onSuccess = ->
        $scope.saving = false
        alerts.info("Org address has been updated.")

      onError = -> $scope.saving = false

      org.save success: onSuccess, error: onError

    $scope.delete = (org) ->
      $scope.deleting = true

      callback = ->
        $scope.deleting = false
        $location.path("/")

      org.delete success: callback, error: callback

angular.module("angleGrinder")
  .controller("org.ShowDetailsCtrl", ShowDetailsCtrl)
