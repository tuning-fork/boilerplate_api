module TempUuidFallback
  extend ActiveSupport::Concern

  included do
    @_uuid = nil

    def uuid
      ret = @_uuid || attributes["uuid"] || self.class.find(self.id).uuid
      @_uuid = ret
      ret
    end
  end

  class_methods do
    def find(id_or_uuid)
      if Uuid.validate?(id_or_uuid)
        self.find_by!(uuid: id_or_uuid)
      else
        self.find_by!(id: id_or_uuid)
      end
    end
  end
end
