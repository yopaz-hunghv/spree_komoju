module SpreeKomoju
  mattr_accessor :enable_customer_profiles
  mattr_accessor :komoju_webhook_secret_token

  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_komoju'

    config.autoload_paths += %W[#{config.root}/lib]

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      require "active_merchant/billing/gateways/komoju"
      Spree::CheckoutController.send :include, SpreeKomoju::ControllerHelpers
    end

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_komoju.autoloader' do |app|
      if Rails.autoloaders.zeitwerk_enabled?
        Rails.autoloaders.main.ignore("#{root}/app/overrides")
      end
    end

    config.after_initialize do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::KomojuCreditCard
      app.config.spree.payment_methods << Spree::PaymentMethod::KomojuKonbini
      app.config.spree.payment_methods << Spree::PaymentMethod::KomojuBankTransfer
      app.config.spree.payment_methods << Spree::PaymentMethod::KomojuPayEasy
      app.config.spree.payment_methods << Spree::PaymentMethod::KomojuWebMoney
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
