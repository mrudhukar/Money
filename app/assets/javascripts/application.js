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
//= require columnizer
//= require jquery.tablesorter.min
//= require_tree .

$(document).ready(function(){

    $("a.close").bind("click", function (e) {
        $(this).parent("div.alert-message").hide();
    });
    $( "#datepicker" ).datepicker({dateFormat: 'MM dd, yy'});
    $('ul.columnize').makeacolumnlists({cols:3,colWidth:100, equalHeight:true, startN:1});
    $("table.sortenabled").tablesorter({ sortList: [[1,0]] });
})

var CommonItem = {
  elements: [],

  tType: function(){
    return $('#common_item_transaction_type').val();
  },

  typeChange: function(url){
    var url_with_params = url + '?type=' + this.tType();
    $('loading_image').show();
    new Ajax.Request(url_with_params, {asynchronous:true, evalScripts:true, method:'get'});
    return false;
  },

  observeAll: function(){
//    for(i =0 ; i < this.elements.length; i++){
//    Event.observe(this.elements[i], 'keyup',   function(){CommonItem.update_cost();}, false);
//    Event.observe(this.elements[i], 'keydown', function(){CommonItem.update_cost();}, false);
//    Event.observe(this.elements[i], 'click',   function(){CommonItem.update_cost();}, false);
//    Event.observe(this.elements[i], 'blur', function(){CommonItem.update_cost();}, false);
//    }
  },

  update_cost: function(){
    $('common_item_cost').disabled = false;
    $('common_item_cost').value = 0;
    var sum = 0;
    for(i =0 ; i < this.elements.length; i++){
      sum += parseInt(this.elements[i].value || 0);
    }
    $('common_item_cost').value = sum;

    if(this.tType() != "0"){
      $('common_item_cost').disabled = true;
    }
  },

  update_final_cost: function (){
    this.update_cost();

    if(isNaN($('common_item_cost').value)){
      alert("Give valid values for the items");
      return false;
    }
    $('common_item_cost').disabled = false;
    return true;
  },

  beforeSubmit: function(){
    if(this.tType() == "0"){
      var theForm = $('#new_common_item input[type=checkbox]');
      var z = 0;
      var count = 0;

      for (z = 0; z < theForm.length; z++) {
        if (theForm[z].checked) {
          count += 1;
        }
      }
      if(count == 0){
        alert("Please select atleast one user!");
        return false;
      }
    }else{
      $('common_item_cost').disabled = false;
      return this.update_final_cost();
    }
  },

  selectAll: function(state){
    var theForm = $('#new_common_item input[type=checkbox]');
    var z = 0;
    for (z = 0; z < theForm.length; z++) {
      theForm[z].checked = state;
    }
    $('#select').toggle();
    $('#unselect').toggle();
  }
}