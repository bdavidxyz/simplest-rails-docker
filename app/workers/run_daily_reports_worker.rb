class RunDailyReportsWorker
  include Sidekiq::Worker

  sidekiq_options queue: :high, retry: 3

  def perform(*args)
    ap 'hello from RunDailyReportJob'
  end
end
