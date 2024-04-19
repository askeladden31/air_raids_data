# DataTalksClub Data Engineering Zoomcamp 2024 - Final Project

This project aims to provide insight on the frequency and distribution of air raid alerts in a certain country caused by attacks perpetrated by its neighbor. 
  
Specifically, at the current stage, the resulting dashboard displays the distribution of air raid alerts along the hours of the day, as well as their distribution among different regions, which can be utilized by the population for planning their daily activities, as well as contemplating their safety and sanity. 
  
Future expansions may include other data such as the number of major air strikes, types of weapons, their cumulative price, number of victims and whatnot, potentially shedding even more insights on the nature of war, vanity, life, death, universe and everything.

#TODO: add additional data sources and models

Technologies used: GCP, Terraform, Mage, BigQuery, dbt, Looker Studio

## Source datasets

At the current stage, two datasets from https://github.com/Vadimkin/ukrainian-air-raid-sirens-dataset repository are used. This external repository is updated once a day, therefore batch processing was chosen for this project. These two datasets are complimentary, and over the course of the ELT process they are combined into one dataset.

## Cloud

The project is developed in the cloud (GCP + dbt cloud), and Terraform is used to provision the necessary resources. The project is run on a Compute Engine VM. The report is created with Looker Studio.

## Data ingestion - workflow orchestration

Mage is used for workflow orchestration. Data is extracted from the source repository and stored in its raw form (albeit converted to parquet) in a GCS bucket. This raw data is then exported to the data warehouse in order to be transformed.

NOTE: The history of commits to the external repository shows that data usually gets updated by 1 AM UTC, although seldomly updates can arrive as late as 3 AM UTC. Taking this into account, a cron schedule of "0 1-4 * * *" has been chosen to automatically trigger the pipeline at 1 AM, 2 AM, 3 AM and 4 AM each day.

## Data warehouse

BigQuery is used as a data warehouse. Given the relatively small size of the source datasets (~50k records each), tables are not partitioned.

## Transformations

Transformations are defined using dbt. The source tables are combined into one, and then a denormalized model is built for the purpose of presenting the hourly distribution. This model, as well as the intermediate models, are stored in BigQuery.

NOTE: my dbt Cloud trial expired a few days before the deadline, and free account does not allow triggering the dbt deployment jobs through an API. At the current stage, the deployment job is scheduled to run at "5 1-4 * * *" in order to sync with the Mage pipeline.

#TODO: move the dbt project from dbt Cloud into the Mage pipeline in order to trigger dbt sequentially

## Dashboard

A report generated in Looker Studio connects to BigQuery to fetch the data and visualize it. The resulting dashboard can be found here: https://lookerstudio.google.com/reporting/e64f161a-75b2-4ee8-997e-5b2ac08e59eb

The project is currently live, and will remain so until April 25 (until my GCP trial expires and I will have to stop all GCP services). If you will be reviewing this project after April 25, a snapshot of the report is included here: https://github.com/askeladden31/air_raids_data/blob/main/Air_raid_alerts_in_Ukraine___Feb_2022-present_day.pdf

## Reproducibility

To reproduce the Mage pipeline:

- In your GCP project, create a service account with the following roles:  
BigQuery Admin  
Compute Admin  
Service Usage Consumer  
Storage Admin  
- Generate a private key for this service account.
- Open cloud shell (already has terraform installed).
- Choose a work directory and save the private key as "./keys/key.json".
- Download main.tf and variables.tf from this repository into your work directory.  

DISCLAIMER: I will not be held responsible for any potential costs incurring from provisioning and maintaining the infrastructure in your GCP. It is your responsibility to monitor your billing account, activated services, amount of free credits (if any), etc. Do not run this unless you fully understand what you're doing.

- Open variables.tf with your favorite editor.
- Confirm that "credentials" variable holds the relative path to your generated key.
- Change the "project" variable to refer to your GCP project.
- Change "region", "location", "zone" if required.

The remaining variables contain the names for the GCS bucket and BQ datasets that will be used by the Mage pipeline and dbt. The bucket name needs to be changed to something globally unique. As for the datasets, you can either leave them as is or choose something different. 

- Save and close.
- Open "main.tf".  

Note the machine_type for the "google_compute_instance" resource. It is currently set to "e2-standard-4". This will deploy a VM of that type and will incur the associated costs, in accordance with GCP pricing. You can change this to a different (cheaper) machine type, but I didn't test these, so your results may vary from mine.

- Close "main.tf".  
- Execute the following commands:  
terraform plan  
terraform apply  
Answer "yes" when prompted.  
  
This will provision the resources, deploy a VM and start the Mage project inside. The Mage pipeline should now be active and auto-triggering at the set schedule.

Currently, the dbt project is deployed in the cloud, and has to be reproduced separately.

#TODO: move the dbt project from dbt Cloud into the Mage pipeline in order to eliminate the need for these steps and streamline the configuration

To reproduce the dbt project:

- Fork this repository.
- Create a dbt project and configure it as described here: https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/dbt_cloud_setup.md
- When configuring the git repository in your dbt project, make it point to the "air_raids" directory in your fork.
- Under Development credentials, set the dataset to the value of the "bq_dbt_dev" variable from variables.tf (if you changed it).
- In dbt Cloud IDE create a branch for the repo. 
- Edit models/schema.yaml, so that "database" points to your GCP project name, and "schema" points to the value of the "bq_dwh" variable from variables.tf (if you changed it).
- In the Production environment settings, under Deployment credentials, set the dataset to the value of the "bq_dbt_prod" variable from variables.tf (if you changed it).
- Create a deploy job to run "dbt build" at the desired intervals.
- Commit and sync your branch. Then create a pull request. Then merge the pull request with the main branch.

The dbt project should now be running and triggering the deploy job according to the chosen schedule. The results are saved in the corresponding dataset in the data warehouse (BigQuery).

To reproduce the report:

- Open Looker Studio, create a BigQuery connector to the production dataset and fetch the fact table. Add your own tiles and visualizations.

To destroy the provisioned infrastructure in GCP:

- Run "terraform destroy" from your work directory in Google shell. Ideally, this should delete the bucket, datasets and the VM. However, it is best to double check, rerun the command if it shows any errors on the first time, and, if all else fails, stop and delete the services manually.
