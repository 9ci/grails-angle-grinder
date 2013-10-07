class ListCtrl

  @$inject = ["$scope", "sampleData", "editDialog"]
  constructor: ($scope, sampleData, editDialog) ->
    @data = sampleData.generate(100)
    $scope.data = @data

    $scope.gridOptions =
      data: @data
      datatype: "local"
      colModel: @gridColumns()
      sortname: "id"

    $scope.editItem = (id) =>
      item = @findItemById(id)
      item.persisted = -> true
      item.save = (callback) -> callback.success(this)

      self = this
      item.delete = (callback) ->
        self.deleteItemById(id)
        callback.success(this)

      editDialog.open("templates/partials/itemForm.html", item, $scope.grid)

    $scope.createItem = =>
      item = {}
      item.persisted = -> false
      item.save = (callback) ->
        generateId = -> new Date().getTime()
        item.id = generateId()
        callback.success(this)

      editDialog.open("templates/partials/itemForm.html", item, $scope.grid)
        .then (item) => @data.push(item)

    $scope.deleteItem = (id) =>
      item = @deleteItemById(id)
      $scope.grid.removeRow(item.id)

  findItemById: (id) ->
    id = parseInt(id)
    _.find @data, (row) ->
      row.id is id

  deleteItemById: (id) ->
    row = @findItemById(id)
    if row?
      @data = _.reject @data, (item) -> item.id is row.id
      return row

  gridColumns: ->
    [
      name: "id"
      label: "Inv No"
      width: 80
      sorttype: "int"
    ,
      name: "customer.name"
      label: "Customer"
      formatter: "editActionLink"
    ,
      name: "invoiceDate"
      label: "Date"
    ,
      name: "note"
      label: "Note"
    ,
      name: "complete"
      label: "Complete"
    ]

angular.module("angleGrinder")
  .controller("ListCtrl", ListCtrl)
