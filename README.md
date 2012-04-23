ar_counter
==========

Behave similar to ActiveRecord counter cache but it will put the counter on separate table.

note:
Only works with MySQL database


== Example

You need to create a stats table for the model that you want to count.

=== Model :

  class Driver < ActiveRecord::Base 
    has_many :cars
    has_stats_for :cars
  end 

  class Car < ActiveRecord::Base 
    belongs_to :driver
    stats_to :driver
  end

=== Migration :

  create_table :drivers, :force => true do |t| 
    t.string :name  
  end

  create_table :cars, :force => true do |t| 
    t.string :brand  
    t.integer :driver_id  
  end  

  create_table :driver_stats, :force => true do |t|
    t.integer :driver_id
    t.integer :cars_count, :default => 0
  end
  
  # unique index must be created for MySQL ON DUPLICATE KEY UPDATE to work
  add_index :driver_stats, :driver_id, :unique => true

=== Create stats records for existing model

  rake rebuild_counter_cached MODEL=Driver

== How to use 

  @driver.cars_count

