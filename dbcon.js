var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : '********',
  password        : '********',
  database        : 'cs340_dengzhi'
});

module.exports.pool = pool;
