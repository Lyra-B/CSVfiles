require 'pry'

class Reader
  attr_accessor :order_list
  attr_accessor :supplier_list

  def initialize (order_list = [], supplier_list = [])
  	@order_list = order_list
    @supplier_list = supplier_list
  end

	def read(file_path)
    File.open(file_path) do |f|
      f.each_line do |l|
        tokens = l.split(',$')
        info_one = tokens[0].split(',')
        info_two = tokens[1].split(',') if tokens[1]
        unless info_one[0] == "PO_NUMBER"
          order = Order.new(
          {:po_number => info_one[0],
          :agency_name => info_one[1],
          :nigp_description => info_one[2, info_one.length-2].join(""),
          :po_total_amount => "${info_two[0]}",
          :order_date => info_two[1],
          :supplier => Supplier.new({:name => info_two[2],
          :address => Address.new({:full_address => info_two[3,info_two.length-5], :city =>info_two[-2],
          :state => info_two[-1]})})})
          @order_list << order
          @supplier_list << order.supplier.name
        end
      end
    end
	end

  def order_amount
  	puts "Number of Orders:#{@order_list.length}"
  end

  def unique_suppliers
    puts "Number of Suppliers:#{@supplier_list.uniq.length}"
  end
end

class Order
	attr_accessor :po_number
	attr_accessor :agency_name
	attr_accessor :nigp_description
	attr_accessor :po_total_amount
	attr_accessor :order_date
	attr_accessor :supplier

	def initialize(options = {})
		options.keys.each do |method_name|
      self.send :"#{method_name}=", options[method_name]
    end
  end
end

class Supplier
	attr_accessor :name
	attr_accessor :address

	def initialize(name_address = {})
		name_address.keys.each do |method_name|
      self.send :"#{method_name}=", name_address[method_name]
    end
	end
end

class Address
	attr_accessor :full_address
	attr_accessor :city
	attr_accessor :state

	def initialize(address = {})
		address.keys.each do |method_name|
      self.send :"#{method_name}=", address[method_name]
    end
	end
end

reader_one = Reader.new
reader_one.read "data.csv"

reader_one.order_amount
reader_one.unique_suppliers