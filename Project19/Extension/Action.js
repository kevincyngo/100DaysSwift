//There are two functions: run() and finalize(). The first is called before your extension is run, and the other is called after.
//Apple expects the code to be exactly like this, so you shouldn't change it other than to fill in the run() and finalize() functions.

var Action = function() {};

Action.prototype = {

run: function(parameters) {

},

finalize: function(parameters) {

}

};

var ExtensionPreprocessingJS = new Action
