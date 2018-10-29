  # set lets
  $worker  = 2
  $timeout = 30
  $app_dir = "/var/www/rails/rooted_learning" #自分のアプリケーション名
  $listen  = File.expand_path 'tmp/sockets/.unicorn.sock', $app_dir
  $pid     = File.expand_path 'tmp/pids/unicorn.pid', $app_dir
  $std_log = File.expand_path 'log/unicorn.log', $app_dir
  # set config
  worker_processes  $worker
  working_directory $app_dir
  stderr_path $std_log
  stdout_path $std_log
  timeout $timeout
  listen  $listen
  pid $pid
  # loading booster
  preload_app true
  # before starting processes
  before_fork do |server, worker|
    defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!
    old_pid = "#{server.config[:pid]}.oldbin"
    if File.exist?(old_pid) && old_pid != server.pid
      begin
        sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
        Process.kill(sig, File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
        logger.error e
      end
    end
  end
  # after finishing processes
  after_fork do |server, worker|
    defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
  end
