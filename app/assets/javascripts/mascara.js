jQuery(function($){
   $(".date").mask("99/99/9999",{placeholder:"__/__/____"});
   $(".datetime").mask("99/99/9999 99:99:99",{placeholder:"__/__/____ 00:00:00"});
   $(".telefone").mask("(99) 99999-9999");
   $(".cpf").mask("999.999.999-99");
});