# Accelerating Drug Discovery Using Generative AI

The project detailed in this repository can be accessed using the following link:

https://drugs-c339a.web.app/

## Introduction

Hey everyone! We are team **Good Question**, and this is our submission for **Google's Solution Challenge 2025**.

## Description About The Problem Statement and our Solution

Drug Discovery is a very extensive and expensive process, taking up many years of research and thousands of dollars to complete. For Google's Solution Challenge 2025, we decided to tackle the problem of using AI and Google's Tech to speed things up.

## Input

The website is built using **Flutter (and Dart)** and hosted using **Firebase Hosting**. 

The Home Page shows the section where you can input your parameters about the Targeted Protein including, potency, ingestion method, properties, and constraints. You can even upload a file about the target protein to help generate potential drug candidates by clicking **"Upload PDF"**. 

![image](https://github.com/user-attachments/assets/49253e8c-4fb3-4803-bc94-a05f231f97c8)
![image](https://github.com/user-attachments/assets/7af5ccfd-649d-488f-8ed0-07fd7d8a35fa)

Once entered, click **"Submit & Generate"**. 

## Output

Here **Gemini API** with a bit of prompt engineering, will generate a potential drug candidate. 
The AI will give a the structure of the potential candidate along with its properties, side effects, shelf life, description about its interaction with the protein and any more extra details.

![image](https://github.com/user-attachments/assets/61a52ed8-a9b8-4402-ac54-9ecce054da24)

Once a response has been generated, you can download the response as a document by clicking **"Download Report"**.

## Optimization

You can optimize the results by adding some new parameters in the optimization box below. This will take the previous response and the optimization parameters to modify the current drug candidate. 

![image](https://github.com/user-attachments/assets/113e2bd2-cd0d-44e4-9f4e-a88c76aaf7a1)

## About and Documentation

And about page and documentation page are located on the header of the website. 

The about page gives a brief description of the website and the problem statement.
The documentation page gives instructions on how to use the website.


