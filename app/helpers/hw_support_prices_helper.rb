module HwSupportPricesHelper
  def description_lookup(name)
    haml_tag :b do
      name.humanize
    end
    link_to_function '<-', "usePricing('#{name}','hw')", :title => "Copy this"
    haml_tag :div, :id => name
  end
  def price_lookup(name)
    haml_tag :b do
      name.humanize
    end
    link_to_function '<-', "usePricing('#{name}','hw')", :title => "Copy this"
    haml_tag :div, :id => name
  end
end
