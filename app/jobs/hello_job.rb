class HelloJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 5

    p "Hello form the HelloJob #{Time.now.strftime('%F - %H:%M:%S.%L')}}"
  end
end
