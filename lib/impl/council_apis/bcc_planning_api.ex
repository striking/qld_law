defmodule QldLaw.Impl.CouncilApis.BccPlanningApi do
  
  def get_zoning_data(probate) do
    case BccPlanning.return_zoning_data_for_address(probate) do
      {:ok, response} -> 
        Map.merge(probate, response)
      _ ->
        probate
    end
  end

  def get_lot_size_date(probate) do
    case BccPlanning.return_lot_data_for_address(probate) do
      {:ok, response} ->
        Map.merge(probate, response)
      _ ->
        probate
    end
  end
end
