class LogFile
  include MongoMapper::Document

  LOG_TYPES = %w(rails)

  key :sha512, String
  key :log_type, String, :in => LOG_TYPES
  key :key, String, :required => true

  def grid
    @grid ||= Mongo::Grid.new(MongoMapper.database)
  end

  def store_log log, sanitized = true
    if sanitized
      log = log.gsub(/\/(Users|home)\/[\w\d]+\//, '/home/user/')
    end
    grid.delete(id)
    grid.put(log, {
      :_id => id
    })
  end

  def raw_log
    @raw_log ||= grid.get(id).read
  end

  def to_html
    @to_html ||= ERB::Util.html_escape(raw_log)
  end

end