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
        tokens = l.split(',')
        # binding.pry
        # tokens =  l.split(',')
        # binding.pry
        unless tokens[0] == "PO_NUMBER"
          order = Order.new(
          {:po_number => tokens[-tokens.length],
          :agency_name => tokens[1-tokens.length],
          :nigp_description => tokens[2-tokens.length, tokens.length-8].join(""),
          :po_total_amount => tokens[-6],
          :order_date => tokens[-5],
          :supplier => Supplier.new({:name => tokens[-4],
          :address => Address.new({:full_address => tokens[-3], :city =>tokens[-2],
          :state => tokens[-1]})})})
          @order_list << order
          @supplier_list << order.supplier
        end
      end
    end
	end

  def order_amount
  	puts "#{@order_list.length}"
  end

  def unique_suppliers
  #   @supplier_list.split
    puts "#{@supplier_list.uniq.length}"
    # @supplier_list.each do |l|
    #   puts "#{l}"
    # end
    # uniq_sup = @supplier_list.uniq
    # # uniq_sup.each do |l|
    # #   puts "#{l}"
    # # end
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