module StringExtensions
  refine String do
    def sanitize
      self.downcase.strip
    end
  end
end
