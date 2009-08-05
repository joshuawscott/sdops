function useDescription(field,type){
  $(type+'_support_price_description').value=$(field+'_description').innerHTML;
}
function usePricing(field,type){
  $(type+'_support_price_list_price').value=$(field+'_price').innerHTML;
}
function usePhonePricing(field,type){
  $(type+'_support_price_phone_price').value=$(field+'_price').innerHTML;
}
function useUpdatePricing(field,type){
  $(type+'_support_price_update_price').value=$(field+'_price').innerHTML;
}
function useSwPricing(field,type){
  $(type+'_support_price_phone_price').value = $(field+'_price').innerHTML;
  $(type+'_support_price_update_price').value = "0";
}
