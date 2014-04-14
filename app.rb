require 'sinatra'
require 'stripe'
require 'slim'
 
set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']
 
Stripe.api_key = settings.secret_key
 
get '/' do
  slim :index
end
 
post '/charge' do
  @amount = 500
 
  customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :card  => params[:stripeToken]
  )
 
  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge',
    :currency    => 'usd',
    :customer    => customer
  )
 
  slim :charge
end

get '/charge_lite1' do
	slim :charge_lite1
end

post '/charge_lite1' do
	@amount = 333

	token = params[:stripeToken]

    charge_lite1 = Stripe::Plan.create(
     :amount => 0333,
     :interval => 'month',
     :name => 'Lite Website',
     :currency => 'gbp',
     :id => 'lite 1'
   )
end

 
__END__
 
@@ layout
doctype html
html
  head
  body
    == yield
  
 
@@index
form action="/charge" method="post"
  article
    label class="amount"
      span Amount: $5.00
  <script src="https://checkout.stripe.com/v3/checkout.js" class="stripe-button" data-key="<%= settings.publishable_key %>"></script>
  
@@charge_lite1
form action="/charge_lite1" method="post"
  article
    label class="amount"
      span Amount: £3.33
  <script src="https://checkout.stripe.com/v3/checkout.js" class="stripe-button" data-key="<%= settings.publishable_key %>"></script>  
 
@@charge
h2 Thanks, you paid strong $5.00