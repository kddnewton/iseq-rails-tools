module IseqRailsTools
  def self.iseq_path_for(source_path)
    source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
  end
end
