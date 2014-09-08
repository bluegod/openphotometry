// Superhero
// Bootswatch
//= require superhero/js9/js9support
//= require superhero/js9/fitsy.min
//= require superhero/js9/js9.min
//= require superhero/js9/js9plugins
//= require superhero/js9/js9utils
//= require jquery_ujs
//= require superhero/loader
//= require superhero/bootswatch

//= require jquery.datetimepicker



jQuery(document).on('change', '.btn-file :file', function() {
        var input = $(this),
            numFiles = input.get(0).files ? input.get(0).files.length : 1,
            label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            var name = input.attr('name'); // grab name of original
        input.trigger('fileselect', [numFiles, label, name]);
    });

var mask = [0,0,0]

jQuery(document).ready( function() {
    jQuery('#datetimepicker1').datetimepicker({
        format:'d/m/Y H:i:i'
    });

    jQuery('#calendar-but1').click(function(){
        jQuery('#datetimepicker1').datetimepicker('show'); //support hide,show and destroy command
    });

    jQuery('#datetimepicker2').datetimepicker({
        format:'d/m/Y H:i:i'
    });

    jQuery('#calendar-but2').click(function(){
        jQuery('#datetimepicker2').datetimepicker('show'); //support hide,show and destroy command
    });

    $('em[rel=popover]').popover({
        html: true,
        trigger: 'click',
        content: '<img src="'+$('em[rel=popover]').data('img') + '" />'
    });

    $('em[rel=popover2]').popover({
        html: true,
        trigger: 'click',
        content: $('em[rel=popover2]').data('img')
    });

    $('.btn-file :file').on('fileselect', function(event, numFiles, label, name) {
        var friendlyName;
       switch(name){
           case "darks[]":
               friendlyName = "darks";
               mask[0]=1;
               break;
           case "flat[]":
               friendlyName = "flat";
               mask[1] =1;
               break;
           case "data[]":
               friendlyName = "images";
               mask[2] =1;
               break;
       }
        console.log(mask[1]);
        $("#console").prepend('<p class="text-success">Uploaded: ' + numFiles + ' ' + friendlyName + '.</p>');
        if((mask[0] + mask[1] + mask[2]) == 3){
            $("#console").prepend('<p class="text-info">Once you are done don\'t forget to fill the rest of the fields and press submit.</p>');
            $("#console").prepend('<p class="text-info">File/Open and choose the 1st image. Select the target 1st using Regions/circle. Select further comparison stars. You may need to play with the contrast/bias or scale/zoom.</p>');
            $("#console").prepend('<p class="text-info">You can now select the target / comparison stars on the right.</p>');
        }
    });
})