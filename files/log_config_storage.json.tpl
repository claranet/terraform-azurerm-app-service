{
  "properties": {
    "applicationLogs": {
      "azureBlobStorage": {
        "level": "Error",
        "retentionInDays": ${logs_retention},
        "sasUrl": "https://${storage_account_name}.blob.core.windows.net/${storage_account_container}?$sas_token"
      },
      "azureTableStorage": {"level": "Off", "sasUrl": null},
      "fileSystem": {"level": "Off"}
    },
    "detailedErrorMessages": {"enabled": true},
    "failedRequestsTracing": {"enabled": true},
    "httpLogs": {
      "azureBlobStorage": {
        "enabled": true,
        "retentionInDays": ${logs_retention},
        "sasUrl": "https://${storage_account_name}.blob.core.windows.net/${storage_account_container}?$sas_token"
      },
      "fileSystem": {
        "enabled": false,
        "retentionInDays": null,
        "retentionInMb": 42
      }
    }},
    "kind": null 
  }
}
