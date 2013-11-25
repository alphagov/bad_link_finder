class Minitest::Test
  def assert_same_elements(array1, array2)
    assert_equal array1.to_set, array2.to_set, "Different elements in #{array1.inspect} and #{array2.inspect}"
  end
end
