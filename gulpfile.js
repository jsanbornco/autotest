process.env.UV_THREADPOOL_SIZE = Math.ceil(Math.max(4, require('os').cpus().length * 1.5));
require('coffee-script/register');
require('./gulpfile.coffee');