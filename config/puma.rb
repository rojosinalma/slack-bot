env               = ENV.fetch("RACK_ENV", "development")
max_threads_count = ENV.fetch("PUMA_MAX_THREADS", 5)
min_threads_count = ENV.fetch("PUMA_MIN_THREADS", max_threads_count)
puma_port         = ENV.fetch("PUMA_PORT", 3000)

environment     env
threads         min_threads_count, max_threads_count
port            puma_port
rackup          'config.ru'
pidfile         'tmp/pids/puma.pid'
state_path      'tmp/pids/puma.state'
stdout_redirect('log/access.log', 'log/error.log', true) if env == "production"
