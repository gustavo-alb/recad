// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require underscore
//= require dependent-fields
//= require twitter/bootstrap
//= require bootstrap
//= require jquery.maskedinput.min
//= require autocomplete-rails
//= require mascara
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require "autocomplete-rails"



$(document).ready(function() {
    DependentFields.bind()
});

$(document).ready(function() {
    $('.datatable').dataTable( {
      
    } );
} );

$('#login_gestor').appendTo("body").modal('show');