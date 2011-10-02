var CommonItem = {
  elements: [],

  observeChange: function(){
    $("#common_item_transaction_type").change(function(){
      CommonItem.typeChange($(this).data("url"));
    });
  },

  tType: function(){
    return $('#common_item_transaction_type').val();
  },

  typeChange: function(url){
    $('#type_based_content').hide();
    $('#loading_image').show();
    $.get( url, {type: this.tType(), type_change: true}, function(){
      onLoadMethods();
      $('#type_based_content').show();
    });
    return false;
  },

  observeAll: function(){
    $("#transaction_type .input-prepend input").bind('click keyup keydown blur focus', function(){
      CommonItem.update_cost();
    });
  },

  update_cost: function(){
    var elements = $("#transaction_type .input-prepend input");

    $('#common_item_cost').attr('disabled', false);
    $('#common_item_cost').val("0");
    var sum = 0;
    for(i =0 ; i < elements.length; i++){
      sum += parseInt($(elements[i]).val() || 0);
    }
    $('#common_item_cost').val(sum);

    if(this.tType() != "0"){
      $('#common_item_cost').attr('disabled', true);
    }
  },

  update_final_cost: function (){
    this.update_cost();
    var elements = $("#transaction_type .input-prepend input");

    var empty = true;
    for(i =0 ; i < elements.length; i++){
      if($(elements[i]).val()){
        empty = false;
      }
    }

    if(isNaN($('#common_item_cost').val()) || empty){
      alert("Give valid values for the items");
      return false;
    }
    $('#common_item_cost').attr('disabled', false);
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
      $('#common_item_cost').attr('disabled', false);
      return this.update_final_cost();
    }
  },

  observeSelectAll: function(){
    $("#transaction_type #select_all").live("click", function (){
      var state;
      var html = $(this).html();

      if( html == "Select All"){
        $(this).html("Unselect All");
        state = true;
      }else{
        $(this).html("Select All");
        state = false;
      }

      $.each($('#new_common_item input[type=checkbox]'), function(index, value){
        value.checked = state;
      });
    });
  }
}