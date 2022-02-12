var express = require('express');
var mysql = require('./dbcon.js');
const moment = require('moment')

var app = express();
var handlebars = require('express-handlebars').create({
  helpers: {
    // helper function to convert date to string (can be accepted by html)
    shortDateHelper: function (date, format) {
      return moment(date).format(format);
    },
    // help function to provide a logic operator (return true when v1 == v2)
    // ref: https://stackoverflow.com/questions/8853396/logical-operator-in-a-handlebars-js-if-conditional
    ifCond: function (v1, v2, options) {
      if (v1 === v2) {
        return options.fn(this);
      }
      return options.inverse(this);
    }
  },
  defaultLayout: 'main'
});


app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', process.argv[2]);


app.use(express.urlencoded({
  extended: true
}))

app.get('/', function (req, res, next) {
  res.render('home');
});

// query students (select all)
app.get('/students', function (req, res, next) {
  var query = 'SELECT * FROM eecs_students';
  mysql.pool.query(query, function (err, rows, fields) {
    res.render('students', { data: rows });

  });
});

// query students by filtering
app.post('/query-student', (req, res) => {
  var select = req.body.select;
  var pattern = req.body.pattern;

  console.log(req.body);
  var query = 'SELECT * FROM eecs_students';
  if (pattern != '*') {
    query = `select * from eecs_students where ${select} like '%${pattern}%'`
  } else {
    query = "select * from eecs_students";
  }
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    res.render('students', { data: rows });
  });
})

// delete a student
app.post('/delete-student', (req, res) => {
  var id = req.body.id;

  console.log(req.body);
  var query = `delete FROM eecs_students where id = ${id}`;
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/students');
  });
})

// register a student
app.post('/register-student', (req, res) => {
  var first_name = req.body.first_name;
  var last_name = req.body.last_name;
  var gender = req.body.gender;
  var date_of_birth = req.body.date_of_birth;
  console.log(req.body);
  var query = `INSERT INTO eecs_students (first_name, last_name, gender, date_of_birth) VALUES ( '${first_name}', '${last_name}', '${gender}', '${date_of_birth}')`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/students');
  });

  // res.end();
})

// update a student 
app.post('/update-student', (req, res) => {
  var id = req.body.id;
  var first_name = req.body.first_name;
  var last_name = req.body.last_name;
  var gender = req.body.gender;
  var date_of_birth = req.body.date_of_birth;
  console.log(req.body);
  var query = `update eecs_students set first_name = '${first_name}', last_name = '${last_name}', gender = '${gender}', date_of_birth = '${date_of_birth}' where id = '${id}'`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/students');
  });

})

// read all enrollment, to display the student information and course information, we have a join query to pull data from 3 tables
// also we pull the student and course information so the create-enrollment can have a dropdown to select the foreign keys.
app.get('/enrollment', function (req, res, next) {
  var context = { mapping_data: null, student_data: null, course_data: null };
  var query1 = 'select sc.student_id, s.first_name, s.last_name, sc.course_id, c.name course_name from eecs_students_courses sc left join eecs_students s on s.id = sc.student_id left join eecs_courses c on c.id = sc.course_id;';
  mysql.pool.query(query1, function (err, rows, fields) {
    context.mapping_data = rows
    var query2 = 'select id student_id, first_name, last_name from eecs_students';
    mysql.pool.query(query2, function (err, rows, fields) {
      context.student_data = rows
      var query3 = 'select id course_id, name from eecs_courses';
      mysql.pool.query(query3, function (err, rows, fields) {
        context.course_data = rows
        // console.log(context);
        res.render('enrollment', context);
      });
    });
  });
});


// delete an enrollment
app.post('/delete-enrollment', (req, res) => {
  var student_id = req.body.student_id;
  var course_id = req.body.course_id;
  var student_cond = `student_id = ${student_id}`
  if (student_id == '') {
    student_cond = `student_id is NULL`
  }
  var course_cond = `course_id = ${course_id}`
  if (course_id == '') {
    course_cond = `course_id is NULL`
  }

  console.log(req.body);
  var query = `delete FROM eecs_students_courses where ${student_cond} and ${course_cond}`
  console.log(query)
  mysql.pool.query(query, function (err, rows, fields) {
    if (err) {
      console.log(err);
      next(err);
      return
    }
    res.redirect('/enrollment');
  });
})



// create an enrollment, with the given student id and course id
app.post('/create-enrollment', (req, res) => {
  var student_id = req.body.student_id;
  var course_id = req.body.course_id;

  console.log(req.body);
  var query = `INSERT INTO eecs_students_courses (student_id, course_id) VALUES ( '${student_id}', '${course_id}')`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    if (err) {
      res.render('error', { error: err });
      return;
    } else {
      res.redirect('/enrollment');
    }
  });

  // res.end();
})


// return all instructors
app.get('/instructors', function (req, res, next) {
  var context = {};
  var query = 'SELECT * FROM eecs_instructors';
  mysql.pool.query(query, function (err, rows, fields) {
    context.results = JSON.stringify(rows);
    res.render('instructors', { data: rows });
  });
});

// delete an instructor
app.post('/delete-instructor', (req, res) => {
  var id = req.body.id;

  console.log(req.body);
  var query = `delete FROM eecs_instructors where id = ${id}`;
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/instructors');
  });
})


// create a new instructor
app.post('/register-instructor', (req, res) => {
  var first_name = req.body.first_name;
  var last_name = req.body.last_name;
  var gender = req.body.gender;
  var date_of_birth = req.body.date_of_birth;
  console.log(req.body);
  var query = `INSERT INTO eecs_instructors (first_name, last_name, gender, date_of_birth) VALUES ( '${first_name}', '${last_name}', '${gender}', '${date_of_birth}')`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/instructors');
  });

  // res.end();
})


// query all classrooms
app.get('/classrooms', function (req, res, next) {
  var context = {};
  var query = 'SELECT * FROM eecs_classrooms';
  mysql.pool.query(query, function (err, rows, fields) {
    context.results = JSON.stringify(rows);
    res.render('classrooms', { data: rows });
  });
});

// delete a classroom
app.post('/delete-classroom', (req, res) => {
  var id = req.body.id;

  console.log(req.body);
  var query = `delete FROM eecs_classrooms where id = ${id}`;
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/classrooms');
  });
})

// create a new classroom
app.post('/register-classroom', (req, res) => {

  var building = req.body.building;
  var capacity = req.body.capacity;
  var floor = req.body.floor;
  var type = req.body.type;
  console.log(req.body);
  var query = `INSERT INTO eecs_classrooms (building, capacity, floor, type) VALUES ( '${building}', '${capacity}', '${floor}', '${type}')`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/classrooms');
  });

  // res.end();
})


// query all courses, to display the instructor and classroom information, we use a joined query to pull data from 3 tables
// also get all instructor and classroom information so we can create foreign key dropdown for Create and Update
app.get('/courses', function (req, res, next) {
  var context = { instructor_data: null, classroom_data: null, course_data: null };
  var query1 = 'SELECT c.id, name, current_term_offered, c.capacity, c.instructor_id, c.classroom_id, i.first_name, i.last_name, cl.building classroom FROM eecs_courses c left join eecs_instructors i on i.id = c.instructor_id left join eecs_classrooms cl on cl.id = c.classroom_id';
  mysql.pool.query(query1, function (err, rows, fields) {
    context.course_data = rows;
    var query2 = 'SELECT id as instructor_id, first_name, last_name from eecs_instructors';
    mysql.pool.query(query2, function (err, rows, fields) {
      context.instructor_data = rows;
      var query3 = 'SELECT id as classroom_id, building as classroom from eecs_classrooms';
      mysql.pool.query(query3, function (err, rows, fields) {
        context.classroom_data = rows;
        res.render('courses', context);
      });
    });
  });
});


// delete a course
app.post('/delete-course', (req, res) => {
  var id = req.body.id;

  console.log(req.body);
  var query = `delete FROM eecs_courses where id = ${id}`;
  mysql.pool.query(query, function (err, rows, fields) {
    res.redirect('/courses');
  });
})




// create a course
app.post('/register-course', (req, res) => {

  var name = req.body.name;
  var current_term_offered = 0;
  if (req.body.current_term_offered == 'on') {  // convert html value to sql int type
    current_term_offered = 1;
  }
  var capacity = req.body.capacity;
  var instructor_id = req.body.instructor_id;
  var classroom_id = req.body.classroom_id;
  console.log(req.body);
  var query = `INSERT INTO eecs_courses (name, current_term_offered, capacity, instructor_id, classroom_id) VALUES ( '${name}', '${current_term_offered}', '${capacity}', ${instructor_id}, ${classroom_id})`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    if (err) {
      res.render('error', { error: err });  // note course name is unique, so it could throw err when a duplicated name is used
      return
    } else {
      res.redirect('/courses');
    }
  });
  // res.end();
})

// update a course
app.post('/update-course', (req, res) => {
  console.log(req.body);
  var id = req.body.id;
  var name = req.body.name;
  var current_term_offered = 0;
  if (req.body.current_term_offered == 'on') {
    current_term_offered = 1;
  }
  var capacity = req.body.capacity;
  var instructor_id = req.body.instructor_id;
  var classroom_id = req.body.classroom_id;
  console.log(req.body);
  var query = `update eecs_courses set name = '${name}', current_term_offered = '${current_term_offered}', capacity = '${capacity}', instructor_id = ${instructor_id}, classroom_id = ${classroom_id} where id = '${id}'`;
  console.log(query);
  mysql.pool.query(query, function (err, rows, fields) {
    if (err) {
      res.render('error', { error: err });  // note course name is unique, so it could throw err when a duplicated name is used
      return
    } else {
      res.redirect('/courses');
    }
  });

})

// default handler for 404
app.use(function (req, res) {
  res.status(404);
  res.render('404');
});

// default handler for 500
app.use(function (err, req, res, next) {
  console.error(err.stack);
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function () {
  console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
