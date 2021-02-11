# IaC for Cloud Run

Create and manage a Cloud Run application in terraform

## Deployment

1.  Create a `terraform.tfvars` file with a minimum of `project` and    
    `domains` variables defined.

1.  Create the public IP address with a targeted apply.
    ```
    terraform apply -target google_compute_global_address.app -out run.plan
    terraform apply run.plan
    ```

1.  Update dns for each domain in the `domains` list to point to the created
    public IP.  Then create the rest of the infrastructure.
    ```
    terraform apply
    ```

## App Requirements

#### [Container runtime contract](https://cloud.google.com/run/docs/reference/container-contract)

*   The container must listen for requests on `0.0.0.0`.
*   By default, requests are sent to port `8080`.
*   The `PORT` env var in the runtime always contains the port used for requests.

#### App Access
Developer request against a service without `public_access` enabled.
```
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" SERVICE_URL
```

## Additional Links

*   [Decode jwt in local shell](https://gist.github.com/lounagen/bdcf3e59122e80bae6da114352d0280c)


## Next Steps
*   [Continuous deployment with Cloud Build](https://cloud.google.com/run/docs/continuous-deployment-with-cloud-build)
*   [Github app triggers](https://cloud.google.com/cloud-build/docs/automating-builds/create-github-app-triggers#different_types_of_github-based_triggers)
*   [Url-maps for app with multiple back ends](https://github.com/terraform-google-modules/terraform-google-lb-http/tree/master/modules/serverless_negs)
