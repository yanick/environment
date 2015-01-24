$(function(){

    $('tr').each(function(){
        var $tds = $(this).find('td');
        var merge = false;
        for( var i = 0; i < $tds.size();  i++ ) {
       //     console.log( $tds.eq(i).html() );
            if( ! /^\s*(&nbsp;)?\s*$|^\s*\^/.test($tds.eq(i).html() ) ) {
                return;
            }

            if ( /^\s*\^/.test($tds.eq(i).html() ) ) {
                merge = true;
            }
        }

        if( ! merge ) {  return; }

        var $prev = $(this).prev().find('td');
        for( var i = 0; i < $tds.size();  i++ ) {
            $prev.eq(i).append( $tds.eq(i).html().replace( /^\s*\^/, '' ) );
        }
        $(this).detach();
        
    });
       
$('h1').each(function(){
    $(this).after(
        '<div class="header">' + $(this).html() + '</div>'
    )
});
$('h2').each(function(){
    $(this).after(
        '<div class="subheader">' + $(this).html() + '</div>'
    )
});

$('h2').each(function(){
    if ( ! /^\s*\*/.test( $(this).html() ) ) {
        return
    }

    $(this).addClass('breaker').html( $(this).html().replace( /^\s*\*/, '' ) );
});

});
