class String
  def my_strip
    self.gsub(ActiveSupport::Multibyte::Unicode::LEADERS_PAT, '').gsub(ActiveSupport::Multibyte::Unicode::TRAILERS_PAT, '')
  end
end
