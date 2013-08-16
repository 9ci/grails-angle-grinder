class ListCtrl

  @$inject = ["$scope", "pathWithContext"]
  constructor: ($scope, pathWithContext) ->
    $scope.gridOptions =
      url: pathWithContext("/org/list.json")
      colModel: @colModel()
      multiselect: false # turn off multiselect
      shrinkToFit: true # makes columns fit to width
      sortname: "num"
      sortorder: "asc"

  colModel: ->
    showActionLink = (cellVal, options, rowdata) ->
      """
        <a href="#/#{rowdata.id}">#{cellVal}</a>
      """

    [
      { name: "id", label: "ID", width: 30, formatter: showActionLink }
      { name: "name", label: "Name", width: 100, formatter: showActionLink }
      { name: "num", label: "Num", width: 70 }
    ]

angular.module("angleGrinder")
  .controller("org.ListCtrl", ListCtrl)