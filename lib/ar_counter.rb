require "ar_counter/version"
require "active_support"

module ARCounter
  extend ActiveSupport::Concern

  included do |target|
    target.class_eval { 
      @@counter_cached ||= [] 
    }
  end 

  module ClassMethods
    def counts_for(*args)
      after_create  :increase_counter_stats
      after_destroy :decrease_counter_stats
      class_eval(<<CODE)
      @@counter_cached = args
CODE
    end 

    def has_counter_for(*args)
      args.each do |a|
        class_eval(<<CODE)
        define_method "#{a.to_s}_count" do
          count_target(a) 
        end
CODE
      end
    end

  end

  def increase_counter_stats
    counter_sql @@counter_cached, 1
  end

  def decrease_counter_stats
    counter_sql @@counter_cached, -1
  end

  def counter_sql(counter_cached, increment_by)
    counter_cached.each do |klas|
      stat_table      = "#{klas}_stats"
      owner_id_column = "#{klas}_id"
      klass_id = self.send("#{klas}_id")
      sql_for_increment(stat_table, stat_column, owner_id_column, klass_id, increment_by)
    end
  end

  # SQL
  def sql_for_subtract(stat_table, stat_column, owner_id_column, klass_id)
    sql = "UPDATE #{stat_table} SET #{stat_column}=#{stat_column}-1 WHERE #{owner_id_column}=#{klass_id}"
    ActiveRecord::Base.connection.execute(sql) if stat_table && owner_id_column && klass_id
  end

  def sql_for_add(stat_table, stat_column, owner_id_column, klass_id)
    sql = "INSERT INTO #{stat_table} (#{owner_id_column},#{stat_column}) VALUES (#{klass_id},1) \
           ON DUPLICATE KEY UPDATE #{stat_column}=#{stat_column}+1"
    ActiveRecord::Base.connection.execute(sql) if stat_table && owner_id_column && klass_id
  end

  def sql_for_increment(stat_table, stat_column, owner_id_column, klass_id, increment_by)
    sql = "INSERT INTO #{stat_table} (#{owner_id_column},#{stat_column}) VALUES (#{klass_id},1) \
           ON DUPLICATE KEY UPDATE #{stat_column}=#{stat_column}+#{increment_by}"
    ActiveRecord::Base.connection.execute(sql) if stat_table && owner_id_column && klass_id
  end

  def stat_column
    "#{self.class.to_s.pluralize.downcase}_count"
  end 

  def count_target(target)
    sql = "SELECT #{target.to_s}_count from #{self.class.to_s.downcase}_stats where #{self.class.to_s.downcase}_id=#{self.id}"
    query = ActiveRecord::Base.connection.execute(sql)
    query.first ? query.first[0].to_i : 0
  end
end
