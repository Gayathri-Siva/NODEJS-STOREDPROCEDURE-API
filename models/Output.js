'use strict';

function output() {
	this.is_success = '';
	this.data = '';
	this.message = '';
	// this.token="";
	// this.status= "";
}

output.prototype.is_success = function(is_success) {
	this.is_success = is_success;
};
output.prototype.data = function(data) {
	this.data = data;
};
output.prototype.message = function(message) {
	this.message = message;
};

// output.prototype.token = function (token) {
//     this.token = token;
// };
// output.prototype.status = function (status) {
//     this.status = status;
// };

module.exports = output;
