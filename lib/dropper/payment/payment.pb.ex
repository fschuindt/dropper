defmodule Dropper.Payment.Payer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t()
        }
  defstruct [:name, :email]

  field(:name, 1, type: :string)
  field(:email, 2, type: :string)
end

defmodule Dropper.Payment.CreateRequest do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          payer: Dropper.Payment.Payer.t(),
          method: integer
        }
  defstruct [:payer, :method]

  field(:payer, 1, type: Dropper.Payment.Payer)
  field(:method, 2, type: Dropper.Payment.Method, enum: true)
end

defmodule Dropper.Payment.CreateResponse do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          success: boolean,
          id: String.t(),
          errors: %{String.t() => String.t()}
        }
  defstruct [:success, :id, :errors]

  field(:success, 1, type: :bool)
  field(:id, 2, type: :string)
  field(:errors, 3, repeated: true, type: Dropper.Payment.CreateResponse.ErrorsEntry, map: true)
end

defmodule Dropper.Payment.CreateResponse.ErrorsEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: :string)
end

defmodule Dropper.Payment.Method do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:CC, 0)
  field(:TICKET, 1)
  field(:DEBT, 2)
end

defmodule Dropper.Payment.Create.Service do
  @moduledoc false
  use GRPC.Service, name: "dropper.payment.Create"

  rpc(:Payment, Dropper.Payment.CreateRequest, Dropper.Payment.CreateResponse)
end

defmodule Dropper.Payment.Create.Stub do
  @moduledoc false
  use GRPC.Stub, service: Dropper.Payment.Create.Service
end
