(function( Factlink ) {
Factlink.conf = {
    api: {
        loc: "http://development.factlink.com"
    },
    lib: {
        loc: "http://static.factlink.com/lib"
    }
};

Factlink.conf.css = {
    loc: Factlink.conf.lib.loc + "/src/css/basic.css?" + (new Date()).getTime()
};
})( window.Factlink );