module ProductHelper
  def product_image_tag(product, variant, default_image = 'default_fruits.png')
    img_url = if product.image.attached?
                url_for(product.image.variant(variant).processed)
              else
                asset_path(default_image)
              end

    cover_img_class = variant == :large ? 'product-img-large' : 'product-img-small img_fluid'

    image_tag(img_url, alt: '画像', class: cover_img_class)
  end

  def product_boolean(model, attribute)
    I18n.t("booleans.#{model.class.name.underscore}.#{attribute}.#{model.public_send(attribute)}")
  end
end
