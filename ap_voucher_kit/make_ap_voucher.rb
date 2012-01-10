require 'CSV'
require './APVoucher'
filename = 'ap_voucher_data.csv'
linecount = 1
document_number = nil
outfile = './output.mac'
output_mac = File.open(outfile,"w+")



CSV.foreach(filename, :headers => true ) do |column|

@row = APVoucher.new



  document_number_fresh = column[1]
  vendor_id  = column[0]
  voucher_description = column[2]
  total_amount = column[3]
  purchase_amount = column[4]
  purchase_description = column[5]
  distribution_account = column[6]


   if (document_number_fresh != document_number && document_number)
    output_mac.puts @row.save_voucher
  end

  
  
  if (document_number_fresh != document_number || document_number == nil)
    output_mac.puts @row.new_voucher(vendor_id, voucher_description, document_number_fresh, total_amount)
    linecount = 1
  end



  document_number = column[1]

  distribution_account = column[6]

  regex = Regexp.new(/([0-9][0-9])-([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9][0-9])-([0-9][0-9])/)
   matchdata = regex.match( distribution_account)
     if matchdata
       segment_one = matchdata[1]
       segment_two = matchdata[2]
       segment_three = matchdata[3]
       segment_four = matchdata[4]
       segment_five = matchdata[5]
     end


  if linecount == 1
     output_mac.puts @row.enter_lineitems(segment_one, segment_two, segment_three, segment_four, segment_five, purchase_amount, purchase_description, linecount)
     linecount = 3
      else
	  
     output_mac.puts @row.enter_lineitems(segment_one, segment_two, segment_three, segment_four, segment_five, purchase_amount, purchase_description, linecount)
   end
  




end