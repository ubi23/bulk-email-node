exports.index = function(req, res, next) {
  console.log(req.headers);
  //console.log(res);
  res.render('index', { title: 'Bulk Email', formData: {} , req: JSON.stringify(req.headers)});
}