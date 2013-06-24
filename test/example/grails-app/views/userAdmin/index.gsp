<html>
  <head>
  <meta name='layout' content='agAdmin'/>
  <g:set var="entityName" value="${ag.label(code:"user")}" />
  <title>${entityName} Admin</title>
  <r:require modules="ag-boot-css,ag-grid-css"/>
  <r:require modules="ag-boot-jq-ui"/>
  <r:require modules="ag-gridz"/>
  <r:require modules="ag-util"/>
  <r:require modules="angular-ui,angular-bootstrap,angular-scaffolding"/>
  <style type="text/css">
    .select2-container{
      background-color: #fff
    }
    .form-horizontal.form-multi-column .control-label {
      width: 100px;
    }
    .form-horizontal.form-multi-column .controls{
      margin-left: 120px;
    }
    .form-horizontal.form-multi-column .form-actions {
      padding-left: 120px;
    }
    .input-prepend,.input-append{
      width:100%;
    }
    .input-prepend .add-on{
      width:10%;
    }
    .input-prepend .input-block-level{
      width:90%;
    }

  </style>
  </head>
<body id="User Admin" >
  
<h3 class="page-header"><g:message code="default.list.label" args="[entityName]" /></h3>
<div ng-controller="ListCtrl" ng-init="editTemplateUrl = '${createLink(action: 'editPartial')}' ">
  
  <g:hasErrors bean="${error}">
    <div class="errors"><g:renderErrors bean="${error}" as="list"/></div>
  </g:hasErrors>

  <div id="spinner" style="display:none;width:10px;position: absolute;"></div>

  <div ng-controller="SearchFormCtrl" collapse="!showSearchForm" ng-include="'${createLink(action: 'searchPartial')}'" ></div>

  <div class="navbar navbar-grid">
    <div class="navbar-inner with-selected-pointer with-grid-options">
      <ul class="nav">
        <li>
          <a href="#editModal" ng-click="createDialog()">
            <i class="icon-user"></i><g:message code="default.new.label" args="[entityName]" />
          </a>
        </li>
      </ul>
      <ul class="nav pull-right">
        <li><a title="search screen" ng-click="showSearchForm = !showSearchForm"><i class="icon-search"></i></a></li>
      </ul>
      <form action="" class="navbar-search pull-right" ng-submit="quickSearch(search)">
        <input type="text" value="" placeholder="quick search" class="search-query span2" style="width: 150px;" ng-model="search.quickSearch"/>
      </form>
    </div>
  </div><!--end navbar-grid-->
  <!--table id="contactGrid"></table>
  <div id="gridPager"></div-->

  <div ng-controller="GridCtrl" ag-grid="gridOptions"></div>

</div>



<script type="text/javascript">
<r:script>
  function GridCtrl($scope) {

    var colModel = ${g.include(action: 'columnModel')}

    var popupHtml = '<ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu" > \
        <li><a href="#" class="row_action_edit" data-dismiss="clickover" ng-click="quickSearch(search)" ><i class="icon-edit"></i> edit</a></li> \
        <li><a href="#" class="row_action_delete" data-dismiss="clickover"><i class="icon-trash"></i> delete</a></li> \
      </ul>'

    $scope.gridOptions = { 
      url:"${createLink(action:'list.json')}",
      colModel:colModel ,
      multiselect:false , //turn off multiselect
      shrinkToFit:true , //makes columns fit to width
      sortname: 'login' , 
      sortorder: 'asc', 
      actionPopup: { 
        menuList: popupHtml
      },
      gridComplete:function(){
        //var g = $(this)
        //turn auto-sizing of columns back off
        $(this).jqGrid("setGridParam",{shrinkToFit:false})
        // var scope = angular.element(g).scope();
        // scope.$apply(function() {
        //   scope.grid = g
        // });
      }
    }

    


  };

  function SearchFormCtrl($scope,$rootScope) {

    $('button[data-select2-open]').click(function(){
        $('#' + $(this).data('select2-open')).select2('open');
    });

    $scope.orgSelectConfig = {
      width: 'resolve',
      dropdownCss:{width:'400px'},
      minimumInputLength: 1,
      ajax: {
        url: "${createLink(controller:'org',action:'pickList')}",
        quietMillis:500, //Number of milliseconds to wait for the user to stop typing before issuing the ajax request
        data: function (term, page) {
          return {
              q: term, // search term
              max:20,
              page:page,
              sort:'name',
              order:'asc'
          }; // query params go here
        },
        results: function (res, page) { // parse the results into the format expected by Select2.
          var more = page < res.total; // whether or not there are more results available
          // notice we return the value of more so Select2 knows if more results can be loaded
          var list = $.map( res.rows, function(n){
            return {"id":n.id,"num":n.num,"name":n.name}
          });
          return { results: list, more:more }
        }
      },
      formatResult: function (item){ 
        return "<table class='table table-condensed' style='margin-bottom:0'><tr><td style='width:60px;border-top:none' >" + item.num + 
          " </td><td style='border-top:none'>" + item.name + "</td></tr><table>"
        //return '<dl class="dl-horizontal"><dt>' + item.num + "</dt><dd>" + item.name + "</dd></dl>"
        //return "<span style='width:50px'>" + item.num + " - </span><span style='width:250px'>" + item.name + "</span>"; 
      },
      formatSelection: function (item){ return item.name; },
      escapeMarkup: function (m) { return m; } // we do not want to escape markup since we are displaying html in results
    }

    $scope.advancedSearch = function(search) {
      //console.log(searchCall)
      $rootScope.$broadcast('searchUpdated', search, $scope)
    }

  };

</r:script>
</script>
</body>
</html>
