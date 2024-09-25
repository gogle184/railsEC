module OrderHelper
  def order_processing_status(order)
    css_class = case order.status
                when 'shipped'
                  'badge rounded-pill bg-primary'
                when 'completed'
                  'badge rounded-pill bg-success'
                when 'canceled'
                  'badge rounded-pill bg-danger'
                else
                  'badge rounded-pill bg-secondary'
                end

    translated_text = t("enums.order.status.#{order.status}")
    content_tag(:span, translated_text, class: css_class)
  end
end
