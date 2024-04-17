if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

#existing_values_of_VendorID = set()
existing_values_of_vendor_id = set()

@transformer
def transform(data, data_2, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # Specify your transformation logic here

    zero_or_nan_passengers = data['passenger_count'].isna() | (data['passenger_count']==0)
    zero_or_nan_distances = data['trip_distance'].isna() | (data['trip_distance']==0)
    invalid_rows = (zero_or_nan_passengers | zero_or_nan_distances).sum()
    
    print(f"Rows with invalid passenger count or trip distance: {invalid_rows}")
    print(f"Expected row count after cleanup: {len(data)-invalid_rows}")

    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]

    data['lpep_pickup_date']=data['lpep_pickup_datetime'].dt.date

    #existing_values_of_VendorID.update(data['VendorID'].unique())
    existing_values_of_VendorID = data['VendorID'].unique()

    print(f"Existing values of VendorID: {existing_values_of_VendorID}")

    if not data_2.empty:
        print('Found currently existing values in vendor_id')
        existing_values_of_vendor_id.update(data_2['vendor_id'])

    new_columns = data.columns.str.replace(r'([a-z])([A-Z])', r'\1_\2', regex=True).str.replace(r'([A-Z])([A-Z])([a-z])', r'\1_\2\3', regex=True).str.lower()

    diff = new_columns == data.columns

    data.columns = new_columns

    print(f"Number of columns renamed to snake_case: {len(diff)-sum(diff)}")

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """

    # assert output is not None, 'The output is undefined'
    #assert_against = existing_values_of_VendorID
    assert_against = existing_values_of_vendor_id

    assert 'vendor_id' in output.columns
    if assert_against:
        print('Asserting against existing values')
        assert (output['vendor_id'].isin(assert_against)).all()
    assert (output['passenger_count']>0).all()
    assert (output['trip_distance']>0).all()