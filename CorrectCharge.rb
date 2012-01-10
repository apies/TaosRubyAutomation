require 'csv'
class Charge

  attr_accessor  :description, :cardholder, :date, :purpose, :dbcr, :amount, :company, :created_at, :updated_at, :approved, :coding_id, :client,
                        :dellref, :car_rentname, :car_rentcity, :car_rentstate, :car_rentdate, :car_returncity, :car_returnstate, :car_returndate, :car_rentdays,
						  :hotel_arrive, :hotel_city, :hotel_state, :hotel_checkout, :hotel_duration, :air_route, :air_depart, :air_traveler, :billable
  
  def initialize(charge)
    @cardholder = charge[:cardholder]
  	@date = charge[:date]
  	@description = charge[:description]
  	@amount = charge[:amount]
  	@dellref = charge[:dellref]
  	@car_rentname = charge[:car_rentname]
  	@car_rentcity = charge[:car_rentcity]
  	@car_rentstate = charge[:car_rentstate]
  	@car_rentdate = charge[:car_rentdate]
  	@car_returncity = charge[:car_returncity]
    @car_returnstate  = charge[:car_returnstate] 
    @car_returndate   = charge[:car_returndate]
    @car_rentdays   = charge[:car_rentdays] 
    @hotel_arrive   = charge[:hotel_arrive] 
    @hotel_city   = charge[:hotel_city] 
    @hotel_state   = charge[:hotel_state]  
  	@hotel_checkout = charge[:hotel_checkout]
  	@hotel_duration  = charge[:hotel_duration] 
  	@air_route  = charge[:air_route] 
  	@air_depart  = charge[:air_depart]
  	@air_traveler = charge[:air_traveler]
  end
 
  def to_s
    "#{self.amount} was lit on fire by #{self.cardholder} this month"
  end


end


class CellIndex
  
  attr_accessor :cell_value, :cell_index, :row_hash
  
  #intialize method makes a hash out of header row so i can index by column header name string
  def initialize(row_array)
    row_hash = {}
    i = 0
    for row in row_array
      row_hash[row] = i
      i += 1
    end
    @row_hash = row_hash
  end

  
end



class Charges
  
  include Enumerable
  
  attr_accessor :charges
  
  def initialize
    index = 0
    charges = []
    row_count = 0
    header_key = {}
    CSV.foreach( './december.CSV' , :headers => false) do |row|
      if row_count == 0
        header_row = CellIndex.new(row)
        header_key = header_row.row_hash
        #puts header_key
        #puts header_key["CARDMEMBER_NAME"]
    
    
      else
        require 'date'
         stringdate = Date.strptime(row[header_key["PROCESS_DATE"]], '%m-%d-%y')
     
         amount = row[header_key["BILLING_AMOUNT"]].to_f 
     	   dbcr = row[header_key["DB\\CR_INDICATOR"]] 
     	   if dbcr == "3"
     		   real_amount = 0
     	   elsif dbcr == "2"
     		   real_amount = -amount
     	   elsif dbcr == "4"
     		   real_amount=0
     	   elsif dbcr == "1"
     		   real_amount = amount
     	   end
    
        charge = Charge.new(:cardholder => row[header_key["CARDMEMBER_NAME"]], :date => stringdate, :description => row[header_key["CHARGE_DESCRIPTION_LINE1"]], 
        :amount => real_amount,:dellref => row[header_key["CHARGE_DESCRIPTION_LINE2"]], :air_route => row[header_key["AIR_ROUTING"]], :air_traveler => row[header_key["AIR_PASSENGER_NAME"]])
        #puts charge.cardholder
        charges[row_count -1] = charge  
      end
      
      row_count += 1
     @charges = charges
     end
  
  end
  
  
  
  
  #each method for Enumerable
  def each
    @charges.each { |charge| yield(charge) }
  end


end




class Report
  
  include Enumerable
  
  attr_accessor :employee, :total_amount, :report_date, :charges
  
  def initialize(charge)
    @employee = charge[:employee]
  	@report_date = charge[:report_date]
  	@total_amount = charge[:total_amount]
  	@charges = charge[:charges]
  end
  
  def each
    @charges.each { |charge| yield(charge) }
  end
  
  
  
end







charges = Charges.new

#turning one giant expense report into many individual expense reports grouped by cardholder


reports = charges.group_by { |charge| charge.cardholder }
reports.each do | cardholder, report |
  outfile = "./csvs/#{cardholder}.csv"
  output_csv = File.open(outfile,"w+")
  csv_report = CSV.generate do |csv|
    #below uses inject to find the total amount of each report
    report_sum = report.to_a.inject(0.0){|result, charge| charge.amount + result}
    report.sort_by(&:date).each do |charge|
      csv << [charge.cardholder, charge.description, charge.date, charge.amount, charge.dellref, charge.air_traveler, charge.air_route ]
    end
  end
  puts output_csv.puts csv_report
  
end


