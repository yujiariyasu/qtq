class WebpushTask
  def self.execute
    User.all.each { |u| u.webpush }
  end
end

WebpushTask.execute
