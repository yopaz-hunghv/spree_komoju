module Spree
  module CheckoutControllerDecorator
    prepend SpreeKomoju::ControllerHelpers
  end

  Spree::CheckoutController.prepend(CheckoutControllerDecorator)
end
