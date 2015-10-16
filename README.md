# Spreedly

A wrapper of the Spreedly API.

## Installation

The package can be installed as:

  1. Add spreedly to your list of dependencies in `mix.exs`:

        def deps do
          [{:spreedly, "~> 0.0.1"}]
        end

## Usage

API interactions happen on a `Spreedly.Environment`:

```
env = Spreedly.Environment.new(environment_key, access_secret)
```

Once you have an environment, you can use it to interact with the API.

### Find Transaction

```
iex> Spreedly.Environment.find_transaction(env, "TcsSf0hpfa3K3zW5eYdSOQmR0rs")
{:ok,
 %Spreedly.Transaction{message: "Unable to process the verify transaction.",
  payment_method: %Spreedly.PaymentMethod{address1: nil, address2: nil,
   card_type: "visa", city: nil, company: nil, country: nil,
   email: "matrim@wot.com", first_name: "Matrim", first_six_digits: "401288",
   full_name: "Matrim Cauthon", last_four_digits: "1881", last_name: "Cauthon",
   month: "1", number: "XXXX-XXXX-XXXX-1881",
   payment_method_type: "credit_card", phone_number: nil, state: nil,
   storage_state: "cached", token: "L3iZqXZZovZQ0fe7QQaQmBt2UdO",
   verification_value: nil, xml: nil, year: "2019", zip: nil},
  state: "gateway_processing_failed", succeeded: false,
  token: "TcsSf0hpfa3K3zW5eYdSOQmR0qs", transaction_type: "Verification",
  xml: "<transaction>\n..."}}

iex> Spreedly.Environment.find_transaction(env, "NonExistentToken")
{:error, "Unable to find the transaction NonExistentToken."}
```

### Verify a credit card

```
iex> Environment.verify(env, "R8AKGmYwkZrrj2BpWcPgICF1eZT", "RjTFFZQp4MrH2HJbTEQuNfPwKVG")
{:ok,
 %Spreedly.Transaction{message: "Succeeded!",
  payment_method: %Spreedly.PaymentMethod{address1: nil, address2: nil,
   card_type: "master", city: nil, company: nil, country: nil,
   email: "matrim@wot.com", first_name: "Matrim", first_six_digits: "555555",
   full_name: "Matrim Cauthon", last_four_digits: "4444", last_name: "Cauthon",
   month: "1", number: "XXXX-XXXX-XXXX-4444",
   payment_method_type: "credit_card", phone_number: nil, state: nil,
   storage_state: "cached", token: "RjTFFZQp4MrH2HJbTEQuNfPwKVG",
   verification_value: nil, xml: nil, year: "2019", zip: nil},
  state: "succeeded", succeeded: true, token: "RTRa5fNadKLw8QgjCg4pAKsFLYX",
  transaction_type: "Verification", xml: "<transaction>..." }}
```

You can pattern match on the response:

```
case Environment.verify(env, "R8AKGmYwkZrrj2BpWcPgICF1eZT", "RjTFFZQp4MrH2HJbTEQuNfPwKVG") do
  {:ok, %Spreedly.Transaction{succeeded: true} ->
    IO.puts "Success!"
  {:ok, %Spreedly.Transaction{succeeded: false, message: message} ->
    IO.puts "Declined - #{message}!"
  {:error, reason} ->
    IO.inspect reason
end
```
