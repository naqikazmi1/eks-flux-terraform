## EKS, ECR, and Flux Deployment with Terraform

## Overview

This project automates the deployment of an Amazon EKS cluster, an ECR repository, and Flux for GitOps-driven Kubernetes management using Terraform. It ensures a fully integrated cloud-native setup for deploying and managing applications on AWS.

## Architecture

    * Amazon EKS: Managed Kubernetes cluster for running containerized workloads.

    * Amazon ECR: Private container registry to store and manage Docker images.

    * Flux: GitOps tool for continuous deployment on Kubernetes.

    * Terraform: Infrastructure as Code (IaC) tool to automate resource provisioning.

## Prerequisites

## Ensure you have the following installed:

    * Terraform

    * AWS CLI

    * kubectl

    * Flux CLI

AWS credentials configured via aws configure or environment variables.

## Deployment Steps

1. Clone the Repository

2. Initialize Terraform

3. Review and Apply Terraform Configuration

## This will create:

    An ECR repository

    An EKS cluster

    Bootstrap Flux

4. Verify Deployment

## Check if Flux components are running and workloads are being deployed:
    flux get all

Check if workloads are being deployed

## Cleanup

## Additional Notes

Adjust variables in terraform.tfvars to customize the setup.

Modify flux-system manifests for workload configurations.

## Monitor logs using: 
    kubectl logs -n flux-system -l app.kubernetes.io/name=source-controller
