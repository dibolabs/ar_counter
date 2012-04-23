require_relative './test_helper.rb'

require_relative "../lib/ar_counter"

class Driver < ActiveRecord::Base
  include ARCounter
  has_many :cars
  has_counter_for :cars 
end 

class Car < ActiveRecord::Base
  include ARCounter
  belongs_to :driver
  counts_for :driver
end


class ModelCounterTest < Test::Unit::TestCase 
  
  def test_new_user
    @driver = Driver.new(:name => rand(1000))
    @driver.save
   
    assert_equal 0, @driver.cars_count
  end

  def test_new_user_have_one_car
    @driver = Driver.new(:name => rand(1000))
    @driver.save
    
    @car = Car.new(:brand => "BMW", :driver_id => @driver.id)
    @car.save
    
    assert_equal 1, @driver.cars_count
  end
  
  def test_increase_cars_count_when_driver_add_more_car
    @driver = Driver.new(:name => rand(1000))
    @driver.save

    2.times do |i|
      car = Car.new(:brand => "Motor #{i}", :driver_id => @driver.id)
      car.save
    end

    current_car_total = @driver.cars_count

    new_car = Car.new(:brand => 'BMW', :driver_id => @driver.id)
    new_car.save

    assert_equal current_car_total+1, @driver.cars_count
  end  
  
  def test_decrease_cars_count_when_driver_deleted_a_car 
    @driver = Driver.new(:name => rand(1000))
    @driver.save!
    
    2.times do |i|
      car = @driver.cars.build(:brand => "Motor #{i}", :driver_id => @driver.id)
      car.save
    end
    
    current_car_total = @driver.cars_count
    car = Car.last.destroy
    assert_equal current_car_total-1, @driver.cars_count
  end               
  
end