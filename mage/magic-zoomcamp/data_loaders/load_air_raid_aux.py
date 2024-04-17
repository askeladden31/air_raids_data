import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    url = 'https://github.com/Vadimkin/ukrainian-air-raid-sirens-dataset/raw/main/datasets/volunteer_data_en.csv'
    response = requests.get(url)

    parse_dates = ['started_at', 'finished_at']

    return pd.read_csv(io.StringIO(response.text), sep=',', parse_dates=parse_dates)


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
