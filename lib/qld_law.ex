defmodule QldLaw do

  alias QldLaw.Impl.PublicNotices
  
  @spec export_deceased_probate_notices(String.t() | list(String.t())):: list()  
  defdelegate export_deceased_probate_notices(files), to: PublicNotices, as: :export_public_notices 

  @spec export_deceased_probate_notices_to_csv(String.t() | list(String.t())) :: list()
  defdelegate export_deceased_probate_notices_to_csv(files), to: PublicNotices, as: :export_public_notices_to_csv 
end
