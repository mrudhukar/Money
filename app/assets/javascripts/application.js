// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require rails.validations
//= require rails.validations.myFormBuilders
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require columnizer
//= require jquery.tablesorter.min
//= extensions
//= commonitems
//= require_tree .

function onLoadMethods() {
  $("a.close").bind("click", function (e) {
    $(this).parent("div.alert-message").hide();
  });

  $(".modal a.cancel").bind('click', function(){
    $('.modal').modal('hide');
  });

  $(".datepicker" ).datepicker({dateFormat: 'MM dd, yy'});

  $('ul.lighter.columnize').makeacolumnlists({cols:3,colWidth:100, equalHeight:true, startN:1});
  $('ul.wider.columnize').makeacolumnlists({cols:2,colWidth:200, equalHeight:true, startN:1});

  $("table.sortenabled").tablesorter({sortList: [[1,0]]});
}

$(document).ready(function(){
  onLoadMethods();
});

function openPopup(id){
  $('#'+id).modal({keyboard: true, backdrop: "static", show: true});
  onLoadMethods();
  $('form[data-validate]').validate();
  $('#'+id).bind('hidden', function () {
    $(this).remove();
  });
}