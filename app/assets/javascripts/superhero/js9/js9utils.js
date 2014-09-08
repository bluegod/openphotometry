function getJs9Parameters(){
    var array = JS9.GetRegions()
    var regions = ''
    for (var i = array.length-1; i >= 0; i--) {
        regions = regions + array[i].imstr  + '\n'
    }
    $("#stars_location").val(regions);

}