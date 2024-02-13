import azureml

from azureml.core import Workspace, Dataset, Datastore
subscription_id = '32eef65e-f17e-4e55-a167-3b0e70b2dd9d'
resource_group = 'ai900-regression-model-rg'
workspace_name = 'ai900-regression-model-ws'
  
workspace = Workspace(subscription_id, resource_group, workspace_name)
  
datastore = Datastore.get(workspace, "workspaceworkingdirectory")
dataset = Dataset.File.from_files(path=(datastore, 'Users/frank.earnhardt'))
dataset.download(target_path='.', overwrite=True)