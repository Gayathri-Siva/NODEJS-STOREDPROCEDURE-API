const express = require('express');
const app = express();
const automation_controller = require('./controllers/automation.controller');

const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.post('/addedituser', automation_controller.addedituser);

var server = app.listen(process.env.PORT || 8080, function() {
	var port = server.address().port;
	console.log('App now running on port', port);
});
