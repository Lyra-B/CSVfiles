require 'pry'

class Reader
  attr_accessor :order_list

  def initialize (order_list = [])
  	@order_list = order_list
  end

	def read(file_path)
    File.open(file_path) do |f|
      f.each_line do |l|
        tokens =  l.split(",")
        unless tokens[0] == "PO_NUMBER"
          order = Order.new(
            {:po_number => tokens[0],
            :agency_name => tokens[1],
            :nigp_description => tokens[2],
            :po_total_amount => tokens[3],
            :order_date => tokens[4],
            :supplier => Supplier.new( {:name => tokens[5],
            :address => Address.new({:full_address => tokens[6], :city =>tokens[7],
            :state => tokens[8]})})})
          @order_list << order
        #binding.pry

        # order = Order.new({:blah => "blah", :supplier => Supplier.new(:name => "Makis",
        # 	:address => Address.new({:full_address => "blah", :city = "Athens"}))})
        end
      end
    end
	end

  def order_amount
  	puts "#{@order_list.length}"
  end

  def unique_suppliers
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
  #po_number, agency_name, nigp_description, po_total_amount,
	#order_date,supplier)
		options.keys.each do |method_name|
      self.send :"#{method_name}=", options[method_name]
    end
	# 	@po_number = options[:po_number]
	# 	@agency_name = options [:agency_name]
	# 	@nigp_description = option[:nigp_description]
	# 	@po_total_amount = options[:po_total_amount]
	# 	@order_date = options [:order_date]
	# 	@supplier = options[:supplier]
  end
end

class Supplier
	attr_accessor :name
	attr_accessor :address

	def initialize(name_address = {})
		name_address.keys.each do |method_name|
      self.send :"#{method_name}=", name_address[method_name]
    end
		# @name = name
		# @address = address
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
		# @full_address = address[:full_address]
		# @city = address[:city]
		# @state = address[:state]
	end
end

reader_one = Reader.new
reader_one.read "data.csv"

reader_one.order_amount