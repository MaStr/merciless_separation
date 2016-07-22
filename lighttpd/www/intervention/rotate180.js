window.onload = scrollDownToTheTop;
function scrollDownToTheTop() {
    window.scrollTo( 0  , document.body.scrollHeight - ( document.body.scrollHeight * 0.15 ) );
}
