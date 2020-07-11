class RunDailyReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ap 'hello from RunDailyReportJob'
  end
end
