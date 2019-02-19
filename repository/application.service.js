'use strict';
const db_library = require('../lib/db_library');
const param = require('../models/parameter_input');
const sqlType = require('mssql');

exports.addedituser = async (
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
) => {
	try {
		let _parameters = [];
		let para = new param('UserCode', sqlType.VarChar, UserCode);
		_parameters.push(para);
		para = new param('UserFName', sqlType.NVarChar, UserFName);
		_parameters.push(para);
		para = new param('UserDesignation', sqlType.NVarChar, UserDesignation);
		_parameters.push(para);
		para = new param('UserEmailID', sqlType.NVarChar, UserEmailID);
		_parameters.push(para);
		para = new param('PhoneNo', sqlType.VarChar, PhoneNo);
		_parameters.push(para);
		para = new param('PersonalEmailID', sqlType.NVarChar, PersonalEmailID);
		_parameters.push(para);
		para = new param('UpdatedBy', sqlType.Int, UpdatedBy);
		_parameters.push(para);
		para = new param('isActive', sqlType.Bit, isActive);
		_parameters.push(para);
		para = new param('Password', sqlType.NVarChar, Password);
		_parameters.push(para);
		para = new param('UserLName', sqlType.NVarChar, UserLName);
		_parameters.push(para);
		para = new param('isInternalUser', sqlType.Bit, isInternalUser);
		_parameters.push(para);
		para = new param('OrgID', sqlType.Int, OrgID);
		_parameters.push(para);
		para = new param('OrgDivID', sqlType.Int, OrgDivID);
		_parameters.push(para);
		return await db_library.execute_await('[dbo].[AddEditUser]', _parameters, db_library.query_type.SP);
	} catch (error) {
		return error;
	}
};
