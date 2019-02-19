'use strict';

const mssql = require('mssql');
const dbconfig = require('../models/dbconfig');

exports.query_type = {
	SP: 1,
	Query: 2
};

//exports.execute_await = async (Query, param, query_type) => {
	const con = new mssql.ConnectionPool(dbconfig);
	try {
		//console.log("hello");
		con.on('error', (err) => console.log(err));
		await con.connect();
		const req = await con.request();
		const res = await (async () => {
			if (param)
				param.forEach((element) => {
					req.input(element.name, element.sql_type, element.value);
				});
			if (query_type === 1) {
				let result = await req.execute(Query);
				return result;
			} else {
				await req.query(Query);
				return result;
			}
		})();
		return res;
	} catch (error) {
		return error;
	} finally {
		con.close();
	}
};
exports.execute_await = async (Query, param, query_type) => {
	const con = new mssql.ConnectionPool(dbconfig);
	try {
		//console.log("hello");
		con.on('error', (err) => console.log(err));
		await con.connect();
		const req = await con.request();
		const res = await (async () => {
			if (param)
				param.forEach((element) => {
					req.input(element.name, element.sql_type, element.value);
				});
			if (query_type === 1) {
				let result = await req.execute(Query);
				return result;
			} else {
				let result = await req.query(Query);
				return result;
			}
		})();
		return res;
	} catch (error) {
		return error;
	} finally {
		con.close();
	}
};
