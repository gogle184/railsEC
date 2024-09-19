module FlashHelper
  STATUS = {
    'alert' => 'warning',
    'notice' => 'success',
  }.freeze

  def flash_variant(key)
    STATUS[key]
  end
end
