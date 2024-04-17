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
    taxi_dtypes = {
                    'PULocationID':pd.Int64Dtype(),
                    'DOLocationID':pd.Int64Dtype(),
                    'SR_Flag': pd.Int64Dtype(),
                }

    parse_dates = ['pickup_datetime', 'dropOff_datetime']

    df_list = []

    for month in range(11, 12):
        url = f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-{str(month+1).zfill(2)}.csv.gz'
        print(f'Loading from {url}...')
        df_iter = pd.read_csv(url, dtype=taxi_dtypes, parse_dates=parse_dates, iterator=True, chunksize=100000)
        for chunk in df_iter:
            df_list.append(chunk)
    
    print(f'A total of {len(df_list)} chunks loaded. ')

    dict_list = [df.to_dict(orient='records') for df in df_list]

    return [df_list]


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
