class APVoucher
  
    def enter_lineitems(segment_one, segment_two, segment_three, segment_four, segment_five, purchase_amount, purchase_description, linecount)
          "MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool1' 
           TypeTo line " + linecount.to_s + "  scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool1' , '" + segment_one.to_s + "'
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool2' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool2' , '" + segment_two.to_s + "'
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool3' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool3' , '" + segment_three.to_s + "'
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool4' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool4' , '"+ segment_four.to_s + "'
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool5' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Account Number':'Account_Segment_Pool5' , '" + segment_five.to_s + "'
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Debit Amount' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Debit Amount' , '" + purchase_amount.to_s + "'
           MoveTo field 'Scrolling Window Expand Button' 
           ClickHit field 'Scrolling Window Expand Button' 
           MoveTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Reference' 
           TypeTo line " + linecount.to_s + " scrollwin 'Distribution_Scroll' field 'Distribution Reference' , '" + purchase_description + "'
           TransLinePrepare scrollwin 'Distribution_Scroll' 
           ScrollByLine down scrollwin 'Distribution_Scroll' 
          " 
    end

    def new_voucher(vendor_id, voucher_description, document_number, total_amount)
        "CheckActiveWin dictionary 'default'  form 'PM_Transaction_Entry' window 'PM_Transaction_Entry' 
        MoveTo field 'Vendor ID' 
        TypeTo field 'Vendor ID' , '" + vendor_id + "
        MoveTo field 'Vendor Address Code - Remit To'
        MoveTo field 'Transaction Description' 
        TypeTo field 'Transaction Description' , '" + voucher_description + "
        MoveTo field 'Document Number' 
        TypeTo field 'Document Number' , '" + document_number + "
        MoveTo field 'Purchases Amount' 
        TypeTo field 'Purchases Amount' , '" +  total_amount.to_s + "
        MoveTo field 'Misc Charges Amount' 
        MoveTo field 'Distributions Button'  
        ClickHit field 'Distributions Button' 
        NewActiveWin dictionary 'default'  form 'PM_Transaction_Entry_Distribution' window 'PM_Transaction_Entry_Distribution' 
        "
    end
   
    def save_voucher  #after line items entered need to save
     "MoveTo field 'OK Button' 
      ClickHit field 'OK Button' 
      NewActiveWin dictionary 'default'  form 'PM_Transaction_Entry' window 'PM_Transaction_Entry' 
      MoveTo field 'Save Button' 
      ClickHit field 'Save Button''
     "
    end


    
    
  
end