class HelloController < ApplicationController
  def say_hello
    RunDailyReportJob.set(wait: 15.seconds).perform_later
  end
end
