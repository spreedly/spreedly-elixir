# Spreedly [![Hex pm](http://img.shields.io/hexpm/v/spreedly.svg?style=flat)](https://hex.pm/packages/spreedly) [![hex.pm downloads](https://img.shields.io/hexpm/dt/spreedly.svg?style=flat)](https://hex.pm/packages/spreedly)

A wrapper of the Spreedly API ([documentation](http://hexdocs.pm/spreedly/)). This library is not officially supported.

## Installation

The package can be installed by adding spreedly to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:spreedly, "~> 2.0"}]
end
```

Add it to your application dependency:

```elixir
def application do
  [applications: [:spreedly]]
end
```

## Configuration

Spreedly Elixir has a limited number of configuration options that you can override in your project specific configuration files. The options include specifying the receive timeout.

```elixir
config :spreedly,
  receive_timeout: value  # Defaults to 10_000 milliseconds
```

## Usage

API interactions happen with a `Spreedly.Environment`.

```elixir
env = Spreedly.Environment.new(environment_key, access_secret)
```

Once you have an environment, you can use it to interact with the API.

### Run a purchase using a credit card

You can pattern match on the response.

```elixir
case Spreedly.purchase(env, "R8AKGmYwkZrrj2BpWcPge", "RjTFFZQp4MrH2HJNfPwK", 2344) do
  {:ok, %{succeeded: true}} ->
    IO.puts "Success!"
  {:ok, %{succeeded: false, message: message}} ->
    IO.puts "Declined - #{message}!"
  {:error, reason} ->
    IO.inspect reason
end
```

### Show a Transaction

```elixir
iex> Spreedly.show_transaction(env, "TcsSf0hpfa3K3zW5eYdSOQmR0rs")
{:ok,
 %{created_at: "2016-01-10T16:36:14Z", currency_code: nil, description: nil,
   email: nil, gateway_specific_fields: nil,
   gateway_specific_response_fields: %{},
   gateway_token: "LJzOP1BwPkmgmiieHKpNT5xmqyU", gateway_transaction_id: nil,
   ip: nil, merchant_location_descriptor: nil, merchant_name_descriptor: nil,
   message: "Unable to process the verify transaction.", on_test_gateway: true,
   order_id: nil,
   payment_method: %{first_name: "Matrim", storage_state: "cached",
     first_six_digits: "401288", shipping_phone_number: nil, card_type: "visa",
     company: nil, number: "XXXX-XXXX-XXXX-1881", shipping_address1: nil,
     token: "IRfuy5hKmBpu4bqCHdPE621uEac", state: nil, year: 2019,
     fingerprint: "7d59b8215d44351c9a9801fbe61b0e8e4657",
     full_name: "Matrim Cauthon", updated_at: "2016-01-10T16:36:14Z",
     errors: [], phone_number: nil, shipping_country: nil,
     verification_value: "", data: nil, city: nil, shipping_city: nil,
     last_four_digits: "1881", last_name: "Cauthon",
     eligible_for_card_updater: nil, shipping_address2: nil, zip: nil,
     country: nil, test: true, shipping_zip: nil, email: "matrim@wot.com",
     shipping_state: nil, month: 1, created_at: "2016-01-10T16:36:14Z",
     payment_method_type: "credit_card", ...},
   response: %{avs_code: nil, avs_message: nil, cancelled: false,
     created_at: "2016-01-10T16:36:14Z", cvv_code: nil, cvv_message: nil,
     error_code: "", error_detail: nil, fraud_review: nil,
     message: "Unable to process the verify transaction.", pending: false,
     result_unknown: false, success: false, updated_at: "2016-01-10T16:36:14Z"},
   response_body: "{\"transaction\":{\"on_test_gateway\":true,\"created_at\":\"2016-01-10T16:36:14Z\",\"updated_at\":\"2016-01-10T16:36:14Z\",\"succeeded\":false,\"state\":\"gateway_processing_failed\",\"token\":\"8A8vvB2RbbL41CRz7YYUbAQW5Yw\",\"transaction_type\":\"Verification\",\"order_id\":null,\"ip\":null,\"description\":null,\"email\":null,\"merchant_name_descriptor\":null,\"merchant_location_descriptor\":null,\"gateway_specific_fields\":null,\"gateway_specific_response_fields\":{},\"gateway_transaction_id\":null,\"currency_code\":null,\"retain_on_success\":null,\"message\":\"Unable to process the verify transaction.\",\"gateway_token\":\"LJzOP1BwPkmgmiieHKpNT5xmqyU\",\"response\":{\"success\":false,\"message\":\"Unable to process the verify transaction.\",\"avs_code\":null,\"avs_message\":null,\"cvv_code\":null,\"cvv_message\":null,\"pending\":false,\"result_unknown\":false,\"error_code\":\"\",\"error_detail\":null,\"cancelled\":false,\"fraud_review\":null,\"created_at\":\"2016-01-10T16:36:14Z\",\"updated_at\":\"2016-01-10T16:36:14Z\"},\"shipping_address\":{\"name\":\"Matrim Cauthon\",\"address1\":null,\"address2\":null,\"city\":null,\"state\":null,\"zip\":null,\"country\":null,\"phone_number\":null},\"payment_method\":{\"token\":\"IRfuy5hKmBpu4bqCHdPE621uEac\",\"created_at\":\"2016-01-10T16:36:14Z\",\"updated_at\":\"2016-01-10T16:36:14Z\",\"email\":\"matrim@wot.com\",\"data\":null,\"storage_state\":\"cached\",\"test\":true,\"last_four_digits\":\"1881\",\"first_six_digits\":\"401288\",\"card_type\":\"visa\",\"first_name\":\"Matrim\",\"last_name\":\"Cauthon\",\"month\":1,\"year\":2019,\"address1\":null,\"address2\":null,\"city\":null,\"state\":null,\"zip\":null,\"country\":null,\"phone_number\":null,\"company\":null,\"full_name\":\"Matrim Cauthon\",\"eligible_for_card_updater\":null,\"shipping_address1\":null,\"shipping_address2\":null,\"shipping_city\":null,\"shipping_state\":null,\"shipping_zip\":null,\"shipping_country\":null,\"shipping_phone_number\":null,\"payment_method_type\":\"credit_card\",\"errors\":[],\"fingerprint\":\"7d59b8215d44351c9a9801fbe61b0e8e4657\",\"verification_value\":\"\",\"number\":\"XXXX-XXXX-XXXX-1881\"}}}",
   retain_on_success: nil,
   shipping_address: %{address1: nil, address2: nil, city: nil, country: nil,
     name: "Matrim Cauthon", phone_number: nil, state: nil, zip: nil},
   state: "gateway_processing_failed", succeeded: false,
   token: "TcsSf0hpfa3K3zW5eYdSOQmR0rs", transaction_type: "Verification",
   updated_at: "2016-01-10T16:36:14Z"}}

iex> Spreedly.find_transaction(env, "NonExistentToken")
{:error, "Unable to find the transaction NonExistentToken."}
```

## Contributing

We're happy to consider [pull requests](https://help.github.com/articles/creating-a-pull-request-from-a-fork/).

To help ensure a consistent code style and passing tests, we ask that you execute `script/test` before submitting the PR. The test script runs Credo, Dialyzer and the remote test suite.

Upon success, it will output a message like:

`Successful Full Test Suite Run at 2018-03-09 20:52:15`

Include the success message output as the last line in the commit message for the pull request.

### Example script/test output

```bash
# Run Credo, Dialyzer and remote tests
script/test

# Output
Checking 5 source files ...

Please report incorrect results: https://github.com/rrrene/credo/issues

Analysis took 0.4 seconds (0.02s to load, 0.4s running checks)
79 mods/funs, found no issues.

Checking PLT...
...
PLT is up to date!
Starting Dialyzer
...
done in 0m4.14s
done (passed successfully)

Compiling 6 files (.ex)
Generated spreedly app
Including tags: [:remote]
Excluding tags: [remote: true]

..............................................................................

Finished in 9.8 seconds
78 tests, 0 failures

Randomized with seed 25230

Successful Full Test Suite Run at 2018-03-09 20:52:15
```
