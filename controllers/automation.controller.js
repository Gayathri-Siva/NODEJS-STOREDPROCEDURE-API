const application = require('../repository/application.service');
const output = require('../models/output');

exports.addedituser = async function(req, res, next) {
	var _output = new output();
	try {
		let UserCode = req.body.UserCode;
		let UserFName = req.body.UserFName;
		let UserDesignation = req.body.UserDesignation;
		let UserEmailID = req.body.UserEmailID;
		let PhoneNo = req.body.PhoneNo;
		let PersonalEmailID = req.body.PersonalEmailID;
		let UpdatedBy = req.body.UpdatedBy;
		let isActive = req.body.isActive;
		let Password = req.body.Password;
		let UserLName = req.body.UserLName;
		let isInternalUser = req.body.isInternalUser;
		let OrgID = req.body.OrgID;
		let OrgDivID = req.body.OrgDivID;
		let result = await application.addedituser(
			UserCode,
			UserFName,
			UserDesignation,
			UserEmailID,
			PhoneNo,
			PersonalEmailID,
			UpdatedBy,
			isActive,
			Password,
			UserLName,
			isInternalUser,
			OrgID,
			OrgDivID
		);
		_output.data = result;
		_output.is_success = true;
		_output.message = 'addedituser details';
	} catch (error) {
		_output.data = '';
		_output.is_success = false;
		_output.message = error.message;
	}
	res.send(_output);
};
