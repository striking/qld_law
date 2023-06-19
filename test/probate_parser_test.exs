defmodule QldLaw.ProbateParserTest do
  use ExUnit.Case
  alias Enumerable.Date
  alias QldLaw.Impl.ProbateParser

@content_samples [
{"After 14 days from today an application for a grant of Probate of the Will dated 22 July 2022 of DANE
KENNETH ADAMS late of 12 Terben Street, Warner in the State of Queensland deceased will be made
by KENNETH JAMES ADAMS to the Supreme Court at Townsville.
You may object to the grant by lodging a caveat in that registry.
Any person having any claim, whether as creditor or beneficiary or otherwise, is required to send in
particulars of the claim to the applicant’s solicitors no later than six weeks from the date of publication
of this notice.
Lodged by: SMITH & STANTON, Lawyers, 10 Pritchard Rd, Virginia, Q 4014.", "DANE KENNETH ADAMS"},
{"After 14 days from today an application for a grant of Probate of the Will dated 30 November 1990 of
ROBERT AIKEN late of 1/12 Eastern Court, Mount Coolum in the State of Queensland, deceased will
be made by LISA GAYE TATTERSON to the Supreme Court at Brisbane.
All persons or creditors having a claim against the estate of the deceased are hereby required to send
in particulars of their claims to the undersigned within six weeks from the date hereof, at the expiration
of which time, pursuant to Section 67 of the Trusts Act 1973, the Applicant will proceed to distribute the
assets of the deceased among the persons entitled thereto, having regard only to the claims of which
the said Applicant shall then have had notice.
You may object to the grant by lodging a Caveat in that Registry.
Lodged by: LEVER LAW SOLICITORS of 9/175 Ocean Drive, Twin Waters, Qld 4564.", "ROBERT AIKEN"},
{"After 14 days from today an application for a grant of letters of administration on intestacy of PHILLIP
APOSTLE, late of 72 Cross Street, Deception Bay in the State of Queensland, deceased, will be made
by BOZENNA ANTONINA SIKORA to the Supreme Court at Brisbane.
You may object to the grant by lodging a caveat in that registry.
Lodged by: QLD LAW GROUP PTY LTD, 100 Wharf Street, Brisbane, Qld 4000.
Queensland Law Reporter – 4 November 2022 – [2022] 43 QLR", "PHILLIP APOSTLE"}
] 


  # setup do
  #   # Read the test dad into a variable
  #   test_data = File.read!("test/support/test.txt")
  #   # Pass the test data to the tests
  #   {:ok, test_data: test_data}
  # end


 for {content, expected_full_name} <- @content_samples do
    @content content
    @expected_full_name expected_full_name
  test "extract_full_name extracts #{@expected_full_name} from the content}" do
    assert ProbateParser.extract_full_name(@content) == @expected_full_name
  end
 end

end
