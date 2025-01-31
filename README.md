# **challenge2-prof-artemisia**

![License Used](https://img.shields.io/github/license/DaviMacielCavalcante/desafio_etl_begginer)
![Python](https://img.shields.io/badge/Python-3.12.4-blue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue)
![Cloud_AWS](https://img.shields.io/badge/Cloud-AWS-yellow?style=flat&color=%23FF9900)

## **Description:**  
This project was developed as part of the mentorship I receive. The goal is to load the data into the cloud, after being properly processed, so that they are accessible to BI tools.  

## **Features:**  
- Data processing from a dataset in `.csv` format  
- Data transformation with cleaning, standardization, and enrichment in SQL, initially in a local database (PostgreSQL).  
- Creation of a DataLake in the cloud, with layers: raw, silver, gold, and diamond.  
- Data consumption via BI tool.  

## **Installation:**  

1. Clone this repository:  
   ```bash
   git clone https://github.com/DaviMacielCavalcante/desafio2-prof-artemisia
   cd desafio2-prof-artemisia
   ```
2. Download the `indexData.csv` file from this link:  
   ```bash
   https://www.kaggle.com/datasets/mattiuzc/stock-exchange-data
   ```
3. In the root of the project, create a directory called "datasets" and place the `indexData.csv` file inside it.  
   - It is recommended to clean the `.csv` files present in the DataLake layers to experience everything happening or modify the scripts as you prefer.  
4. Run the script responsible for creating the silver layer:  
   ```bash
   python preparando_camada_silver.py
   ```
5. Next, run the gold layer script:  
   ```bash
   python preparando_camada_gold.py
   ```
6. Finally, run the diamond layer script:  
   ```bash
   python preparando_camada_diamond.py
   ```  
7. Uploading to the cloud:  
    - Create an AWS account;  
    - Follow this AWS LATAM tutorial to upload the DataLake:  
    ```bash
    https://youtube.com/playlist?list=PLQHh55hXC4yrBZ4yookmQPlX2zM9dZ-MH&si=lpGE6Hz2F6t37THw
    ```  
    - If you want to connect to Power BI, follow this tutorial:  
    ```bash
    https://youtu.be/WS3LUbK0ung?si=YXc_Wy5j53Ct34z3
    ```   
8. Stay on the right side of the Force:  

<div align="center">  
<img src="https://media.giphy.com/media/hwj7MQ3XDPVAI/giphy.gif?cid=790b761188097q3xe9iugkqzqcw8dq1ot2unfypfy59iq2z9&ep=v1_gifs_search&rid=giphy.gif&ct=g" alt="darth_vader_local_snowing" width="500"/>  
</div>  

## **How to Contribute:**  
Contributions are welcome! Please follow these guidelines:  

- Fork the project.  
- Create a branch for the feature you want to implement (`git checkout -b my-new-feature`).  
- Commit your changes with meaningful descriptions (`git commit -m 'Add new feature'`).  
- Push to the created branch (`git push origin my-new-feature`).  
- Open a pull request for review.  

## **License:**  
This project is licensed under the MIT License - see the `LICENSE.md` file for more details.  

## **Contact:**  
If you have any questions or issues, feel free to contact:  
📧 Email: **davicc@outlook.com.br**  

## **Sith Lords Responsible for the Project:**  
- **Darth Davi** ⚔️😡  

## **Mentor Who Proposed the Challenge:**  
[Prof. Artemisia Weyl](https://www.linkedin.com/in/arteweyl/)  

👩‍💻 Mentor’s GitHub: [https://github.com/arteweyl](https://github.com/arteweyl)  

*Through victory, my chains are broken.  
The Force shall free me.*

