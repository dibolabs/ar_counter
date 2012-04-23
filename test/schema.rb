ActiveRecord::Schema.define(:version => 0) do  
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
  
  add_index(:driver_stats, :driver_id, :unique => true)
end