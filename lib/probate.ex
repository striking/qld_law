defmodule QldLaw.Probate do
  
  @type t :: %__MODULE__{
    full_name: atom() | String.t(),
    first_name: atom() | String.t(), 
    last_name: atom() | String.t(), 
    address: atom() | String.t(), 
    suburb: atom() | String.t(), 
    middle_name: atom() | String.t(), 
    law_firm: atom() | String.t(),
    raw_content: atom() | String.t(),
  }

  defstruct [
    full_name: nil,
    first_name: nil, 
    last_name: nil, 
    address: nil, 
    suburb: nil, 
    middle_name: nil, 
    law_firm: nil,
    raw_content: nil,
  ]

@suburbs ~w[
    Alderley Enoggera Gaythorne Grange Lutwyche Newmarket Herston Wilston Everton Mcdowall 
    Mitchelton Chermside Grovely Keperra Dorrington Stafford Gordon Kedroin Kalinga Lytwyche 
    Windsor Wooloowin Nundah Northgate Toombul Wavell Clayfield Albion Hendra Milton Paddington 
    Rosalie Gap Ashgrove Bardon Rainworth Auchenflower Torwood Jubilee Toowong Chelmer 
    Indooroopilly Taringa Sherwood Graceville Tennyson Oxley Corinda Rocklea Inala Darra 
    Richlands Durack Doolandella Pallara 
    ]

@address ~w[
    Aged Aveo Bupa BUPA Regis Uniting Wesley Anglicare unit 
    ]

  @spec filter_by_address(list(map)) :: list(map)
  def filter_by_address(content) do
    content
    |> Enum.reject(&is_nil(&1.address))
    |> Enum.reject(&String.contains?(&1.address, @address))
  end

  @spec filter_by_suburb(list(map)) :: list(map)
  def filter_by_suburb(content) do
    content
    |> Enum.reject(&is_nil(&1.suburb)) 
    |> Enum.filter(&String.contains?(&1.suburb, @suburbs))  
  end
  
end
