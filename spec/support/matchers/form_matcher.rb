def form_field_xpaths(attr_tag_id, input_type, ph_text=nil)
  input_xpath = %Q|//#{input_type}[@id="#{attr_tag_id}"|
  input_xpath << %Q| and @placeholder="#{ph_text}"| unless ph_text.nil? or ph_text.empty?
  input_xpath << "]"

  [%Q|//label[@for="#{attr_tag_id}"]|,
   input_xpath]
end

def form_field_fail_msg(attr_tag_id, expected_xpaths)
   %Q|  expected that the page would have a form input for attribute #{attr_tag_id}
        with a label_xpath: #{expected_xpaths.first}"
        and input_xpath: "#{expected_xpaths.last}"|
end

RSpec::Matchers.define :have_input do |attr_tag_id|
  chain :placeholder do |t|
    @placeholder_text = t
  end

  match do |p|
    @expected_xpaths = form_field_xpaths(attr_tag_id, 'input', @placeholder_text)

    p.has_xpath?(@expected_xpaths.first) and p.has_xpath?(@expected_xpaths.last)
  end

  failure_message_for_should do |page|
    form_field_fail_msg(attr_tag_id, @expected_xpaths)
  end
end
