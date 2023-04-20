# CI/CD

The resources in this directory are a pre-requisite for the project. The image resources need to exist before the cluster and subsequent resources can be created. The separation also allows for creating/destroynig the main project resources without having to rebuild the image, re-setup the IAM role secret, etc.
