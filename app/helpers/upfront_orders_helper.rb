module UpfrontOrdersHelper
  def class_for_pn(pn)
    retval = ""
    if HwSupportPrice.current_list_price(pn).part_number.nil? && SwSupportPrice.current_list_price(pn).part_number.nil?
      retval = "red_bg"
    end
    retval
  end
end
