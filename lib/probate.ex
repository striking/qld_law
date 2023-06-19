defmodule QldLaw.Probate do
  
  @type t :: %__MODULE__{
    full_name:                nil | String.t(),
    first_name:               nil | String.t(), 
    last_name:                nil | String.t(), 
    number:                   nil | String.t(),
    street_name:              nil | String.t(),
    street_suffix:            nil | String.t(),
    address:                  nil | String.t(), 
    suburb:                   nil | String.t(), 
    middle_name:              nil | String.t(), 
    law_firm:                 nil | String.t(),
    raw_content:              nil | String.t(),
    zoning:                   String.t(),
    lot_area:                 String.t(),
    boundary_area:            String.t(),
    parcel_house_number:      String.t(),
    corridor_street_name:     String.t(),
    parcel_suburb:            String.t(),
    development_opportunity:  String.t(),
    splitter?:                String.t()
  }

  defstruct [
    full_name: nil,
    first_name: nil, 
    last_name: nil, 
    number: nil,
    street_name: nil,
    street_suffix: nil,
    address: nil, 
    suburb: nil, 
    middle_name: nil, 
    law_firm: nil,
    raw_content: nil,
    zoning: "",
    lot_area: "",
    boundary_area: "",
    parcel_house_number: "",
    corridor_street_name: "",
    parcel_suburb: "",
    development_opportunity: "",
    splitter?: ""
  ]

@suburbs [
    "Alderley", "Enoggera", "Ferny Grove", "Gaythorne", "Grange", "Lutwyche", "Newmarket", "Herston", "Wilston", "Everton", "Mcdowall", 
    "Mitchelton", "Chermside", "Grovely", "Keperra", "Dorrington", "St Johns Wood", "Oxford Park", "Stafford", "Gordon", "Kedron", "Kalinga", "Lutwyche", 
    "Windsor", "Wooloowin", "Nundah", "Northgate", "Toombul", "Wavell", "Clayfield", "Albion", "Eagle Juction", "Hendra", "Milton", "Paddington", 
    "Rosalie", "The Gap", "Gap", "Ashgrove", "Bardon", "Rainworth", "Auchenflower", "Torwood", "Jubilee", "Coot-tha", "Toowong", "St Lucia", "Chelmer", 
    "Indooroopilly", "Taringa", "Sherwood", "Graceville", "Tennyson", "Oxley", "Corinda", "Rocklea", "Ellen Grove", "Inala", "Darra", 
    "Richlands", "Durack", "Forest Lake", "Doolandella", "Pallara", "Caboolture South"]

@address ~w[
    Aged Aveo Bupa BUPA Regis Uniting Wesley Anglicare unit Unit 
    ]

  # @spec filter_by_address({:ok, list(map)}) :: {:ok, list(map)}
  # def filter_by_address({:ok, content}) do
  #   result = content
  #   |> Enum.reject(&is_nil(&1.address))
  #   |> Enum.reject(&String.contains?(&1.address, @address))
  #   
  #   {:ok, result}
  # end

  def filter_by_address({:ok, content}) do
    result = filter_if_list(content, fn probate ->
      probate.address && !String.contains?(probate.address, @address)
    end)

    {:ok, result}
  end

  def filter_by_address(error), do: error

  @spec filter_by_suburb({:ok, list(map)}) :: {:ok, list(map)}
  def filter_by_suburb({:ok, content}) do
    result = content
    |> Enum.reject(&is_nil(&1.suburb)) 
    |> Enum.filter(&String.contains?(&1.suburb, @suburbs))  

    {:ok, result}
  end

  
  def filter_by_suburb(error), do: error

  def reject_non_developable({:ok, content}) do
    result = content
    |> Enum.reject(&String.contains?(&1.development_opportunity, "NO"))
    
    {:ok, result}
  end

  def reject_non_developable(error), do: error

  defp filter_if_list({:ok, list}, filter_fn) when is_list(list) do
    {:ok, Enum.filter(list, filter_fn)}
  end
  defp filter_if_list(error, _), do: error
  
end
