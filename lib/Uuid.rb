class Uuid
  def self.validate?(uuid)
    return true if uuid =~ /\A[\da-f]{32}\z/i
    return true if
      uuid =~ /\A(urn:uuid:)?[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}\z/i
  end
end
