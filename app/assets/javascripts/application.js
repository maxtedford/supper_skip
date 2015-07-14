// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

$(document).ready(function(){
  $(".sidenav").affix({
    offset: {
      top: 0
    }
  });
});

$('.dropdown-toggle').dropdown()

$(document).ready(function(){
  $('a[href*=#]').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
        && location.hostname == this.hostname) {
      var $target = $(this.hash);
      $target = $target.length && $target
        || $('[name=' + this.hash.slice(1) +']');
      if ($target.length) {
        var targetOffset = $target.offset().top;
        $('html,body')
          .animate({scrollTop: targetOffset}, 1000);
        return false;
      }
    }
  });
  $('.toggleCancelled').click(function() {
    $('span:not(.cancelled)').toggle();
  });
  $('.togglePaid').click(function() {
    $('span:not(.paid)').toggle();
  });
  $('.togglePrepReady').click(function() {
    $('span:not(.ready_for_preparation)').toggle();
  });
  $('.togglePrep').click(function() {
    $('span:not(.in_preparation)').toggle();
  });
  $('.toggleDeliveryReady').click(function() {
    $('span:not(.ready_for_delivery)').toggle();
  });
$('.toggleDelivery').click(function() {
    $('span:not(.delivery)').toggle();
  });
  $('.toggleCompleted').click(function() {
    $('span:not(.completed)').toggle();
  });

  });
