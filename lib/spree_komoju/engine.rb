module SpreeKomoju
  mattr_accessor :enable_customer_profiles
  mattr_accessor :komoju_webhook_secret_token

  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_komoju'

    config.after_initialize do
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::KomojuCreditCard
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::KomojuKonbini
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::KomojuBankTransfer
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::KomojuPayEasy
      Rails.application.config.spree.payment_methods << Spree::PaymentMethod::KomojuWebMoney
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      require "active_merchant/billing/gateways/komoju"
      Spree::CheckoutController.send :include, SpreeKomoju::ControllerHelpers
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
