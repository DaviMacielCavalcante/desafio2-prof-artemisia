# desafio2-prof-artemisia
 
![Licença usada](https://img.shields.io/github/license/DaviMacielCavalcante/desafio_etl_begginer)
![Python](https://img.shields.io/badge/Python-3.12.4-blue)
![Status](https://img.shields.io/badge/Status-Finalizado-brightgreen)
![Banco de Dados](https://img.shields.io/badge/Banco%20de%20Dados-PostgreSQL-blue)
![Cloud_AWS](https://img.shields.io/badge/Cloud-AWS-yellow?style=flat&color=%23FF9900)

## Descrição:
Este projeto foi desenvolvido como parte da mentoria que eu recebo. O objetivo é carregar os dados em nuvem, após serem devidamente tratados, para que estejam acessíveis para ferramentas de BI.

## Funcionalidades:
- Tratamento de dados a partir de um dataset no formato `.csv`
- Transformação de dados com limpeza, padronização e enriquecimento em SQL, inicialmente em um banco local (Postgres).
- Criação de um DataLake na cloud, com camadas: raw, silver, gold e diamond.
- Consumo dos dados via Power BI.

## Instalação:

1. Clone este repositório:
   ```bash
   git clone https://github.com/DaviMacielCavalcante/desafio2-prof-artemisia
   cd desafio2-prof-artemisia
2. Baixe o arquivo `indexData.csv` deste link `https://www.kaggle.com/datasets/mattiuzc/stock-exchange-data`
3. Na raiz do projeto, crie um diretório chamado "datasets", e ponha o arquivo `indexData.csv` nele.
 - Recomendo limpar os arquivos `.csv` presentes nas camadas do datalake, só para você ter a experiência de ver tudo acontecer ou alterar os scripts da forma que preferir.
4. Execute o scrip que é responsável por fazer a criação da camada silver:
   ```bash
   python preparando_camada_silver.py
5. Em seguida, o da camada gold:
  ```bash
   python preparando_camada_gold.py
  ```
 - Para a camada diamond, o script é o mesmo, portanto só altere as linhas 48 a 66 para que os arquivos sejam salvos no diretório da camada diamond.
7. A partir disso, crie as camadas do datalake no PostgreSQL.
8. Importe os dados dos respectivos arquivos `.csv`, se quiser pode usar via GUI com o pgAdmin ou via console conectando diretamente ao PostgreSQL.
 - Depois deste passo, você deve estar com a camada raw e a silver já presentes no banco.
9. Para a camada gold execute o script: `script_banco_gold.sql`, porém:
  - Execute inicialmente a parte do script que cria as tabelas;
  - Em seguida, importe os dados para a tabela silver;
  - Após isso, execute o resto do script para que ele possa fazer a migração dos dados para as entidades da camada gold;
  - Faça o mesmo para a camada diamond, usando o arquivo `script_banco_diamond.sql`.
10. Subindo para a cloud:
    - Crie uma conta na AWS;
    - Siga este tutorial na AWS LATAM para subir o datalake:
    ```bash
    https://youtube.com/playlist?list=PLQHh55hXC4yrBZ4yookmQPlX2zM9dZ-MH&si=lpGE6Hz2F6t37THw
    ```
    - Se quiser conectar ao Power BI, siga este tutorial:
   ```bash
    https://youtu.be/WS3LUbK0ung?si=YXc_Wy5j53Ct34z3
   ```   
10. Continue no caminho legal da força:

<div align="center"> <img src="https://media.giphy.com/media/hwj7MQ3XDPVAI/giphy.gif?cid=790b761188097q3xe9iugkqzqcw8dq1ot2unfypfy59iq2z9&ep=v1_gifs_search&rid=giphy.gif&ct=g" alt="darth_vader_local_nevando" width="500"/></div>

## Como contribuir:
Contribuições são bem-vindas! Por favor, siga estas diretrizes:

- Faça um fork do projeto.
- Crie uma branch para a funcionalidade que deseja implementar (git checkout -b minha-nova-feature).
- Faça os commits com boas descrições (git commit -m 'Adiciona nova feature').
- Faça um push para a branch criada (git push origin minha-nova-feature).
- Abra um pull request para revisão.

## Licença
Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE.md para mais detalhes.

## Contato
Se você tiver alguma dúvida ou problema, entre em contato:

e-mail: davicc@outlook.com.br

## Lordes Sith responsáveis pelo projeto
- Darth Davi ⚔️😡

## Mentora que propôs o desafio:
[Profa. Artemisia Weyl](https://www.linkedin.com/in/arteweyl/)

Github da mentora: https://github.com/arteweyl

*Through victory, my chains are broken.
<br>
The Force shall free me.*
