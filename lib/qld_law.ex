defmodule QldLaw do

  alias QldLaw.Impl.PublicNotices
  
  @doc """
    Expoert deceased probate notices.

    ## Params

    - 'files': A nonempty list of file paths

    ## Returns

    - A list of results ferom the export operation

    """
  @spec export_deceased_probate_notices(String.t() | list(String.t())):: list()  
  defdelegate export_deceased_probate_notices(files), to: PublicNotices, as: :export_public_notices 

  @doc """
    Export deceased probate notices to a CSV file.

    ## Params

    - 'files': A nonempty list of file paths

    ## Returns

    - A list of results from the export operations

    """
  @spec export_deceased_probate_notices_to_csv(String.t() | list(String.t())) :: list()
  defdelegate export_deceased_probate_notices_to_csv(files), to: PublicNotices, as: :export_public_notices_to_csv 
end
